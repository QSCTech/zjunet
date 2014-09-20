#!/bin/sh

# dns.sh -- DNS helper for zjuer
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

zju_test_and_set_up_dns () {
    until [ -z "$1" ]
    do
        dig baidu.com @$1 +time=1 > /dev/null && echo "$1 ... ok" && echo "nameserver $1" > /etc/resolv.conf && break
        echo "$1 ... fail"
        shift
    done
}

# 浙大的DNS不是很稳定，这里列了备用方案
# 官方 > 10.12.10.12 > Senorsen (QSC Server) DNS > ALI YUN
zju_test_and_set_up_dns \
    10.10.0.21 10.10.0.22 10.10.0.23 \
    10.12.10.12 \
    10.202.68.43 \
    223.5.5.5 223.6.6.6 
