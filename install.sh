#!/bin/sh

set -e

BASEDIR=$(dirname $0)/lib
if [ -z "$PREFIX" ]; then
	PREFIX=/usr/local
fi

mkdir -p $PREFIX/lib/zjunet
cp -rf $BASEDIR/* $PREFIX/lib/zjunet
mkdir -p $PREFIX/bin
mkdir -p $PREFIX/share/zjunet
ln -fs ../../share/zjunet/VERSION $PREFIX/lib/zjunet/VERSION
cp -f VERSION $PREFIX/share/zjunet
cat > $PREFIX/bin/zjunet << EOF
#!/bin/sh
$PREFIX/lib/zjunet/zjunet.sh "\$@"
EOF
chmod +x $PREFIX/bin/zjunet
echo "[INFO] Done."
echo
zjunet usage
