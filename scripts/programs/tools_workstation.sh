#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"

echo "Installing workstation tools"
sudo add-apt-repository -y ppa:solaar-unifying/ppa
sudo apt-add-repository -y universe
sudo add-apt-repository -y ppa:jonmagon/kdiskmark
sudo add-apt-repository -y ppa:tomtomtom/yt-dlp
sudo apt update

# Workstation only
install anki
install avahi-browse
install calibre
install cifs-utils
install cpu-checker
install exfatprogs
install ffmpeg
install fzf
install gimp
install gnome-shell-extension-manager
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
install usbutils
install util-linux
install vlc
install yt-dlp

# install bluetooth codecs and tools
install pipewire-audio-client-libraries
install libspa-0.2-bluetooth
install bluez
install bluez-tools
install libfreeaptx0
install liblc3-1

sudo systemctl enable ssh.service

# TODO Move this to after the doffiles install
# Load dconf settings:
# dconf load /org/gnome/ < .config/dconf/settings.dconf
dconf load /com/gexperts/Tilix/ <.config/dconf/tilix.dconf
dconf load /org/gnome/terminal/ <.config/dconf/terminal.dconf
