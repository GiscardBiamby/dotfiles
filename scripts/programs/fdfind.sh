#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"

echo "🔍🔍 Installing fd-find"

sudo apt install zoxide fd-find
mkdir -p ~/local/bin
ln -s "$(command -v fdfind)" ~/local/bin/fd
