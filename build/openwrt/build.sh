#!/bin/sh

rm -rf *.opk

VERSION=$1

# lib
mkdir -p ./debian/usr/lib/zjunet
cp ../../lib/* ./debian/usr/lib/zjunet

# bin
mkdir -p ./debian/usr/bin
echo '/usr/lib/zjunet/zjunet.sh "$@"' >> ./debian/usr/bin/zjunet
chmod +x ./debian/usr/bin/zjunet

# contorl file
mkdir -p debian/DEBIAN
cat > debian/DEBIAN/control <<EOF
Package: zjunet
Version: $VERSION
Section: net
Priority: optional
Architecture: all
Depends: xl2tpd, curl
Maintainer: Zeno Zeng <zenoofzeng@gmail.com>
Description: Command Line Scripts for ZJU
 This script provides a VPN / WLAN / NEXTHOP for ZJUer.
EOF

# dpkg-deb
find ./debian -type d | xargs chmod 755
dpkg-deb -Zgzip --build debian # for opkg
mv debian.deb zjunet_${VERSION}_all.opk

# remove debian/
rm -rf ./debian
rm -rf control
