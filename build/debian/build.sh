#!/bin/sh

rm -rf *.deb

VERSION=$1

# share
mkdir -p ./debian/usr/share/zjunet
cp ../../miscellaneous/* ./debian/usr/share/zjunet

# lib
mkdir -p ./debian/usr/lib/zjunet
cp ../../lib/* ./debian/usr/lib/zjunet

# bin
mkdir -p ./debian/usr/bin
echo '/usr/lib/zjunet/zjunet.sh "$@"' >> ./debian/usr/bin/zjunet
chmod +x ./debian/usr/bin/zjunet

# postinst
mkdir -p debian/DEBIAN
cat  > debian/DEBIAN/postinst <<EOF
#!/bin/sh

cp /usr/share/zjunet/qsc.list /etc/apt/sources.list.d/qsc.list
chmod 644 /etc/apt/sources.list.d/qsc.list
apt-key add /usr/share/zjunet/qsc.public.key 2>&1 >/dev/null || true

cat <<BANNER
----------------------------------------------------------------------

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License Version 3 for more details.

You can ask questions, file a bug or make PRs here:
* https://github.com/QSCTech/zjunet

----------------------------------------------------------------------
BANNER

EOF
chmod 755 debian/DEBIAN/postinst

# contorl file
mkdir -p debian/DEBIAN
cat > debian/DEBIAN/control <<EOF
Package: zjunet
Version: $VERSION
Section: net
Priority: optional
Architecture: all
Depends: xl2tpd (>= 1.3.1), curl
Maintainer: Zeno Zeng <zenoofzeng@gmail.com>
Description: Command Line Scripts for ZJU
 This script provides a VPN / WLAN / NEXTHOP for ZJUer.
EOF

# dpkg-deb
find ./debian -type d | xargs chmod 755
fakeroot dpkg-deb --build debian
mv debian.deb zjunet_${VERSION}_all.deb

# remove debian/
rm -rf ./debian
rm -f control
