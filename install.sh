#!/bin/sh

BASEDIR=$(dirname $0)
mkdir -p /usr/local/lib/zjunet
cp -rf $BASEDIR /usr/local/lib/zjunet
echo "#!/bin/sh" > /usr/local/bin/zjunet
echo '/usr/local/lib/zjunet/zjunet.sh "$@"' >> /usr/local/bin/zjunet
chmod +x /usr/local/bin/zjunet
echo "[INFO] Done."
echo
zjunet
