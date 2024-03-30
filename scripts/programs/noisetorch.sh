#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"

echo "🕪 Installing noisetorch 🕪"
# THis script follows a customized install procedure to get around nosuid issue mentioned here:
# https://github.com/noisetorch/NoiseTorch/issues/341

NOISETORCH_VERSION=$(wget -q -O - 'https://api.github.com/repos/noisetorch/NoiseTorch/releases/latest' \
    | jq -r '.name')

mkdir -p "${SCRIPT_DIR}/downloads/noisetorch"
pushd "${SCRIPT_DIR}/downloads/noisetorch"

echo "Downloading noisetorch version ${NOISETORCH_VERSION}"
# Get latest release (this might be brittle -- api might change)
# shellcheck disable=SC2046
wget $(wget -q -O - 'https://api.github.com/repos/noisetorch/NoiseTorch/releases/latest' \
    | jq -r '.assets[] | select(.name | endswith(".tgz")).browser_download_url') \
    -O "NoiseTorch_x64_v${NOISETORCH_VERSION}.tgz"
tar -C ./ -h -xzf NoiseTorch_x64_v${NOISETORCH_VERSION}.tgz
mkdir -p /opt/noisetorch/
sudo cp -r ./.local/bin /opt/noisetorch/

# NB: Need an entry in .zshrc/.bashrc that adds /opt/noisetorch/bin to $PATH. It's already in the
# .zshrc in this dotfiles repo

echo "Creating /usr/local/bin/noisetorch_autostart.sh..."
cat - > ./noisetorch_autostart.sh <<EOT
#!/bin/bash
set -e

# The device_id
# "alsa_input.usb-Blue_Microphones_Yeti_Stereo_Microphone_797_2020_04_09_55304-00.iec958-stereo"
# comes from running "noisetorch -l"

# Usage of noisetorch:
#   -c    Check if update is available (but do not update)
#   -i    Load supressor for input. If no source device ID is specified the default pulse audio source is used.
#   -l    List available PulseAudio devices
#   -log
#         Print debugging output to stdout
#   -o    Load supressor for output. If no source device ID is specified the default pulse audio source is used.
#   -s string
#         Use the specified source/sink device ID
#   -setcap
#         for internal use only
#   -t int
#         Voice activation threshold (default -1)
#   -u    Unload supressor

noisetorch \\
    -s alsa_input.usb-Blue_Microphones_Yeti_Stereo_Microphone_797_2020_04_09_55304-00.iec958-stereo \\
    -i -o \\
    -t 75

exit 0

EOT
chmod +x ./noisetorch_autostart.sh
sudo mv ./noisetorch_autostart.sh /usr/local/bin/noisetorch_autostart.sh

echo "Add autostart entry"
cat - > ~/.config/autostart/noisetorch.desktop <<EOT
[Desktop Entry]
Type=Application
Exec=/usr/local/bin/noisetorch_autostart.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=noisetorch
Name=noisetorch
Comment[en_US]=noisetorch
Comment=noisetorch
EOT

popd