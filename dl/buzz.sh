#!/bin/sh

for cmd in curl grep tr awk aria2c;do
        if ! command -v "$cmd" > /dev/null 2>&1; then
                printf "$cmd not found\n" >&2
                exit 1
        fi
done

url="$1"

if [ -z "${url}" ] || ! echo "$1" | grep -q '^https://buzzheavier.com/'; then
  printf "need vaild url\n" >&2
  exit 1
fi

html=$(curl -sL -A \
 "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" \
 -H "HX-Request: true" \
 "$url")

request=$(echo "$html" | grep -oP 'hx-get="\K/[^"]+/download\?t=[^"]+' | head -n 1)

if [ -z "$request" ]; then
        printf "invalid link\n"
        exit 1
fi

headers=$(curl -sI -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" -H "HX-Request: true" "https://buzzheavier.com$request")

direct=$(echo "$headers" |  grep -i "^hx-redirect:" | awk '{print $2}' | tr -d '\r')

aria2c -x5 -c -s5 -k1M --summary-interval=1 "$direct"
