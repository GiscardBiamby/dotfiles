#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"


echo "Installing workstation tools"
sudo apt-add-repository -y universe
sudo add-apt-repository -y ppa:jonmagon/kdiskmark
sudo add-apt-repository -y ppa:tomtomtom/yt-dlp
sudo apt update

# Workstation only
install cifs-utils
install cpu-checker
install exfatprogs
install ffmpeg
install fzf
install gparted
install gscan2pdf
install imwheel
install kdiskmark
install keyutils
install nedit
install openssh-client
install openssh-server
install smartmontools
install ubuntu-restricted-extras
install unetbootin
install usbutils
install util-linux
install vlc
install yt-dlp

sudo systemctl enable ssh.service
