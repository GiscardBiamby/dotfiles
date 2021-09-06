#!/bin/bash

. util.sh

echo "📹🎙 Installing OBS"
install ffmpeg
install v4l2loopback-dkms
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt update
install obs-studio
