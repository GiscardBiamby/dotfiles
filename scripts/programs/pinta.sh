#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"

echo "🖌 Installing Pinta"
# THis method doesn't work on 25.10 (at least not yet):
#sudo add-apt-repository -y ppa:pinta-maintainers/pinta-stable
#sudo apt update
#sudo apt-get install -y pinta

# Add the xtradeb repo:
wget https://launchpad.net/~xtradeb/+archive/ubuntu/apps/+files/xtradeb-apt-source_0.4_all.deb
sudo apt install ./xtradeb-apt-source_0.4_all.deb
rm ./xtradeb-apt-source_0.4_all.deb

sudo apt update
sudo apt-get install -y pinta

