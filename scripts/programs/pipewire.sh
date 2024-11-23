#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"

echo " Installing pipewire, wireplumber, and bluetooth codecs"

##Based on instructions from this page:
#https://ubuntuhandbook.org/index.php/2022/04/pipewire-replace-pulseaudio-ubuntu-2204/

## Misc
# It seems pipewire on 22.04 should already have all the codec support, so can remove the berglh
# ppa:
# https://www.reddit.com/r/Ubuntu/comments/qbw4pc/aptx_aptx_hd_ldac_bluetooth_codec_pulseaudio_150/

# Install Bluetooth codecs AAC/LDAC/AptX:
sudo apt install -y \
    libfdk-aac2 \
    libldacbt-{abr,enc}2 \
    libopenaptx0

# Install remaining PipeWire packages and WirePlumber as the session manager: Note, I may have had
# trouble with wireplumber in the past. If it messes up, remove it and reinstall
# pipewire-media-session
#
#Notice '-' at the end of 'pipewire-media-session'. This is to remove it in the same command,
#because 'wireplumber' will be used instead.:
sudo apt install -y \
    libspa-0.2-bluetooth \
    libspa-0.2-jack \
    pipewire-audio-client-libraries \
    pipewire-media-session- \
    wireplumber

systemctl --user --now enable wireplumber.service

## Configure

## ALSA
# Single step. Copy the config file from the PipeWire examples into your ALSA configuration
# directory:
sudo cp /usr/share/doc/pipewire/examples/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d/

# ## JACK
# sudo cp /usr/share/doc/pipewire/examples/ld.so.conf.d/pipewire-jack-*.conf /etc/ld.so.conf.d/
# sudo ldconfig

## Bluetooth
# Just remove this package and Bluetooth will be handled by PipeWire:
sudo apt remove pulseaudio-module-bluetooth

# Enable the media session:
systemctl --user --now enable wireplumber.service