#!/bin/sh

# xl2tpd.sh -- xl2tpd connect / disconnect
#
# Copyright (C) 2014 Zeno Zeng <zenoofzeng@gmail.com>
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

xl2tpd_restart() {

    # for Openwrt / Debian / Ubuntu
    type systemctl >/dev/null 2>&1 || {
        /etc/init.d/xl2tpd restart
    }

    # for arch linux
    type systemctl >/dev/null 2>&1 && {
        systemctl xl2tpd restart
    }
    
    # wait until ready
    for i in $(seq 0 "${TIMEOUT}"); do
        if [ -e "/var/run/xl2tpd/l2tp-control" ]; then
            return 0
        fi
        sleep 1
    done

}

connect() {
    username=$1
    password=$2

    # TODO
}

disconnect() {
    username=$1
    password=$2

    # TODO
}


case $1 in

    connect)
        connect $2 $3
        ;;

    disconnect)
        disconnect $2 $3
        ;;

esac
