#!/bin/sh
green="\033[0;32m"
rc="\033[0m"
red="\033[0;31m"
DIR="$HOME/.local/bin"

if ! command -v wget > /dev/null 2>&1; then
    printf "${red}wget is not installed\n${rc}"
    exit 1
fi

mkdir -p $DIR
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x cloudflared-linux-amd64

if [ "$(id -u)" -ne 0 ]; then
  mv cloudflared-linux-amd64 $DIR/cloudflared
  sudo mkdir -p /usr/local/bin
  sudo ln -sf $DIR/cloudflared /usr/local/bin/cloudflared
else
  mkdir -p /usr/local/bin
  ln -sf $DIR/cloudflared /usr/local/bin/cloudflared
fi

