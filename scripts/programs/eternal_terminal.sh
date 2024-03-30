#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"

echo " Installing Eternal Terminal"
echo "Maybe need to reconsider installing this. At some point it was causing ubuntu shutdown to hang for exactly one minute"
sudo add-apt-repository ppa:jgmath2000/et -y
sudo apt update
sudo apt-get install et
