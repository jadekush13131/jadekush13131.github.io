if [[ $(command -v sudo) ]];then
a="SUDO"
else
a="NO_SUDO"
fi

if [[ $a == "SUDO" ]];then
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && sudo dpkg -i cloudflared-linux-amd64.deb && rm cloudflared-linux-amd64.deb
else
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && dpkg -i cloudflared-linux-amd64.deb && rm cloudflared-linux-amd64.deb
fi
