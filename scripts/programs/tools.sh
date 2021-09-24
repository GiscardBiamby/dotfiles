#!/bin/bash

. util.sh

echo "Installing workstation tools"
sudo add-apt-repository ppa:solaar-unifying/ppa
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
install pandoc
install remmina
install smartmontools
install solaar
install spotify
install texlive-xetex
install texlive-fonts-recommended
install texlive-plain-generic
install texstudio
install tilix
install ubuntu-restricted-extras
install unetbootin
install usbutils
install util-linux
install vlc

sudo systemctl enable ssh.service

# Load dconf settings:
# dconf load /org/gnome/ < .config/dconf/settings.dconf
dconf load /com/gexperts/Tilix/ < .config/dconf/tilix.dconf
dconf load /org/gnome/terminal/ < .config/dconf/terminal.dconf
