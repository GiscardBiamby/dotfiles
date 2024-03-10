#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
source "${SCRIPT_DIR}/../util.sh"


echo "📹🎙 Installing sqlitebrowser"
sudo add-apt-repository -y ppa:linuxgndu/sqlitebrowser
sudo apt update
install sqlitebrowser
