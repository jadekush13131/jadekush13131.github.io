#!/bin/sh
green="\033[0;32m"
rc="\033[0m"
red="\033[0;31m"

DIR="$HOME/.local/bin"

mkdir -p $DIR

if ! command -v curl > /dev/null 2>&1 || ! command -v aria2c > /dev/null 2>&1 || ! command -v wget > /dev/null 2>&1;then
        printf "Install these packages :\n${green}\tcurl\n\twget\n\taria2c\n\n${rc}"
        exit 1
fi
echo "Installing Buzz."
wget -O $DIR/buzz https://jadekush13131.github.io/dl/buzz.sh -q
chmod +x $DIR/buzz
echo "Installing GoFile."
wget -O $DIR/gofile https://jadekush13131.github.io/dl/gofile.sh -q
chmod +x $DIR/gofile
echo "DONE!."

if [ "$(id -u)" -ne 0 ]; then
  sudo mkdir -p /usr/local/bin
  sudo ln -sf $DIR/buzz        /usr/local/bin/buzz
  sudo ln -sf $DIR/gofile      /usr/local/bin/gofile
else
   mkdir -p /usr/local/bin
   ln -sf $DIR/buzz        /usr/local/bin/buzz
   ln -sf $DIR/gofile      /usr/local/bin/gofile
fi

