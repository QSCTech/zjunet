#!/bin/sh

BASEDIR=$(dirname $0)/lib
mkdir -p /usr/local/lib/zjunet
cp -rf $BASEDIR /usr/local/lib/zjunet
mkdir -p /usr/local/bin
echo "#!/bin/sh" > /usr/local/bin/zjunet
echo '/usr/local/lib/zjunet/zjunet.sh "$@"' >> /usr/local/bin/zjunet
chmod +x /usr/local/bin/zjunet
echo "[INFO] Done."
echo
zjunet usage
