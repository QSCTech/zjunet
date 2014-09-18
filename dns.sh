#!/bin/sh

##################################
#
# DNS Helper
#
##################################

zju_test_and_set_up_dns () {
    until [ -z "$1" ]
    do
        dig baidu.com @$1 +time=1 > /dev/null && echo "$1 ... ok" && echo "nameserver $1" > /etc/resolv.conf && break
        echo "$1 ... fail"
        shift
    done
}

# 浙大的DNS不是很稳定，这里列了备用方案
# 官方 > 10.12.10.12 > Senorsen DNS > RQ Lab > ALI YUN
zju_test_and_set_up_dns \
    10.10.0.21 10.10.0.22 10.10.0.23 \
    10.12.10.12 \
    10.76.8.111 \
    10.202.68.222 \
    223.5.5.5 223.6.6.6 
