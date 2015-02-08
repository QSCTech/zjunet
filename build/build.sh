#!/bin/bash

VERSION=$(cat ../lib/version)

cd rpm
./build.sh $VERSION
cd ..

cd debian
./build.sh $VERSION
cd ..

cd openwrt
./build.sh $VERSION

cd ..
find . -regextype posix-egrep -regex ".*\.(opk|deb|rpm)$"
