#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
source "${SCRIPT_DIR}/../util.sh"


echo "🔐  Installing Keybase"
# curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb
wget \
    https://prerelease.keybase.io/keybase_amd64.deb -O \
    "${SCRIPT_DIR}/downloads/keybase_amd64.deb"
sudo apt install "${SCRIPT_DIR}/downloads/keybase_amd64.deb"
run_keybase
