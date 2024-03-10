#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
source "${SCRIPT_DIR}/../util.sh"

echo "📂 Installing direnv"

# curl -qfsSL https://github.com/direnv/direnv/releases/download/v2.19.0/direnv.linux-amd64 -o direnv
wget \
    https://github.com/direnv/direnv/releases/latest/download/direnv.linux-amd64 \
    -O "${SCRIPT_DIR}/downloads/direnv"
chmod +x "${SCRIPT_DIR}/downloads/direnv"
sudo mv "${SCRIPT_DIR}/downloads/direnv" /usr/local/bin
