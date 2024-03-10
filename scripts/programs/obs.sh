#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
source "${SCRIPT_DIR}/../util.sh"

echo "📹🎙 Installing OBS"
install ffmpeg
install v4l2loopback-dkms
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt update
install obs-studio
