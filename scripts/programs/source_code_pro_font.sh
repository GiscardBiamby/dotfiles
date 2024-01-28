#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
source "${SCRIPT_DIR}/../util.sh"

DOWNLOAD_DIR="${SCRIPT_DIR}/downloads/"

pushd "${DOWNLOAD_DIR}"
wget https://github.com/adobe-fonts/source-code-pro/archive/refs/tags/2.042R-u/1.062R-i/1.026R-vf.zip
unzip 1.026R-vf.zip
mkdir -p ~/.fonts
find ./ -type f -wholename "*/OTF/*.otf" -exec cp {} ~/.fonts/ \;
fc-cache -f -v
