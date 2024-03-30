#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"

set +e
echo "📮 Installing postman"
# https://www.how2shout.com/linux/how-to-install-postman-on-ubuntu-20-04-lts-linux/
wget https://dl.pstmn.io/download/latest/linux64 -O "${SCRIPT_DIR}/downloads/linux64"
sudo tar -xvf "${SCRIPT_DIR}/downloads/linux64" -C /usr/bin

# Setup desktop shortcut
{
    echo "[Desktop Entry]"
    echo "Name=Postman API Tool"
    echo "GenericName=Postman"
    echo "Comment=Testing API"
    echo "Exec=/usr/bin/Postman/Postman"
    echo "Terminal=false"
    echo "X-MultipleArgs=false"
    echo "Type=Application"
    echo "Icon=/usr/bin/Postman/app/resources/app/assets/icon.png"
    echo "StartupWMClass=Postman"
    echo "StartupNotify=true"
} >> /usr/share/applications/Postman.desktop

rm "${SCRIPT_DIR}/downloads/linux64"

# Uninstall
# sudo rm -r /usr/bin/Postman
# sudo rm -r /usr/share/applications/Postman.desktop
# sudo rm -r ~/Desktop/Postman.desktop