#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"

echo " Installing Open Razer"
sudo add-apt-repository -y ppa:openrazer/stable
sudo apt update
sudo apt install openrazer-meta
sudo gpasswd -a $USER plugdev
echo "A reboot may be required"


echo " Installing polychromatic, a UI for Razer products"
sudo add-apt-repository -y ppa:polychromatic/stable
sudo apt update

# Full installation
sudo apt install -y polychromatic

# Or, selectively install components
# sudo apt install polychromatic-controller polychromatic-tray-applet polychromatic-cli