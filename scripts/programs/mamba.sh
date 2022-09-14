#!/bin/bash

. ../util.sh

echo "🐍 Installing mamba"

# https://github.com/conda-forge/miniforge#mambaforge
# Latest installers with Mamba in the base environment:
mkdir -p ./programs/downloads/micromamba
wget -O "./programs/downloads/micromamba/Mambaforge-$(uname)-$(uname -m).sh" "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"
bash ./programs/downloads/micromamba/Mambaforge-$(uname)-$(uname -m).sh -y



# Not sure if the channel is required. It could be that it didn't work when i tried without the
# channel because I forgot to restart the terminal (I sourced ~/.bash_profile instead):
mamba install -c tartansandal conda-bash-completion
mamba install -c tartansandal mamba-bash-completion

# https://docs.conda.io/projects/conda/en/latest/user-guide/configuration/pip-interoperability.html:
conda config --set pip_interop_enabled True