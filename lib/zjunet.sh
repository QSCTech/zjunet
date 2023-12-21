#!/bin/sh

# zjunet.sh -- router for zjunet
#
# Copyright (C) 2014 Zeno Zeng <zenoofzeng@gmail.com>
# Copyright (C) 2023 Azuk 443 <azukmm@gmail.com>
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
MISCELLDIR="$BASEDIR/../../share/zjunet"

case "$1" in
    r|route)
        "${BASEDIR}/sudo.sh" "${BASEDIR}/route.sh"
        ;;
    u|user)
        "${BASEDIR}/user.sh" $2
        ;;
    a|all)
        "${BASEDIR}/wlan.sh" $2
        "${BASEDIR}/vpn.sh" $2
        ;;
    w|wlan)
        "${BASEDIR}/wlan.sh" $2
        ;;
    v|vpn)
        "${BASEDIR}/vpn.sh" $2
        ;;
    d|dns)
        "${BASEDIR}/dns.sh" $2
        ;;
    -v|version|--version)
        version_full=`cat "${MISCELLDIR}/VERSION"`
        version=$(echo $version_full | sed 's/-.*//')
        echo "zjunet version: $version (${version_full})"
        ;;
    *)
        cat <<EOF
zjunet: CLI tool (VPN/WLAN/DNS) for network connection in ZJU

Usage: zjunet [ACTION]

Actions:
    user, u
        add              Add a user
        list             List all enabled users
        edit             Edit a (enabled) user
      * Note: to delete/disable a user, edit /etc/xl2tpd/xl2tpd.conf
    all, a
        connect, -c      Connect VPN & ZJUWLAN, and combine them using nexthop
        disconnect, -d   Disconnect VPN & ZJUWLAN
    vpn, v
        connect, -c      Connect VPN and set up ip route
        disconnect, -d   Disconnect VPN and reset ip route
    route, r             Set up static route
    dns [ip], d [ip]     Test and set up DNS Server (default: 10.10.0.21)
    version, -v          Display program version

Example:
    zjunet user add      Add a new user
    zjunet vpn -c        Connect VPN
    zjunet vpn -d        Disconnect VPN
EOF
        ;;
esac
