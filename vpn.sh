#!/bin/sh

# vpn.sh -- xl2tpd connect / disconnect
#
# Requirements: xl2tpd
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

start_xl2tpd() {
    echo 'start xl2tpd'
}

disconnect() {
    echo 'disconnect'
}

set_up_routes() {
    IP=$(ip route show 0/0 | cut -d " " -f 3)

    case "$IP" in
        10.189.*)
            return
            ;;
        10.171.*)
            return
            ;;
    esac

    # set up routes here

    GW=$(ip route get $VPN_SERVER 2>/dev/null | grep via | awk '{print $3}')
    PPP=$(ip addr show | grep ppp[0-9]: | cut "-d " -f2 | cut -d: -f1)
    echo "[MSG] Detected gateway: $GW, PPP device: $PPP ."

    ip route add  10.0.0.0/8 via $GW
    ip route add   0.0.0.0/1 dev $PPP
    ip route add 128.0.0.0/1 dev $PPP

    # todo nexthop
}

connect() {
    disconnect
    # todo
    set_up_routes
}


case "$1" in

    -d)
        disconnect
        ;;

    disconnect)
        disconnect
        ;;

    *)
        connect
        ;;

esac
