#!/bin/sh

VERSION=0.1-2

# lib
mkdir -p ./debian/usr/lib/zjunet
cp ../../lib/* ./debian/usr/lib/zjunet

cat > control <<EOF
Package: zjunet
Version: $VERSION
Section: base
Priority: optional
Architecture: all
Depends: xl2tpd (>= 1.3.1), curl
Maintainer: Zeno Zeng <zenoofzeng@gmail.com>
Description: Command Line Scripts for ZJU
 This script provides a VPN / WLAN / NEXTHOP for ZJUer.
EOF

# bin
mkdir -p ./debian/usr/bin
echo '/usr/lib/zjunet/zjunet.sh "$@"' >> ./debian/usr/bin/zjunet
chmod +x ./debian/usr/bin/zjunet

# contorl file
mkdir -p debian/DEBIAN
find ./debian -type d | xargs chmod 755
cp control debian/DEBIAN

# dpkg-deb
dpkg-deb --build debian
mv debian.deb zjunet_${VERSION}_all.ipk

# remove debian/
rm -rf ./debian
rm -rf control
