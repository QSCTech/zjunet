#!/bin/sh

##################################
#
# Router
#
##################################

BASEDIR=$(dirname $0)

case "$1" in
    user)
        "$BASEDIR/user.sh" $2
        ;;
    ip)
        ip route show 0/0 | cut -d " " -f 3
        ;;
    wlan)
        "$BASEDIR/wlan.sh"
        ;;
    vpn)
        "$BASEDIR/vpn.sh"
        ;;
    dns)
        "$BASEDIR/dns.sh"
        ;;
esac
