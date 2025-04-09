#!/bin/sh

if ! command -v aria2c > /dev/null 2>&1; then
    echo "aria2c is not installed" >&2
    exit 1
fi

if ! command -v wget > /dev/null 2>&1 || ! command -v curl > /dev/null 2>&1; then
    echo "wget and curl is not installed, install both of them first."
    exit 1
fi
if command -v sudo > /dev/null 2>&1;then
    is_root=no
fi
if ! command -v jq > /dev/null 2>&1; then
     echo "jq is not installed, Installing ..."
     if [ "$is_root" = "no" ];then 
        wget -q "https://github.com/jqlang/jq/releases/latest/download/jq-linux-amd64" 
        sudo chmod +x jq-linux-amd64
        sudo mv jq-linux-amd64 /usr/bin/jq
     else 
        wget -q "https://github.com/jqlang/jq/releases/latest/download/jq-linux-amd64" 
        chmod +x jq-linux-amd64
        mv jq-linux-amd64 /usr/bin/jq
     fi
     echo "Done."
     echo "Relaunch the script"
     exit
fi

if [ -z "$1" ] || ! echo "$1" | grep -q '^https://gofile.io/d/'; then
    echo "Need a valid URL" >&2
    echo "aria2c should be installed to work" >&2
    exit 1
fi

token=$(curl -s -X POST https://api.gofile.io/accounts | jq -r .data.token )

link=$1
Id=$(echo "$link" | cut -d'/' -f5)

webToken="4fd6sg89d7s6"

content="https://api.gofile.io/contents/$Id?wt=$webToken"

valid=$(curl -s -H "Authorization: Bearer $token" "$content" | jq -r .status)

if [ "$valid" != "ok" ]; then
    echo "File does not exist" >&2
    exit 1
fi

dl_link=$(curl -s -H "Authorization: Bearer $token" "$content" | jq -r .data.children[].link)
echo "$dl_link" > /tmp/temp.txt

aria2c -x3 --header="Authorization: Bearer $token" -i /tmp/temp.txt -Z

rm /tmp/temp.txt
