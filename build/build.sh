#!/bin/bash

VERSION=0.2.0-0

cd debian
./build.sh $VERSION > /dev/null

cd ../openwrt
./build.sh $VERSION > /dev/null

cd ..
find . -regextype posix-egrep -regex ".*\.(opk|deb)$"
