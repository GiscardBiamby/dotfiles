#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"

echo "Installing veracrypt"

# You can either install GUI or console version, not both:

# GUI version
wget \
    https://launchpad.net/veracrypt/trunk/1.26.24/+download/veracrypt-1.26.24-Ubuntu-24.04-amd64.deb \
    -O "${SCRIPT_DIR}/downloads/veracrypt-1.26.24-Ubuntu-24.04-amd64.deb"
sudo apt install -y "${SCRIPT_DIR}/downloads/veracrypt-1.26.24-Ubuntu-24.04-amd64.deb"

# Console version
# wget https://launchpad.net/veracrypt/trunk/1.24-update7/+download/veracrypt-console-1.24-Update7-Ubuntu-20.04-amd64.deb
# sudo apt install -y ./veracrypt-console-1.24-Update7-Ubuntu-20.04-amd64.deb

rm "${SCRIPT_DIR}/downloads/veracrypt-1.26.24-Ubuntu-24.04-amd64.deb"
