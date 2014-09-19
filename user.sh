#!/bin/sh

# init
CFG="$HOME/.zjunetrc"
touch $CFG

# dispatch
case "$1" in
    add)
        ;;
    edit)
        ;;
    delete)
        ;;
    list)
        cat $CFG
        ;;
esac
