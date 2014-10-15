#!/bin/sh

# user.sh -- User Manager
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

# init

L2TPD_CFG_FILE=/etc/xl2tpd/xl2tpd.conf

BASEDIR=$(dirname $0)

getall() {
    cat $L2TPD_CFG_FILE | grep lac | sed 's/\[lac zju-l2tp-//' | sed 's/\]//'
}

edituser() {
    username=$1
    password=$2
    echo "[INFO] Disconnect VPN"
    "${BASEDIR}/vpn.sh" disconnect
    echo "[INFO] Write to xl2tpd.conf"
    "${BASEDIR}/sudo.sh" "${BASEDIR}/xl2tpd.sh" adduser ${username} $password
    echo "[INFO] Restart xl2tpd"
    "${BASEDIR}/sudo.sh" "${BASEDIR}/xl2tpd.sh" restart
}

# dispatch
case "$1" in

    add)
        read -p "username: " username
        read -p "password: " password
        edituser $username $password
        ;;

    edit)
        users=$(getall)
        read -p "username [ ${users}]: " username
        read -p "password: " password
        edituser $username $password
        ;;

    list)
        getall
        ;;

    # Get a user
    # @private
    get)
        count=$(getall | wc -l)
        if [ "${count}" -eq "0" ]; then
            echo "No user found. Use 'zjunet user add' to add a user."
            exit 1
        else
            if [ "${count}" -gt "1" ]; then
                users=$(getall)
                read -p "Choose User [ ${users}]: " username
            else
                username=$(getall | head -n1)
            fi
            echo $username
        fi
        ;;

    # Get all users
    # @private
    getall)
        getall
        ;;

    # @private
    getpwd)
        username=$2
        "${BASEDIR}/sudo.sh" cat /etc/ppp/peers/zju-l2tp-${username} | grep password | sed 's/password //'
        ;;

    *)
        ${BASEDIR}/zjunet.sh usage
        ;;
esac
