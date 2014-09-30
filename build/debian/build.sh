#!/bin/sh

# bin
mkdir -p ./debian/usr/bin
cp -r ../../lib ./debian/usr
echo '/usr/lib/zjunet/zjunet.sh "$@"' >> ./debian/usr/bin/zjunet
chmod +x ./debian/usr/bin/zjunet

# contorl file
mkdir -p debian/DEBIAN
find ./debian -type d | xargs chmod 755
cp control debian/DEBIAN

# dpkg-deb
dpkg-deb --build debian
mv debian.deb zjunet_0.1-1_all.deb

# remove debian/
rm -rf ./debian
