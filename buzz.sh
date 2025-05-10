#!/bin/sh

if ! command -v curl > /dev/null 2>&1 || ! command -v aria2c > /dev/null 2>&1;then
        echo "Either curl or aria2c is not installed"
        exit 1
fi
if [ -z "$1" ] || ! echo "$1" | grep -q '^https://buzzheavier.com'; then
    echo "need url" >&2
    exit 1
fi
link=$1
dl_link=$(curl -sD - "$1/download"  --header "Referer: $1" | grep -i "hx-redirect" | sed 's/.*hx-redirect: //I')
aria2c -x5  "https://buzzheavier.com$dl_link"
