#!/bin/sh
green="\033[0;32m"
rc="\033[0m"
red="\033[0;31m"
if [ "$(id -u)" -ne 0 ]; then
  printf "${red}This script must be run as root. Exiting. ${rc}\n"
  exit 1
fi
if ! command -v wget > /dev/null 2>&1; then
    echo "wget is not installed."
    exit 1
fi
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x cloudflared-linux-amd64
mv cloudflared-linux-amd64 /usr/local/bin/cloudflared

