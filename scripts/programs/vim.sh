#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"


sudo add-apt-repository -y ppa:jonathonf/vim
sudo apt update
sudo apt install -y vim vim-runtime universal-ctags vim-doc vim-scripts


# uninstall
# sudo apt remove vim vim-runtime ctags universal-ctags  vim-doc vim-scripts
# sudo add-apt-repository -r ppa:jonathonf/vim -y
