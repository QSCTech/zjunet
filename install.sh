#!/bin/sh

set -e

BASEDIR=$(dirname $0)/lib
if [ -z "$PREFIX" ]; then
	PREFIX=/usr/local
fi

mkdir -p $DESTDIR$PREFIX/lib/zjunet
cp -rf $BASEDIR/* $DESTDIR$PREFIX/lib/zjunet
mkdir -p $DESTDIR$PREFIX/bin
mkdir -p $DESTDIR$PREFIX/share/zjunet
ln -fs ../../share/zjunet/VERSION $DESTDIR$PREFIX/lib/zjunet/VERSION
cp -f VERSION $DESTDIR$PREFIX/share/zjunet
cat > $DESTDIR$PREFIX/bin/zjunet << EOF
#!/bin/sh
$PREFIX/lib/zjunet/zjunet.sh "\$@"
EOF
chmod +x $DESTDIR$PREFIX/bin/zjunet
echo "[INFO] Done."
echo
zjunet usage
