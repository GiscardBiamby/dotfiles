#!/bin/bash

. util.sh

echo "Installing workstation tools"
sudo apt-add-repository universe
sudo apt update

# Workstation only
install anki
install calibre
install cpu-checker
install exfat-fuse
install exfat-utils
install ffmpeg
install gimp
install gnome-tweaks
install gnome-tweak-tool
install gparted
install gscan2pdf
install nedit
install okular
install openssh-client
install openssh-server
install remmina
install smartmontools
install solaar
install spotify
install texstudio
install tilix
install unetbootin
install usbutils
install util-linux
install vlc

sudo systemctl enable ssh.service

# Load dconf settings:
# dconf load /org/gnome/ < .config/dconf/settings.dconf
dconf load /com/gexperts/Tilix/ < .config/dconf/tilix.dconf