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
    ip)
        ip route show 0/0 | cut -d " " -f 3
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
esac
