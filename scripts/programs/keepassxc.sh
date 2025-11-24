#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"

echo "🔐 Installing keepassxc"
# ppa:phoerious/keepassxc is the ppa for the latest keepassxc releases mentioned on the official
# keepassxc website. Note about other keepass packages: keepassx is dead, keepass2 is the original
# windows app running on linux via mono/wine, poor wayland integration and often requires xwayland.
# keepassxc is the modern active community-driven fork. Native linux (qt-based, and wayland-native).
sudo add-apt-repository -y ppa:phoerious/keepassxc
sudo apt update
install keepassxc
