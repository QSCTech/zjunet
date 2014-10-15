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

flush() {
    # see also: https://github.com/QSCTech/zjunet/issues/39
    "${BASEDIR}/sudo.sh" ip route flush 10.5.1.5
    "${BASEDIR}/sudo.sh" ip route flush 10.5.1.7
    "${BASEDIR}/sudo.sh" ip route flush 10.5.1.9
    "${BASEDIR}/sudo.sh" ip route flush 10.5.6.2
}

disconnect() {
    users=$("${BASEDIR}/user.sh" getall)
    for username in $users; do
        echo "[INFO] Logout: ${username}"
        "${BASEDIR}/sudo.sh" "${BASEDIR}/xl2tpd.sh" disconnect $username
    done
    "${BASEDIR}/sudo.sh" "${BASEDIR}/route.sh"
}

connect() {
    disconnect
    sleep 3

    users=$("${BASEDIR}/user.sh" getall)

    "${BASEDIR}/sudo.sh" "${BASEDIR}/xl2tpd.sh" restart

    for username in $users; do
        password=$("${BASEDIR}/user.sh" getpwd $username)
        echo "[INFO] Login using ${username}"
        "${BASEDIR}/sudo.sh" "${BASEDIR}/xl2tpd.sh" waituser $username
        flush
    done

    "${BASEDIR}/sudo.sh" "${BASEDIR}/route.sh"
}

#####################################
#
# Dispatch
#
#####################################

# start xl2tpd if not
"${BASEDIR}/sudo.sh" "${BASEDIR}/xl2tpd.sh" trystart

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
