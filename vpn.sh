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

BASEDIR=$(dirname $0)

disconnect() {
    users=$("${BASEDIR}/user.sh" getall)
    for username in $users; do
        echo "[INFO] Logout: ${username}"
        "${BASEDIR}/xl2tpd.sh" disconnect $username
    done
    "${BASEDIR}/route.sh"
}

connect() {
    disconnect
    users=$("${BASEDIR}/user.sh" getall)

    for username in $users; do
        password=$("${BASEDIR}/user.sh" getpwd $username)
        echo "[INFO] Login using ${username}"
        "${BASEDIR}/xl2tpd.sh" connect $username $password
    done

    "${BASEDIR}/route.sh"
}

#####################################
#
# Dispatch
#
#####################################

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
