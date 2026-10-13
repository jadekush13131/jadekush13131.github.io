#!/bin/sh

#### MOCHA ONE PART UPLOAD LIMTI 5120M or 5.20GB

for cmd in curl jq file wc; do
	if ! command -v $cmd > /dev/null 2>&1; then
		printf "$cmd not found\n"
		exit 1
	fi
done

file="$1"

if [ -z "${TOKEN:-}" ]; then
  printf "\nSet \$TOKEN to continue.....\n\n"
  exit 1
fi 

if [ -z "${1-}" ]; then
  printf "file required\n" >&2
  exit 1
fi 

if [ ! -f "$file" ] || [ ! -r "$file" ]; then
  printf 'Error: "%s" not found.\n' "$file" >&2
  exit 1
fi

# size=$(wc -c < "$file") || exit 1
size=$(stat -c %s "$file") || { echo "Error: could not read file" >&2; exit 1; }
mimeType=$(file --mime-type -b "$file") || exit 1

token="$TOKEN"

check=$(curl -sS -o /dev/null \
 -w '%{http_code}' \
 -H "Authorization: Bearer $TOKEN" \
 'https://api.mocha.my/api/auth/me'
) 

if [ $check -ne 200 ]; then
  printf "\n\$TOKEN is not valid.\n\n"
  exit 1
fi 

init_payload=$(jq -n \
  --arg originalName "$file" \
  --argjson size "$size" \
  --arg mimeType "$mimeType" \
  --arg path "/" \
  '{originalName: $originalName, size: $size, mimeType: $mimeType, path: $path}')

init=$(curl -fsS -X POST 'https://api.mocha.my/api/files/multipart/init' \
  -H "Authorization: Bearer $token" \
  -H 'Content-Type: application/json' \
  -d "$init_payload") || exit 1

upid=$(printf '%s\n' "$init" | jq -er '.uploadId') || exit 1
key=$(printf '%s\n' "$init" | jq -er '.key') || exit 1
nodeid=$(printf '%s\n' "$init" | jq -er '.nodeId') || exit 1

presigned_payload=$(jq -cn \
  --arg uploadId "$upid" \
  --arg key "$key" \
  --arg nodeId "$nodeid" \
  --arg originalName "$file" \
  --arg path "/" \
  '{uploadId: $uploadId, key: $key, nodeId: $nodeId, originalName: $originalName, path: $path, partNumbers: [1]}')

presigned=$(curl -fsS -X POST 'https://api.mocha.my/api/files/multipart/presigned' \
 -H "Authorization: Bearer $token" \
 -H "Content-Type: application/json" \
 -d $presigned_payload) || exit 1

put_url=$(printf '%s\n' $presigned | jq -r '.urls[].url')

etag=$(curl -S -D - -T "$file" $put_url -o /dev/null |  awk 'BEGIN { IGNORECASE=1 } /^ETag:/ { sub(/\r$/, ""); sub(/^[^:]*:[[:space:]]*/, ""); print }')

complete_payload=$(jq -cn --arg uploadId "$upid" --arg key "$key" --arg nodeId "$nodeid" --arg originalName "$file" --arg path "/" --argjson size $size --arg etag "$etag" '{uploadId:$uploadId,key:$key,nodeId:$nodeId,originalName:$originalName,path:$path,size:$size,parts:[{partNumber:1,etag:$etag}]}')

complete=$(curl -s -X POST 'https://api.mocha.my/api/files/multipart/complete' \
 -H "Authorization: Bearer $token" \
 -H "Content-Type: application/json" \
 -d $complete_payload ) || exit 1

echo $complete | jq


#U2FsdGVkX1/WBjj0Pn/Rqw+aSR18WIo2To5XyqRdIIdTtwu34HJwQfOmsiwTNfebb+wc+iL2nAEqLa7dCjYcuBwYODRAPcLLm3xAXUkRo/Y=
# Aa
