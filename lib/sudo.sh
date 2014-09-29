#!/bin/sh

if [ "$(id -u)" -eq "0" ]; then
    "$@"
else
    sudo -u root "$@"
fi
