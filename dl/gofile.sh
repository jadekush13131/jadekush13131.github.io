#!/bin/sh

for cmd in curl wget aria2c jq; do
    if ! command -v "$cmd" > /dev/null 2>&1; then
        echo "$cmd not found" >&2
        exit 1
    fi
done    

if [ -z "$1" ] || ! echo "$1" | grep -q '^https://gofile.io/d/'; then
    echo "need a valid url" 
    exit 1
fi
ua="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:155.0) Gecko/20100101 Firefox/155.0"
token=$(curl -s -X POST https://api.gofile.io/accounts | jq -r .data.token )
link=$1
time_window=$(( $(date +%s) / 14400))
Id=$(echo "$link" | cut -d'/' -f5)

string="$ua::en-US::$token::$time_window::12af056dacea0b"

hash=$(echo -n $string | sha256sum | cut -d ' ' -f1)

curl_with_headers() {
    curl \
        -H "Authorization: Bearer $token" \
        -H "User-Agent: $ua" \
        -H "X-Website-Token: $hash" \
        -H "X-BL: en-US" \
        "$@"
}

content="https://api.gofile.io/contents/$Id"
response=$(curl_with_headers -s "$content")

if [ $(printf '%s' "$response" | jq -r '.status') != "ok" ]; then
    echo "File does not exist" >&2
    exit 1
fi

dl_link=$(echo $response |  jq -r '.data.children[].link')
echo "$dl_link" > /tmp/temp.txt
aria2c -x3 -c --header="Authorization: Bearer $token" -i /tmp/temp.txt -Z
rm /tmp/temp.txt
