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
users_enabled="$HOME/.zjunet/users-enabled"
users_disabled="$HOME/.zjunet/users-disabled"
mkdir -p $users_enabled
mkdir -p $users_disabled

getall() {
    ls -1A $users_enabled | xargs | tr "\n" " "
}

# dispatch
case "$1" in

    enable)
        users=$(ls -1A $users_disabled | xargs | tr "\n" " ")
        read -p "Enable User [ ${users}]: " username
        mv "${users_disabled}/${username}" "${users_enabled}/${username}"
        ;;

    disable)
        users=$(getall)
        read -p "Disable User [ ${users}]: " username
        mv "${users_enabled}/${username}" "${users_disabled}/${username}"
        ;;

    add)
        read -p "username: " username
        read -p "password: " password
        echo $password > "$users_enabled/${username}"
        ;;

    edit)
        users=$(getall)
        read -p "username [ ${users}]: " username
        read -p "password: " password
        echo $password > "$users_enabled/${username}"
        ;;

    delete)
        users=$(getall)
        read -p "Delete User [ ${users}]: " username
        rm -i "$users_enabled/${username}"
        ;;

    list)
        ls -1A $users_enabled
        ;;

    # Get a user
    # @private
    get)
        count=$(ls -1A $users_enabled | wc -l)
        if [ "${count}" -eq "0" ]; then
            echo "No user found. Use 'zjunet user add' to add a user."
            exit 1
        else
            if [ "${count}" -gt "1" ]; then
                users=$(getall)
                read -p "Choose User [ ${users}]: " username
            else
                username=$(ls -1 $users_enabled | head -n1)
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
        cat "${users_enabled}/${username}"
        ;;
    *)
        BASEDIR=$(dirname $0)
        ${BASEDIR}/zjunet.sh usage
        ;;
esac
