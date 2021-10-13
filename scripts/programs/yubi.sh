#!/bin/bash

# https://support.yubico.com/hc/en-us/articles/360013708900-Using-Your-U2F-YubiKey-with-Linux
echo "Installing yubikey support for linux"
wget https://raw.githubusercontent.com/Yubico/libu2f-host/master/70-u2f.rules -O ./programs/downloads/70-u2f.rules
sudo cp ./programs/downloads/70-u2f.rules /etc/udev/rules.d/70-u2f.rules

# TODO: Install uyubikey manager (I think it was some kind of .AppImage)
