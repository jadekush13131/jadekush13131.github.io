#!/bin/bash

wget -q http://installer.jdownloader.org/JDownloader.jar
java -jar JDownloader.jar -norestart > /dev/null 2>&1
echo "Install, Updated JDownloader and restarting the server...."

read -p "Enter email: " email
read -p "Enter password: " password

# JSON string
json='{"email":"", "password":"", "devicename":"linux@root", "directconnectmode":"LAN"}'

# Use awk to update the JSON
updated_json=$(echo "$json" | awk -v email="$email" -v password="$password" '{
  gsub(/"email":"[^"]*"/, "\"email\":\"" email "\"");
  gsub(/"password":"[^"]*"/, "\"password\":\"" password "\"");
  print
}')


# Save the updated JSON to the settings.json file
echo "$updated_json" > cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json

java -jar JDownloader.jar -norestart
