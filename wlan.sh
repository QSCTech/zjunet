#!/bin/sh

# wlan.sh -- login/logout for ZJUWLAN
#
# Requirements: curl, iconv
#
# Copyright (C) 2014 Zhang Hai <Dreaming.in.Code.ZH@Gmail.com>
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

logout() {
    USERNAME=$1
    PASSWORD=$2

    echo "Logout: ${USERNAME}"
    RESPONSE=$(curl "https://net.zju.edu.cn/cgi-bin/srun_portal" -H "Content-Type: application/x-www-form-urlencoded" -d "action=logout" -s)

    case "${RESPONSE}" in
        *ok*)
            echo "Logout: success."
            ;;
        *成功*)
            echo "Logout: success."
            ;;
        *)
            echo "Logout: ${RESPONSE}"
            exit 1;
            ;;
    esac
}

login() {
    USERNAME=$1
    PASSWORD=$2

    logout $USERNAME $PASSWORD

    echo "Login: ${USERNAME}"
    RESPONSE=$(curl "https://net.zju.edu.cn/cgi-bin/srun_portal" -H "Content-Type: application/x-www-form-urlencoded" -d "action=login&username=${USERNAME}&password=${PASSWORD}&ac_id=3&type=1&is_ldap=1&local_auth=1" -s | iconv -c -f gbk -t utf8)

    case "${RESPONSE}" in
        *help.html*)
            echo "Login: success."
            ;;
        *login_ok*)
            echo "Login: success."
            ;;
        *)
            echo "Login: ${RESPONSE}" >&2
            exit 1
            ;;
    esac
}

BASEDIR=$(dirname $0)
USER="${BASEDIR}/user.sh"

USERNAME=$($USER get)
PASSWORD=$($USER getpwd $USERNAME)

case "$1" in
    login)
        login $USERNAME $PASSWORD
        ;;
    logout)
        logout $USERNAME $PASSWORD
        ;;
    *)
        ${BASEDIR}/zjunet.sh usage
        ;;
esac
