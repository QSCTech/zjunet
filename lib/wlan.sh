#!/bin/sh

# wlan.sh -- login/logout for ZJUWLAN
#
# Requirements: curl
#
# Copyright (C) 2014 Zhang Hai <Dreaming.in.Code.ZH@Gmail.com>
# Copyright (C) 2014 Zeno Zeng <zenoofzeng@gmail.com>
# Copyright (C) 2017 Wu Fan <wfwf1997@gmail.com>
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

DISABLE_CHECK=${BASEDIR}/.disable-wlan

USER="${BASEDIR}/user.sh"

USERNAME=$($USER get)
PASSWORD=$($USER getpwd $USERNAME)

if [ -f "${DISABLE_CHECK}" ]; then
    echo WLAN function has been disabled.;
    exit 1;
fi

logout() {
    USERNAME=$1
    PASSWORD=$2

    echo "Logout: ${USERNAME}"
    RESPONSE=$(curl "https://net.zju.edu.cn/include/auth_action.php" -H "Content-Type: application/x-www-form-urlencoded" -d "action=logout&username=${USERNAME}&password=${PASSWORD}&ajax=1" -s)

    if [ $? -eq 60 ]; then
        CHOOSE=''
        read -p "There's an issue with ZJUNET's CA certificates, do you want to do it anyway? [yes/NO] " CHOOSE
        if [ $CHOOSE = "YES" ] || [ $CHOOSE = "yes" ]; then
            RESPONSE=$(curl "https://net.zju.edu.cn/include/auth_action.php" -H "Content-Type: application/x-www-form-urlencoded" -d "action=logout&username=${USERNAME}&password=${PASSWORD}&ajax=1" -s -k)
        fi
    fi
        
    case "${RESPONSE}" in
        *ok*)
            echo "Logout: success."
            ;;
        *已断开*)
            echo "Logout: success."
            ;;
        *)
            echo "Logout: unsuccess."
            echo "${RESPONSE}"
            exit 1;
            ;;
    esac
}

login() {
    USERNAME=$1
    PASSWORD=$2

    STATUS=$(curl http://g.cn/generate_204 -I -s | grep HTTP | awk {'print $2'})
    if [ STATUS -eq 204 ]; then
        echo "You have already logged in."
        exit 0
    fi

    echo "Login: ${USERNAME}"
    RESPONSE=$(curl "https://net.zju.edu.cn/include/auth_action.php" -H "Content-Type: application/x-www-form-urlencoded" -d "action=login&username=${USERNAME}&password=${PASSWORD}&ac_id=3&user_ip=&nas_ip=&user_mac=&save_me=1&ajax=1" -s)

    if [ $? -eq 60 ]; then
        CHOOSE=''
        read -p "There's an issue with ZJUNET's CA certificates, do you want to do it anyway? [yes/NO] " CHOOSE
        if [ $CHOOSE = "YES" ] || [ $CHOOSE = "yes" ]; then
            RESPONSE=$(curl "https://net.zju.edu.cn/include/auth_action.php" -H "Content-Type: application/x-www-form-urlencoded" -d "action=login&username=${USERNAME}&password=${PASSWORD}&ac_id=3&user_ip=&nas_ip=&user_mac=&save_me=1&ajax=1" -s -k)
        fi
    fi

    case "${RESPONSE}" in
        *help.html*)
            echo "Login: success."
            ;;
        *login_ok*)
            echo "Login: success."
            ;;
        *E2532*)
            echo "Login: failed. Please retry after 10s." >&2
            echo "Login: ${RESPONSE}" >&2
            exit 1
            ;;
        *)
            echo "Login: failed." >&2
            if [ -z "${RESPONSE}" ]; then
                echo "Login: (Empty response)" >&2
            else
                echo "Login: ${RESPONSE}" >&2
            fi
            exit 1
            ;;
    esac
}


case "$1" in
    d|-d|disconnect)
        logout $USERNAME $PASSWORD
        ;;

    ""|c|-c|connect)
        login $USERNAME $PASSWORD
        ;;

    disable)
        "${BASEDIR}/sudo.sh" touch "${DISABLE_CHECK}"
        exit 0
        ;;

    *)
        echo Invalid subcommand \"$1\" for \`zjunet wlan\`. Run \`zjunet usage\` for help.
        ;;
esac

"${BASEDIR}/sudo.sh" "${BASEDIR}/route.sh"

