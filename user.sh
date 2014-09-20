#!/bin/sh

# init
DIR="$HOME/.zjunet"
mkdir -p $DIR

# dispatch
case "$1" in
    add)
        echo "USERNAME: "
        read USERNAME
        echo "PASSWORD: "
        read PASSWORD
        echo $PASSWORD > "$DIR/$USERNAME"
        ;;
    edit)
        echo "USERNAME: "
        read USERNAME
        echo "PASSWORD: "
        read PASSWORD
        echo $PASSWORD > "$DIR/$USERNAME"
        ;;
    delete)
        echo "USERNAME: "
        read USERNAME
        rm -i "$DIR/$USERNAME"
        ;;
    list)
        ls $DIR
        ;;
esac
