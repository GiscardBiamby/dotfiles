#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"

echo "🐍 Installing mamba"

PREFIX="${HOME}/miniforge3"
DL_DIR="${SCRIPT_DIR}/downloads/mamba"
INSTALLER="${DL_DIR}/Miniforge3-$(uname)-$(uname -m).sh"

# https://github.com/conda-forge/miniforge#mambaforge
# * Latest installers with Mamba in the base environment:
mkdir -p "${DL_DIR}"
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" -O "${INSTALLER}"
chmod +x "${INSTALLER}"

# * Install/update Miniforge:
# * Miniforge3-<OS>-<ARCH>.sh Options:
# *     -b           run install in batch mode (without manual intervention),
# *                  it is expected the license terms (if any) are agreed upon
# *     -f           no error if install prefix already exists
# *     -h           print this help message and exit
# *     -p PREFIX    install prefix, defaults to $PREFIX, must not contain spaces.
# *     -s           skip running pre/post-link/install scripts
# *     -u           update an existing installation
# *     -t           run package tests after installation (may install conda-build)
bash "${SCRIPT_DIR}/downloads/mamba/Miniforge3-$(uname)-$(uname -m).sh" -b -u -p "${PREFIX}"

# * Use the binaries directly (no need to source conda.sh or .zshrc)
MAMBA_BIN="${PREFIX}/bin/mamba"
CONDA_BIN="${PREFIX}/bin/conda"

# * Sanity checks
if [[ ! -x "${MAMBA_BIN}" ]]; then
    echo "ERROR: mamba binary not found at ${MAMBA_BIN}" >&2
    exit 1
fi
if [[ ! -x "${CONDA_BIN}" ]]; then
    echo "ERROR: conda binary not found at ${CONDA_BIN}" >&2
    exit 1
fi

# * Optional: ensure base env is current
"${CONDA_BIN}" update -n base -c conda-forge conda mamba -y

# * Completions (bash-side)
# These packages are optional; keep them if you want the bash completions you referenced
"${MAMBA_BIN}" install -c tartansandal conda-bash-completion mamba-bash-completion -y || true

# * Conda config
# https://docs.conda.io/projects/conda/en/latest/user-guide/configuration/pip-interoperability.html:
"${CONDA_BIN}" config --set prefix_data_interoperability true
"${CONDA_BIN}" config --set auto_activate false
"${MAMBA_BIN}" config --set pip_interop_enabled true
"${MAMBA_BIN}" config --set auto_activate_base false

echo "✅ Mamba installed at ${PREFIX} and configured."