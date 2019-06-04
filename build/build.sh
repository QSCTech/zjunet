#!/bin/bash

VERSION=$(cat ../VERSION)

fail() {
	echo -e "\033[31mERROR: Failed to build $1\033[0m" 1>&2
}

pushd rpm > /dev/null
./build.sh $VERSION || fail 'RPM package'
popd > /dev/null

pushd debian > /dev/null
./build.sh $VERSION || fail 'Debian package'
popd > /dev/null

pushd openwrt > /dev/null
./build.sh $VERSION || fail 'OpenWrt package'
popd > /dev/null

echo -ne "\033[0;32m"
find . -regextype posix-egrep -regex ".*\.(opk|deb|rpm)$"
echo -ne "\033[0m"
