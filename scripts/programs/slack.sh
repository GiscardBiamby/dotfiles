#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"

echo "💬 Install Slack"
# sudo snap install slack --classic
wget \
    https://downloads.slack-edge.com/desktop-releases/linux/x64/4.46.101/slack-desktop-4.46.101-amd64.deb \
    -O "${SCRIPT_DIR}/downloads/slack-desktop-4.46.101-amd64.deb"
sudo dpkg -i "${SCRIPT_DIR}/downloads/slack-desktop-4.46.101-amd64.deb"
sudo apt-get update
sudo apt-get upgrade -y slack-desktop
rm "${SCRIPT_DIR}/downloads/slack*.deb"
