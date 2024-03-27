#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
source "${SCRIPT_DIR}/../util.sh"

# https://support.yubico.com/hc/en-us/articles/360013708900-Using-Your-U2F-YubiKey-with-Linux
echo "Installing yubikey support for linux"
wget \
    https://github.com/Yubico/libfido2/blob/main/udev/70-u2f.rules -O "${SCRIPT_DIR}/downloads/70-u2f.rules"
sudo cp "${SCRIPT_DIR}/downloads/70-u2f.rules" /etc/udev/rules.d/70-u2f.rules

# https://support.yubico.com/hc/en-us/articles/360016649039-Installing-Yubico-Software-on-Linux
#
# Packages below (in order): YubiKey Manager (CLI), YubiKey Personalization Tool (GUI),
echo "Installing: YubiKey Manager (CLI), YubiKey Personalization Tool (GUI), libpam-yubico, libpam-u2f, YubiKey Manager (GUI)..."
sudo apt install -y yubikey-manager libpam-yubico libpam-u2f yubikey-manager-qt

# Note: yubikey-personalization-gui (YubiKey Personalization Tool (GUI)) is replaced by YubiKey
# Manager (GUI, CLI). Used to configure a YubiKey device.

# Yubico Authenticator
echo "Installing Yubico Authenticator to /usr/local/bin/"
wget \
    https://developers.yubico.com/yubioath-flutter/Releases/yubico-authenticator-latest-linux.tar.gz \
    -O "${SCRIPT_DIR}/downloads/yubico-authenticator-latest-linux.tar.gz"
pushd "${SCRIPT_DIR}/downloads"
tar -xvzf yubico-authenticator-latest-linux.tar.gz
yubi_dir=$(find . -type d -iname "yubico-authenticator-*")
sudo rm -rf "/usr/local/bin/${yubi_dir}/"
sudo mv "${yubi_dir}" /usr/local/bin/
popd
echo "Installing yubikey authenticator desktop integration"
"/usr/local/bin/${yubi_dir}/desktop_integration.sh" -i
