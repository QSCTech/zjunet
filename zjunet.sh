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
        # TODO
        zju_connect_wlan
        ;;
    vpn)
        # if 10.189.xxx => is zjuwlan
        # else set up route
        ;;
    dns)
        "$BASEDIR/dns.sh"
        ;;
esac
