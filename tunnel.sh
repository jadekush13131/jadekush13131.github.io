#!/bin/sh

if ! command -v wget > /dev/null 2>&1; then
    echo "wget is not installed."
    exit 1
fi

if command -v sudo > /dev/null 2>&1; then
    a="SUDO"
else
    a="NO_SUDO"
fi

if [ "$a" = "SUDO" ]; then
    wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
    sudo chmod +x cloudflared-linux-amd64
    sudo mv cloudflared-linux-amd64 /usr/local/bin/cloudflared
else
    wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
    chmod +x cloudflared-linux-amd64
    mv cloudflared-linux-amd64 /usr/local/bin/cloudflared
fi
