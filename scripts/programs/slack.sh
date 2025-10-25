#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"

echo "💬 Install Slack"

# TODO: Make this into a reusable function since it's used in multiple places
# Keyring (non-interactive, idempotent)
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://packagecloud.io/slacktechnologies/slack/gpgkey -o /tmp/slack.gpg.asc
sudo gpg --dearmor --batch --yes -o /etc/apt/keyrings/slack.gpg /tmp/slack.gpg.asc
sudo chmod a+r /etc/apt/keyrings/slack.gpg
rm -f /tmp/slack.gpg.asc

# Install apt repo:
sudo find /etc/apt/sources.list.d/ -type f -iwholename "*slack*" -delete || true
sudo tee /etc/apt/sources.list.d/slack.sources >/dev/null <<'EOF'
Types: deb
URIs: https://packagecloud.io/slacktechnologies/slack/debian/
Suites: jessie
Components: main
Architectures: amd64
Signed-By: /etc/apt/keyrings/slack.gpg
EOF

# sudo snap install slack --classic
# wget \
#     https://downloads.slack-edge.com/desktop-releases/linux/x64/4.46.101/slack-desktop-4.46.101-amd64.deb \
#     -O "${SCRIPT_DIR}/downloads/slack-desktop-4.46.101-amd64.deb"
# sudo dpkg -i "${SCRIPT_DIR}/downloads/slack-desktop-4.46.101-amd64.deb"
sudo apt-get update
sudo apt-get upgrade -y slack-desktop

echo "Deleting Slack installer..."
find "${SCRIPT_DIR}/downloads" -type f -iname "slack*.deb" || true
find "${SCRIPT_DIR}/downloads" -type f -iname "slack*.deb" -delete || true
