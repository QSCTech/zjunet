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
    user)
        "${BASEDIR}/user.sh" $2
        ;;
    wlan)
        "${BASEDIR}/wlan.sh" $2
        ;;
    vpn)
        "${BASEDIR}/sudo.sh" "${BASEDIR}/vpn.sh" $2
        ;;
    dns)
        "${BASEDIR}/dns.sh"
        ;;
    *)
        cat <<EOF
zjunet: CLI Tool (VPN/WLAN/DNS) for Zjuer

Usage: zjunet [ACTION]

Actions:
    user
        add            Add a user
        edit           Edit a (enabled) user
        delete         Delete a (enabled) user
        list           List all enabled users
        enable         Enable a user
        disable        Disable a user
    vpn
        connect(-c)    Connect VPN and set up ip route
        disconnect(-d) Disconnect VPN and reset ip route
        route          Set up ip route
    wlan
        login          Login ZJUWLAN via curl
        logout         Logout ZJUWLAN via curl
    dns                Test and set up DNS Server
EOF
        ;;
esac
