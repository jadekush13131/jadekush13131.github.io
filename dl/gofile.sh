#!/bin/sh
green="\033[0;32m"
rc="\033[0m"
red="\033[0;31m"

DIR="$HOME/.local/bin"
mkdir -p $DIR

if ! command -v aria2c > /dev/null 2>&1; then
    echo "aria2c is not installed" >&2
    exit 1
fi

if ! command -v wget > /dev/null 2>&1 || ! command -v curl > /dev/null 2>&1; then
    echo "wget and curl is not installed, install both of them first."
    exit 1
fi
if ! command -v jq > /dev/null 2>&1; then
     printf "jq is not installed, ${green}Installing ...\n${rc}"
     wget -q "https://github.com/jqlang/jq/releases/latest/download/jq-linux-amd64" 
     chmod +x jq-linux-amd64
    if [ "$(id -u)" -ne 0 ]; then
      sudo mkdir -p /usr/local/bin
      mv jq-linux-amd64 $DIR/jq
      sudo ln -s $DIR/jq /usr/local/bin/jq
    else 
      mkdir -p /usr/local/bin
      mv jq-linux-amd64 $DIR/jq
      ln -s $DIR/jq /usr/local/bin/jq
    fi
     printf "${green}installed jq${rc}\n"
     echo "Relaunch the script"
     exit
fi

if [ -z "$1" ] || ! echo "$1" | grep -q '^https://gofile.io/d/'; then
    echo "need a valid url" 
    exit 1
fi

token=$(curl -s -X POST https://api.gofile.io/accounts | jq -r .data.token )
link=$1
Id=$(echo "$link" | cut -d'/' -f5)
webToken="4fd6sg89d7s6"
content="https://api.gofile.io/contents/$Id"
valid=$(curl -s -H "X-Website-Token: $webToken" -H "Authorization: Bearer $token" "$content" | jq -r .status)

if [ "$valid" != "ok" ]; then
    echo "File does not exist" >&2
    exit 1
fi
dl_link=$(curl -s -H "X-Website-Token: $webToken" -H "Authorization: Bearer $token" "$content"  | jq -r .data.children[].link)
echo "$dl_link" > /tmp/temp.txt
aria2c -x3 -c --header="Authorization: Bearer $token" -i /tmp/temp.txt -Z
rm /tmp/temp.txt
