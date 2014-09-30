#!/bin/sh

# xl2tpd.sh -- xl2tpd connect / disconnect
#
# Copyright (C) 2014 Zeno Zeng <zenoofzeng@gmail.com>
# Copyright (C) 2014 Zhang Hai <Dreaming.in.Code.ZH@Gmail.com>
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
PPP_LOG_FILE=/tmp/zju-l2tp-log
PPP_OPT_FILE=/etc/ppp/peers/${LAC_NAME}

mkdir -p /var/log/zjunet/
LOG_FILE=/var/log/zjunet/${USERNAME}

XL2TPD_CONTROL_FILE=/var/run/xl2tpd/l2tp-control

xl2tpd_stop() {
    # for Openwrt / Debian / Ubuntu
    type systemctl >/dev/null 2>&1 || {
        /etc/init.d/xl2tpd stop
    }

    # for Arch Linux
    type systemctl >/dev/null 2>&1 && {
        systemctl xl2tpd stop
    }

}

xl2tpd_start() {
    # for Openwrt / Debian / Ubuntu
    type systemctl >/dev/null 2>&1 || {
        /etc/init.d/xl2tpd start
    }

    # for Arch Linux
    type systemctl >/dev/null 2>&1 && {
        systemctl xl2tpd start
    }
}

xl2tpd_restart() {

    xl2tpd_stop
    rm -f ${XL2TPD_CONTROL_FILE}
    xl2tpd_start
    
    # wait until ready
    for i in $(seq 0 10); do
        if [ -e ${XL2TPD_CONTROL_FILE} ]; then
            echo "[INFO] xl2tpd ready."
            return 0
        fi
        sleep 1
    done

    echo "Fail to start xl2tpd"
    exit 1
}

xl2tpd_create_lac() {
    touch $PPP_LOG_FILE

    cat > $PPP_OPT_FILE <<EOF
noauth
linkname $LAC_NAME
logfile $PPP_LOG_FILE
name $USERNAME
password $PASSWORD
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
    xl2tpd-control connect $1
}

xl2tpd_disconnect() {
    xl2tpd-control disconnect $1
}

connect() {
    xl2tpd_disconnect ${LAC_NAME}
    xl2tpd_connect ${LAC_NAME}

    echo -n > $PPP_LOG_FILE

    prev_count=$(ip addr show | grep 'inet.*ppp' | grep ' 10.5.' | wc -l)

    for i in $(seq 0 10000); do

        tail $PPP_LOG_FILE
        tail $PPP_LOG_FILE >> $LOG_FILE
        if [ $(tail $PPP_LOG_FILE | grep 'Connection terminated' | wc -l) -ne 0 ]
        then
            echo "[INFO] Connection terminated."
            echo -n > $PPP_LOG_FILE
            echo "[INFO] Retrying now. (force kicking off, may take some time)"
            xl2tpd_disconnect ${LAC_NAME}
            sleep 1
            xl2tpd_connect ${LAC_NAME}
        fi
        echo -n > $PPP_LOG_FILE

        count=$(ip addr show | grep 'inet.*ppp' | grep ' 10.5.' | wc -l)
        if [ ${count} -gt ${prev_count} ]; then
            echo "Bring up ppp, done."
            return
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

    adduser)
        xl2tpd_create_lac
        ;;

    connect)
        connect
        ;;

    disconnect)
        disconnect
        ;;
esac
