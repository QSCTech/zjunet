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
MISCELLDIR="/usr/share/zjunet"

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
        "${BASEDIR}/dns.sh" $2
        ;;
    version|--version)
        version_full=`cat "${MISCELLDIR}/VERSION"`
        version=$(echo $version_full | sed 's/-.*//')
        echo "zjunet version: $version (${version_full})"
        ;;
    *)
        cat <<EOF
zjunet: cli tool (VPN/WLAN/DNS) for network connection in ZJU

Usage: zjunet [ACTION]

Actions:
    user
        add            Add a user
        list           List all enabled users
        edit           Edit a (enabled) user
      * Note: to delete/disable a user, edit /etc/xl2tpd/xl2tpd.conf
    all
        connect(-c)    Connect VPN & ZJUWLAN, and combine them using nexthop
        disconnect(-d) Disconnect VPN & ZJUWLAN
    vpn
        connect(-c)    Connect VPN and set up ip route
        disconnect(-d) Disconnect VPN and reset ip route
    wlan
        connect(-c)    Login ZJUWLAN using curl
        disconnect(-d) Logout ZJUWLAN using curl
    route              Set up static route
    dns [server]       Test and set up DNS Server (default: 10.10.0.21)
    version            Display program version
EOF
        ;;
esac
