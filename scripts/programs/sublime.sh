#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"


# Firefox browser
echo "🦊 Installing SublimeText"



sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg -o /tmp/sublimehq-pub.gpg.asc
sudo gpg --dearmor --batch --yes -o /etc/apt/keyrings/sublimehq-pub.gpg /tmp/sublimehq-pub.gpg.asc
sudo chmod a+r /etc/apt/keyrings/sublimehq-pub.gpg
rm -f /tmp/sublimehq-pub.gpg.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/sublimehq-pub.gpg] https://download.sublimetext.com/ apt/stable/" \
| sudo tee /etc/apt/sources.list.d/sublime-text.list >/dev/null

## Install
sudo apt update
install sublime-text
