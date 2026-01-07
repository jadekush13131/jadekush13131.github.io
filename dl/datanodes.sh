#/bin/sh

set -e

[ "$#" -eq 0 ] && { echo "No arguments given" >&2; exit 1; }

if ! command -v aria2c > /dev/null 2>&1 || ! command -v curl > /dev/null 2>&1 || ! command -v jq > /dev/null 2>&1; then
  echo "make sure aria2c, curl and jq are installed. exiting.."
  exit 1
fi


dl=$(curl -s -X POST "https://datanodes.to/download" -F "op=download2"  -F "id=$1"  -F "rand="  -F "referer=https://datanodes.to/download"  -F "method_free=Free Download >>"  -F "method_premium="  -F "__dl=1" | jq -r .url | sed 's/%/\\x/g' | xargs -0 printf "%b")

aria2c -x3 -c "$dl"
