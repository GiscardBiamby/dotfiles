#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
source "${SCRIPT_DIR}/../util.sh"


echo "Installing Chrome"
wget \
    https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    -O "${SCRIPT_DIR}/downloads/google-chrome-stable_current_amd64.deb"
sudo apt install "${SCRIPT_DIR}/downloads/google-chrome-stable_current_amd64.deb"

# During the installation process, the official Google repository will be added to your
# system. You can use the cat command to verify the file contents:
cat /etc/apt/sources.list.d/google-chrome.list

rm "${SCRIPT_DIR}/downloads/google-chrome-stable_current_amd64.deb"
