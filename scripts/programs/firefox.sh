#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"

# Firefox browser
echo "🦊 Installing Firefox"

# * Set the shell to run these commands and continue if they error:
set +e
sudo snap remove firefox
sudo apt remove firefox
set -e

sudo install -d -m 0755 /etc/apt/keyrings

# Instructions from here on how to install ad .deb instead of snap:
# https://www.omgubuntu.co.uk/2022/04/how-to-install-firefox-deb-apt-ubuntu-22-04
sudo add-apt-repository -y ppa:mozillateam/ppa
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc >/dev/null
cat <<EOF | sudo tee /etc/apt/sources.list.d/mozilla.sources
Types: deb
URIs: https://packages.mozilla.org/apt
Suites: mozilla
Components: main
Signed-By: /etc/apt/keyrings/packages.mozilla.org.asc
EOF
# Configure APT to prioritize packages from the Mozilla repository:
echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla


# Since you’ll (hopefully) want future Firefox upgrades to be installed automatically, Balint Reczey
# shares a concise command on his blog that ensures it happens:
echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox

## Install
sudo apt update
sudo apt install -y firefox
