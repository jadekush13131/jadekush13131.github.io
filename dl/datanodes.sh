#/bin/sh

set -e

[ "$#" -eq 0 ] && { echo "No arguments given" >&2; exit 1; }

if ! echo "$1" | grep -qE '^https://datanodes.to/' ;then
  printf "need valid url.\n"
  exit 1
fi

if ! command -v aria2c > /dev/null 2>&1 || ! command -v curl > /dev/null 2>&1 || ! command -v jq > /dev/null 2>&1; then
  echo "make sure aria2c, curl and jq are installed. exiting.."
  exit 1
fi

id=$(echo "$1" | cut -d/ -f4)

url=$(curl -s -X POST "https://datanodes.to/download" -F "op=download2"  -F "id=$id"  -F "rand="  -F "referer=https://datanodes.to/download"  -F "method_free=Free Download >>"  -F "method_premium="  -F "__dl=1") 

if ! echo "$url" | grep -qE '^\{'; then
  printf "errored. something went wrong.\n"
  exit 1
fi

dl=$(echo "$url" | jq -r .url  | sed 's/%/\\x/g' | xargs -0 printf "%b")

aria2c -x3 -c "$dl"
