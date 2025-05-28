#!/bin/sh
green="\033[0;32m"
rc="\033[0m"
red="\033[0;31m"
if [ "$(id -u)" -ne 0 ]; then
  printf "${red}This script must be run as root. Exiting. ${rc}\n"
  exit 1
fi

if ! command -v curl > /dev/null 2>&1 || ! command -v aria2c > /dev/null 2>&1 || ! command -v wget > /dev/null 2>&1;then
        printf "Install these packages :\n${green}\tcurl\n\twget\n\taria2c\n\n${rc}"
        exit 1
fi
mkdir -p /usr/local/bin
echo "Installing Buzz."
wget -O /usr/local/bin/buzz https://jadekush13131.github.io/buzz.sh -q
chmod +x /usr/local/bin/buzz
echo "Installing GoFile."
wget -O /usr/local/bin/gofile https://jadekush13131.github.io/gofile.sh -q
chmod +x /usr/local/bin/gofile
echo "Installing Cloudflared."
curl -s https://jadekush13131.github.io/tunnel.sh | sh > /dev/null 2>&1
echo "DONE!."
