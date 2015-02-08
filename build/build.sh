#!/bin/bash

VERSION=$(cat ../lib/version)

cd rpm
./build.sh $VERSION

cd debian
./build.sh $VERSION > /dev/null

cd ../openwrt
./build.sh $VERSION > /dev/null

cd ..
find . -regextype posix-egrep -regex ".*\.(opk|deb|rpm)$"
