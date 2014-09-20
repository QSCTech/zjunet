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
DIR="$HOME/.zjunet"
mkdir -p $DIR

# dispatch
case "$1" in

    add)
        read -p "USERNAME: " USERNAME
        read -p "PASSWORD: " PASSWORD
        echo $PASSWORD > "$DIR/${USERNAME}"
        ;;

    edit)
        read -p "USERNAME: " USERNAME
        read -p "PASSWORD: " PASSWORD
        echo $PASSWORD > "$DIR/${USERNAME}"
        ;;

    delete)
        read -p "USERNAME: " USERNAME
        rm -i "$DIR/${USERNAME}"
        ;;

    list)
        ls -1A $DIR
        ;;

    # Get a user
    # @private
    get)
        COUNT=$(ls -1A $DIR | wc -l)
        if [ "${COUNT}" -eq "0" ]; then
            echo "No user found. Use 'zjunet user add' to add a user."
            exit 1
        else
            if [ "${COUNT}" -gt "1" ]; then
                USERS=$(ls -1A $DIR | xargs | tr "\n" " ")
                read -p "Choose User [ ${USERS}]: " USERNAME
            else
                USERNAME=$(ls -1 $DIR | head -n1)
            fi
            echo $USERNAME
        fi
        ;;

    # Get all users
    # @private
    getall)
        ls -1A $DIR | xargs | tr "\n" " "
        ;;

    # @private
    getpwd)
        USERNAME=$2
        cat "$DIR/${USERNAME}"
        ;;
esac
