#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"


echo "Installing workstation tools"
sudo add-apt-repository ppa:solaar-unifying/ppa -y
sudo apt-add-repository universe -y
sudo add-apt-repository ppa:jonmagon/kdiskmark -y
sudo add-apt-repository ppa:tomtomtom/yt-dlp -y
sudo apt update

# Workstation only
install anki
install calibre
install cifs-utils
install cpu-checker
install exfat-fuse
install exfat-utils
install ffmpeg
install fzf
install gimp
install gnome-tweaks
install gnome-tweak-tool
install gparted
install gscan2pdf
install imwheel
install kdiskmark
install keyutils
install nedit
install okular
install openssh-client
install openssh-server
install remmina
install smartmontools
install solaar
install spotify
install tilix
install ubuntu-restricted-extras
install unetbootin
install usbutils
install util-linux
install vlc
install yt-dlp

sudo systemctl enable ssh.service

# Load dconf settings:
# dconf load /org/gnome/ < .config/dconf/settings.dconf
dconf load /com/gexperts/Tilix/ < .config/dconf/tilix.dconf
dconf load /org/gnome/terminal/ < .config/dconf/terminal.dconf
