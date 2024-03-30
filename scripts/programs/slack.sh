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
    https://downloads.slack-edge.com/releases/linux/4.36.140/prod/x64/slack-desktop-4.36.140-amd64.deb \
    -O "${SCRIPT_DIR}/downloads/slack-desktop-4.36.140-amd64.deb"
sudo dpkg -i "${SCRIPT_DIR}/downloads/slack-desktop-4.36.140-amd64.deb"
sudo apt-get update
sudo apt-get upgrade slack-desktop
rm "${SCRIPT_DIR}/downloads/slack*.deb"
