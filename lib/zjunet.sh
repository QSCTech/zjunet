#!/bin/sh

# zjunet.sh -- router for zjunet
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

BASEDIR=$(dirname $0)

case "$1" in
    route)
        "${BASEDIR}/sudo.sh" "${BASEDIR}/route.sh"
        ;;
    user)
        "${BASEDIR}/user.sh" $2
        ;;
    all)
        "${BASEDIR}/wlan.sh" $2
        "${BASEDIR}/vpn.sh" $2
        ;;
    wlan)
        "${BASEDIR}/wlan.sh" $2
        ;;
    vpn)
        "${BASEDIR}/vpn.sh" $2
        ;;
    dns)
        "${BASEDIR}/dns.sh"
        ;;
    --version)
        version=$(cat "${BASEDIR}/version" | sed 's/-.*//')
        echo "zjunet version: zjunet-$version"
        ;;
    *)
        cat <<EOF
zjunet: CLI Tool (VPN/WLAN/DNS) for Zjuer

Usage: zjunet [ACTION]

Actions:
    user
        add            Add a user
        list           List all enabled users
        edit           Edit a (enabled) user
        Note: to delete/disable a user, edit /etc/xl2tpd/xl2tpd.conf yourself
    all
        connect(-c)    Connect VPN & ZJUWLAN, and combine them using nexthop
        disconnect(-d) Disconnect VPN & ZJUWLAN
    vpn
        connect(-c)    Connect VPN and set up ip route
        disconnect(-d) Disconnect VPN and reset ip route
    wlan
        connect(-c)    Login ZJUWLAN via curl
        disconnect(-d) Logout ZJUWLAN via curl
    route              Set up ip route
    dns                Test and set up DNS Server
    --version          Show Version
EOF
        ;;
esac
