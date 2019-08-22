#!/bin/sh
set -e

rm -rf *.opk

VERSION=$1

# share
mkdir -p ./debian/usr/share/zjunet
cp ../../miscellaneous/* ./debian/usr/share/zjunet
cp ../../VERSION ./debian/usr/share/zjunet

# lib
mkdir -p ./debian/usr/lib/zjunet
cp ../../lib/*.sh ./debian/usr/lib/zjunet

# bin
install -m 755 -d ./debian/usr/bin
install -m 755 ../../bin/zjunet ./debian/usr/bin/zjunet

# contorl file
mkdir -p debian/DEBIAN
cat > debian/DEBIAN/control <<EOF
Package: zjunet
Version: $VERSION
Section: net
Priority: optional
Architecture: all
Depends: xl2tpd (>= 1.3.1), curl, bind-dig
Maintainer: Tespent <me@tespent.cn>
Description: Command Line Scripts for ZJU
 This script provides a VPN / WLAN / NEXTHOP for ZJUer.
EOF

# dpkg-deb
find ./debian -type d | xargs chmod 755
fakeroot dpkg-deb -Zgzip --build debian # for opkg
mv debian.deb zjunet_${VERSION}_all.opk

# remove debian/
rm -rf ./debian
rm -rf control
