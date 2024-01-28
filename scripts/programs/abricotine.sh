#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
source "${SCRIPT_DIR}/../util.sh"

echo " Installing Abricotine"
VERSION=$(curl -s https://github.com/brrd/Abricotine/releases/latest/download 2>&1 | grep -Po [0-9]+\.[0-9]+\.[0-9]+)
echo "Abricotine version: ${VERSION}"
wget "https://github.com/brrd/Abricotine/releases/latest/download/abricotine-${VERSION}-ubuntu-debian-x64.deb"
sudo dpkg -i abricotine*.deb
