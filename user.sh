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
        echo "USERNAME: "
        read USERNAME
        echo "PASSWORD: "
        read PASSWORD
        echo $PASSWORD > "$DIR/$USERNAME"
        ;;
    edit)
        echo "USERNAME: "
        read USERNAME
        echo "PASSWORD: "
        read PASSWORD
        echo $PASSWORD > "$DIR/$USERNAME"
        ;;
    delete)
        echo "USERNAME: "
        read USERNAME
        rm -i "$DIR/$USERNAME"
        ;;
    list)
        ls $DIR
        ;;
esac
