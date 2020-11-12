#!/bin/bash

VERSION=$(cat ../VERSION)

fail() {
	echo -e "\033[31mERROR: Failed to build $1\033[0m" 1>&2
}

if [[ $# -gt 0 ]]; then
	for arg in $*; do
		case $arg in
			rpm)
				USE_RPM=1
				;;
			debian)
				USE_DEB=1
				;;
			openwrt)
				USE_OPK=1
				;;
			*)
				echo "Invalid package $arg"
				exit 1
		esac
	done
else
	USE_RPM=1
	USE_DEB=1
	USE_OPK=1
fi

if [[ ! -z $USE_RPM ]]; then
	pushd rpm > /dev/null
	./build.sh $VERSION || fail 'RPM package'
	popd > /dev/null
fi

if [[ ! -z $USE_DEB ]]; then
	pushd debian > /dev/null
	./build.sh $VERSION || fail 'Debian package'
	popd > /dev/null
fi

if [[ ! -z $USE_OPK ]]; then
	pushd openwrt > /dev/null
	./build.sh $VERSION || fail 'OpenWrt package'
	popd > /dev/null
fi

echo -ne "\033[0;32m"
find . -regextype posix-egrep -regex ".*\.(opk|deb|rpm)$"
echo -ne "\033[0m"
