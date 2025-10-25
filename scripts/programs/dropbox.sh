#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"

echo "Installing dropbox"

# TODO: Update this to download the .deb because that has better features and autostart functionality built in. the headless install seems to require DIY auto-start.

cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -

# Nohup to launch GUI app detached (aka. "disowned", "disentangled", "decoupled") (from:
# https://askubuntu.com/a/46211):
nohup ~/.dropbox-dist/dropboxd &
