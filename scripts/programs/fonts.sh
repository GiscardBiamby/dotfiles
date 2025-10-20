#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"

# Firefox browser
echo "🦊 Installing Fonts"

sudo mkdir -p /usr/local/share/fonts/AtkinsonHyperlegibleMono
# Copy OTFs — quote the path, not the glob
sudo cp "/home/gbiamby/proj/dotfiles/scripts/programs/binaries/Atkinson Hyperlegible Mono_Final/"*.otf \
    /usr/local/share/fonts/AtkinsonHyperlegibleMono/

sudo mkdir -p /usr/local/share/fonts/AtkinsonHyperlegibleNext
sudo cp "/home/gbiamby/proj/dotfiles/scripts/programs/binaries/Atkinson Hyperlegible Next/"*.otf \
    /usr/local/share/fonts/AtkinsonHyperlegibleNext/

sudo fc-cache -f -v
