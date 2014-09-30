#!/bin/sh

# route.sh -- set up ip route
#
# Copyright (C) 2014 Zeno Zeng <zenoofzeng@gmail.com>
# Copyright (C) 2014 Hexcles Ma <bob1211@gmail.com>
# Copyright (C) 2014 Senorsen Zhang <sen@senorsen.com>
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

ip_route_del() {
    count=$(ip route show $1 | wc -l)
    if [ "${count}" -gt "0" ]; then
        ip route del $1
    fi
}

echo "[INFO] Setting up ip route."

gateway=$(ip route get 10.10.0.21 | grep via | awk '{print $3}')

devs_count=$(ip addr show | grep 'inet.*ppp' | grep ' 10.5.' | awk '{print $7}' | wc -l)
if [ "${devs_count}" -eq "0" ]; then
    dev=$(ip route get 10.10.0.21 | head -n1 | awk '{print $5}')

    ip_route_del 10.0.0.0/8
    ip_route_del 10.50.200.245
    ip_route_del 58.196.192.0/19
    ip_route_del 58.196.224.0/20
    ip_route_del 58.200.100.0/24
    ip_route_del 210.32.0.0/20
    ip_route_del 210.32.128.0/19
    ip_route_del 210.32.160.0/21
    ip_route_del 210.32.168.0/22
    ip_route_del 210.32.172.0/23
    ip_route_del 210.32.176.0/20
    ip_route_del 222.205.0.0/17
    ip_route_del 10.5.1.0/24
    ip_route_del 10.10.0.0/24

    ip route replace default via $gateway dev $dev

    ip route
    return
fi

flush() {
    # see also: https://github.com/QSCTech/zjunet/issues/39
    ip route flush 10.5.1.5
    ip route flush 10.5.1.7
    ip route flush 10.5.1.9
}

flush

ip route replace 10.5.1.0/24 via $gateway # for LNS
ip route replace 10.10.0.0/24 via $gateway # for DNS

case "$gateway" in
    10.189.*)
        ip route replace 10.50.200.245 via $gateway
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

case "$gateway" in
    10.189.*)
        # WLAN
        zjuwlan_test_ip=10.202.68.44
        ip route replace $zjuwlan_test_ip via ${gateway}
        zjuwlan_status=`curl -s $zjuwlan_test_ip | grep net.zju.edu.cn | wc -l`
        if [ $zjuwlan_status -eq 0 ]
        then
            cmd="${cmd} nexthop via ${gateway}"
        fi
        ip route del $zjuwlan_test_ip || true
        ;;
esac

$cmd
ip route

ip route
