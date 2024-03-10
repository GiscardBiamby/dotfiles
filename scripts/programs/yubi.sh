#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
source "${SCRIPT_DIR}/../util.sh"

# https://support.yubico.com/hc/en-us/articles/360013708900-Using-Your-U2F-YubiKey-with-Linux
echo "Installing yubikey support for linux"
wget \
    https://raw.githubusercontent.com/Yubico/libu2f-host/master/70-u2f.rules \
    -O "${SCRIPT_DIR}/downloads/70-u2f.rules"
sudo cp "${SCRIPT_DIR}/downloads/70-u2f.rules" /etc/udev/rules.d/70-u2f.rules

# TODO: Install yuubikey manager (I think it was some kind of .AppImage)
