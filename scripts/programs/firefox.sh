#!/bin/bash

# Firefox browser
echo "🦊 Installing Firefox"
# Instructions from here on how to install ad .deb instead of snap:
# https://www.omgubuntu.co.uk/2022/04/how-to-install-firefox-deb-apt-ubuntu-22-04
sudo add-apt-repository ppa:mozillateam/ppa

# Next, alter the Firefox package priority to ensure the PPA/deb/apt version of Firefox is
# preferred. This can be done using a slither of code from FosTips (copy and paste it whole, not
# line by line):
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | sudo tee /etc/apt/preferences.d/mozilla-firefox

# Since you’ll (hopefully) want future Firefox upgrades to be installed automatically, Balint Reczey
# shares a concise command on his blog that ensures it happens:
echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox

## Install
sudo apt update
sudo apt install -y firefox
