#!/bin/sh

# vpn.sh -- xl2tpd connect / disconnect
#
# Requirements: xl2tpd
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

set_up_routes() {

    ip=$(ip route show 0/0 | cut -d " " -f 3)

    gateway=$(ip route get 10.10.0.21 | grep via | awk '{print $3}')

    case "$ip" in
        10.189.*)
            ;;
        10.171.*)
            ;;
        *)
            # 内网静态路由
            ip route delete 10.0.0.0/8 > /dev/null
            ip route add  10.0.0.0/8 via $gateway
            ;;
    esac

    # NEXTHOP
    ip route delete default > /dev/null
    devs=$(ip addr show | grep 'inet.*ppp' | grep ' 10.5.' | awk '{print $7}')
    cmd="ip route add default"
    for dev in $devs; do
        cmd="${cmd} nexthop dev ${dev}"
    done
    $cmd
}

disconnect() {
    users=$("${BASEDIR}/user.sh" getall)
    for username in $users; do
        echo "Logout: ${username}"
        "${BASEDIR}/xl2tpd.sh" disconnect $username
    done
    set_up_routes
}

connect() {
    disconnect
    users=$("${BASEDIR}/user.sh" getall)
    for username in $users; do
        password=$("${BASEDIR}/user.sh" getpwd $username)
        echo "Login using ${username}"
        "${BASEDIR}/xl2tpd.sh" connect $username $password
    done
    set_up_routes
}



#####################################
#
# Dispatch
#
#####################################

BASEDIR=$(dirname $0)

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
