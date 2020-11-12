#!/bin/sh

# xl2tpd.sh -- xl2tpd connect / disconnect
#
# Copyright (C) 2014 Zeno Zeng <zenoofzeng@gmail.com>
# Copyright (C) 2014 Zhang Hai <Dreaming.in.Code.ZH@Gmail.com>
# Copyright (C) 2014 Xero Essential <x@xeroe.net || xqyww123@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see
# <http://www.gnu.org/licenses/>.

LNS="10.5.1.9"
L2TPD_CFG_FILE=/etc/xl2tpd/xl2tpd.conf

USERNAME=$2
PASSWORD=$3
LAC_NAME=zju-l2tp-${USERNAME}
PPP_LOG_FILE=/tmp/zju-l2tp-log-${USERNAME}
PPP_OPT_FILE=/etc/ppp/peers/${LAC_NAME}

mkdir -p /var/log/zjunet/
LOG_FILE=/var/log/zjunet/${USERNAME}

XL2TPD_CONTROL_FILE=/var/run/xl2tpd/l2tp-control

type systemctl >/dev/null 2>&1
HAVE_SYSTEMD=$?

xl2tpd_stop() {
    echo "[INFO] Stopping xl2tpd"
    if [ $HAVE_SYSTEMD -eq 0 ]; then
        systemctl stop xl2tpd
    else
        /etc/init.d/xl2tpd stop
    fi
}

xl2tpd_start() {
    echo "[INFO] Starting xl2tpd"
    if [ $HAVE_SYSTEMD -eq 0 ]; then
        systemctl start xl2tpd
    else
        /etc/init.d/xl2tpd start
    fi

    # wait until ready
    for i in $(seq 0 10); do
        if [ -e ${XL2TPD_CONTROL_FILE} ] || (type systemctl >/dev/null && systemctl status xl2tpd >/dev/null) ; then
            echo "[INFO] xl2tpd ready."
            return 0
        fi
        sleep 1
    done

    echo "Fail to start xl2tpd"
    exit 1
}

xl2tpd_trystart() {
    echo "[INFO] Try to start xl2tpd if not"
    if [ -e ${XL2TPD_CONTROL_FILE} ] || (type systemctl >/dev/null && systemctl status xl2tpd >/dev/null); then
        echo "[INFO] xl2tpd ready."
    else
        xl2tpd_start
    fi
}

xl2tpd_restart() {
    xl2tpd_stop
    rm -f ${XL2TPD_CONTROL_FILE}
    xl2tpd_start
}

xl2tpd_create_lac() {

    cat > $PPP_OPT_FILE <<EOF
noauth
linkname $LAC_NAME
logfile $PPP_LOG_FILE
name $USERNAME
password $PASSWORD
mtu 1428
EOF
    chmod 600 $PPP_OPT_FILE

    touch $L2TPD_CFG_FILE
    if ! grep -q "\[lac ${LAC_NAME}\]" $L2TPD_CFG_FILE; then
        cat >> $L2TPD_CFG_FILE <<EOF
[lac ${LAC_NAME}]
lns = $LNS
redial = no
redial timeout = 5
require chap = yes
require authentication = no
ppp debug = no
pppoptfile = ${PPP_OPT_FILE}
require pap = no
autodial = yes

EOF
    fi
}

xl2tpd_connect() {
    echo "[INFO] try connecting $1"
    pkill xl2tpd-control > /dev/null
    xl2tpd-control connect-lac $1 &
    echo "[INFO] xl2tpd-control done"
}

xl2tpd_disconnect() {
    echo "[INFO] try disconnecting $1"
    pkill xl2tpd-control > /dev/null
    xl2tpd-control disconnect-lac $1 &
    echo "[INFO] xl2tpd-control done"
}

xl2tpd_waituser() {
    for i in $(seq 0 10000); do

        tail $PPP_LOG_FILE >> $LOG_FILE
        if [ $(tail $PPP_LOG_FILE | grep 'Connection terminated' | wc -l) -ne 0 ]
        then
            echo "[INFO] Connection terminated."
            echo -n > $PPP_LOG_FILE
            echo "[INFO] Retrying now. "
            sleep 1
            xl2tpd_disconnect ${LAC_NAME}
            sleep 5
            xl2tpd_connect ${LAC_NAME}
            echo "[INFO] again"
        fi
        echo -n > $PPP_LOG_FILE

        pid="/var/run/ppp-${LAC_NAME}.pid"
        if [ -e $pid ]; then
            ppp=$(cat $pid | grep ppp)
            if ip addr show | grep "inet.*${ppp}" > /dev/null; then
                ip addr show | grep "inet.*${ppp}" | sed 's/^ */[VPN] /'
                return
            fi
        fi

    done

    echo "Fail to bring up ppp, timeout."

    xl2tpd_disconnect ${LAC_NAME}
}

disconnect() {
    xl2tpd_disconnect ${LAC_NAME}
    tail $PPP_LOG_FILE
    echo -n > $PPP_LOG_FILE
}

case $1 in

    restart)
        xl2tpd_restart
        ;;

    trystart)
        # will start unless already started
        xl2tpd_trystart
        ;;

    adduser)
        xl2tpd_create_lac
        ;;

    waituser)
        xl2tpd_waituser
        ;;

    disconnect)
        disconnect
        ;;
esac
