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

    ip route replace 10.5.1.0/24 via $gateway # for LNS
    ip route replace 10.10.0.0/24 via $gateway # for DNS

    case "$ip" in
        10.189.*)
            ;;
        10.171.*)
            ;;
        *)
            # 内网静态路由
            # See also: #18 (thanks Hexcles Ma)
	    ip route replace 10.0.0.0/8 via $gateway

            # Some classroom computers (especially East 6,7)
	    ip route replace 58.196.192.0/19 via $gateway
	    ip route replace 58.196.224.0/20 via $gateway
	    ip route replace 58.200.100.0/24 via $gateway

            # The public CERNET IP of most ZJU servers, which can be reached directly in the Intranet.
            # Most of them do have a 10.* IP, but sometimes school DNS just returns the public ones.
	    ip route replace 210.32.0.0/20 via $gateway
	    ip route replace 210.32.128.0/19 via $gateway
	    ip route replace 210.32.160.0/21 via $gateway
	    ip route replace 210.32.168.0/22 via $gateway
	    ip route replace 210.32.172.0/23 via $gateway
	    ip route replace 210.32.176.0/20 via $gateway

            # 玉泉和我们 vpn 后的 ip
	    ip route replace 222.205.0.0/17 via $gateway
            ;;
    esac

    # NEXTHOP
    devs=$(ip addr show | grep 'inet.*ppp' | grep ' 10.5.' | awk '{print $7}')
    cmd="ip route replace default"
    for dev in $devs; do
        cmd="${cmd} nexthop dev ${dev}"
    done
    $cmd
    ip route
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

    route)
        set_up_routes
        ;;

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
