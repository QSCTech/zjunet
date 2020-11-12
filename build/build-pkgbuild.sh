#!/bin/bash

PKGNAME=zjunet
PKGVER=$(cat $(dirname $0)/../VERSION)
PKGVER_NOREL=${PKGVER%%-*}
PKGREL=${PKGVER:$((${#PKGVER_NOREL}+1))}
if [[ -z $PKGREL ]]; then
	PKGREL=1
fi

set -xe

wget https://github.com/QSCTech/$PKGNAME/archive/v$PKGVER.tar.gz -O $PKGNAME-$PKGVER.tar.gz

FILE_MD5=$(md5sum $PKGNAME-$PKGVER.tar.gz | cut -f1 -d' ')
FILE_SHA1=$(sha1sum $PKGNAME-$PKGVER.tar.gz | cut -f1 -d' ')
FILE_SHA256=$(sha256sum $PKGNAME-$PKGVER.tar.gz | cut -f1 -d' ')

cat > PKGBUILD <<EOF
# Maintainer: Wu Yufei <me@tespent.cn>

pkgname=$PKGNAME
pkgver=$PKGVER_NOREL
pkgrel=$PKGREL
pkgdesc="Command Line Scripts for ZJU"
url="https://github.com/QSCTech/$PKGNAME"
arch=('any')
license=('GPL')
depends=('xl2tpd>=1.3.7' 'curl' 'dnsutils')
source=("$PKGNAME-$PKGVER.tar.gz::https://github.com/QSCTech/$PKGNAME/archive/v$PKGVER.tar.gz")
md5sums=('$FILE_MD5')
sha1sums=('$FILE_SHA1')
sha256sums=('$FILE_SHA256')

package() {
	cd "\$srcdir/$PKGNAME-$PKGVER"
	DESTDIR=\$pkgdir PREFIX=/usr ./install.sh
}
EOF

makepkg $*
makepkg --printsrcinfo > .SRCINFO
