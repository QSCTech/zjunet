#!/bin/sh

rm -rf *.rpm

VERSION=$1
REALVERSION=`echo "$VERSION" | cut -d'-' -f1`
RELEASE=`echo "$VERSION" | cut -d'-' -f2`

mkdir -p rpm/

# share
cp ../../miscellaneous/* rpm/
cp ../../VERSION rpm/

# lib
mkdir -p rpm/lib/
cp ../../lib/* rpm/lib/

# bin
echo '/usr/lib/zjunet/zjunet.sh "$@"' > rpm/zjunet
chmod +x rpm/zjunet

# rpm
ARCH="noarch"
SEMINAME="zjunet-$REALVERSION"
FULLNAME="zjunet-$VERSION"
rm -rf ${SEMINAME}.tar.gz
find rpm -type d | xargs chmod 755
rm -rf $SEMINAME
mv rpm $SEMINAME
tar zcvf ${SEMINAME}.tar.gz $SEMINAME
mkdir -p $HOME/rpmbuild/SOURCES
cp ${SEMINAME}.tar.gz $HOME/rpmbuild/SOURCES
cp build_spec.sh $SEMINAME/
cd $SEMINAME
./build_spec.sh $VERSION
cd ..
cp "$SEMINAME/zjunet.spec" ./
mkdir -p "$HOME/rpmbuild/SPECS"
cp zjunet.spec "$HOME/rpmbuild/SPECS"
fakeroot rpmbuild -ba zjunet.spec --target $ARCH
rm -rf zjunet.spec ${SEMINAME}.tar.gz $SEMINAME
cp $HOME/rpmbuild/RPMS/$ARCH/${FULLNAME}.$ARCH.rpm ./

