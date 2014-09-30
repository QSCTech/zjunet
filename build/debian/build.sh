VERSION=0.0.57
PKG=zjunet-${VERSION}
mkdir -p ${PKG}
tar cvzf ${PKG}.tar.gz ../../lib/
cd ${PKG}
dh_make -e zenoofzeng@gmail.com -f ../${PKG}.tar.gz
