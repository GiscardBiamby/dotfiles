#!/bin/bash

. ../util.sh

echo "🐍 Installing mamba"

# https://github.com/conda-forge/miniforge#mambaforge
# Latest installers with Mamba in the base environment:
mkdir -p ./programs/downloads/micromamba
wget -O "./programs/downloads/micromamba/Mambaforge-$(uname)-$(uname -m).sh" "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"
bash ./programs/downloads/micromamba/Mambaforge-$(uname)-$(uname -m).sh -y
