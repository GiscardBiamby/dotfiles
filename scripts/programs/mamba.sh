#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"

echo "🐍 Installing mamba"

# https://github.com/conda-forge/miniforge#mambaforge
# Latest installers with Mamba in the base environment:
mkdir -p "${SCRIPT_DIR}/downloads/micromamba"
wget \
    "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh" \
    -O "${SCRIPT_DIR}/downloads/micromamba/Mambaforge-$(uname)-$(uname -m).sh"
bash "${SCRIPT_DIR}/downloads/micromamba/Mambaforge-$(uname)-$(uname -m).sh" -b -f

source ~/.bashprofile

# Not sure if the channel is required. It could be that it didn't work when i tried without the
# channel because I forgot to restart the terminal (I sourced ~/.bash_profile instead):
mamba install -c tartansandal conda-bash-completion -y
mamba install -c tartansandal mamba-bash-completion -y

# https://docs.conda.io/projects/conda/en/latest/user-guide/configuration/pip-interoperability.html:
conda config --set pip_interop_enabled True
conda config --set auto_activate_base False
