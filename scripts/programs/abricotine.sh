#!/bin/bash

. util.sh

echo " Installing Abricotine"
VERSION=$(curl -s https://github.com/brrd/Abricotine/releases/latest/download 2>&1 | grep -Po [0-9]+\.[0-9]+\.[0-9]+)
echo "Abricotine version: ${VERSION}"
wget "https://github.com/brrd/Abricotine/releases/latest/download/abricotine-${VERSION}-ubuntu-debian-x64.deb" 
sudo dpkg -i abricotine*.deb
