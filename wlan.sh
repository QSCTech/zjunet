# wlan.sh
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
    RESPONSE=$(curl "https://net.zju.edu.cn/rad_online.php" -H "Content-Type: application/x-www-form-urlencoded" -d "action=auto_dm&username=${USERNAME}&password=${PASSWORD}" -s)
    if [[ "${RESPONSE}" != "ok" ]]; then
        echo "${RESPONSE}" >&2
        exit 1
    fi
}

login() {
    USERNAME=$1
    PASSWORD=$2

    logout $USERNAME $PASSWORD

    echo "Login: ${USERNAME}"
    RESPONSE=$(curl "https://net.zju.edu.cn/cgi-bin/srun_portal" -H "Content-Type: application/x-www-form-urlencoded" -d "action=login&username=${USERNAME}&password=${PASSWORD}&ac_id=3&type=1&is_ldap=1&local_auth=1" -s)
    if [[ "${RESPONSE}" = *"help.html"* || "${response}" = *"login_ok"* ]]; then
        echo "Login successful"
    else
        echo "${RESPONSE}" >&2
        exit 1
    fi    
}

case "$1" in
    login)
        ;;
    logout)
        ;;
esac
