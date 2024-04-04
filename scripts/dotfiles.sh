#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJ_ROOT="${SCRIPT_DIR}/../"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
source "${SCRIPT_DIR}/util.sh"

pushd "${SCRIPT_DIR}"
python3 backup_dotfiles.py
popd

# Detect machine
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    MSYS_NT*)   machine=Git;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo "${machine}"

# Install stow packages
mkdir -p "${HOME}/.config"
pushd "${PROJ_ROOT}/stow_packages"
stow --target="${HOME}" ag
stow --target="${HOME}" bash
stow --target="${HOME}" chrome
stow --target="${HOME}" chromium
stow --target="${HOME}" conda
stow --target="${HOME}" direnv
stow --target="${HOME}" git
stow --target="${HOME}" omz
stow --target="${HOME}" ripgrep
stow --target="${HOME}" shellcheck
stow --target="${HOME}" tmux
stow --target="${HOME}" vim
stow --target="${HOME}" vscode
stow --target="${HOME}" zoom

if [[ "${machine}" == "Linux" ]]; then
    stow --target="${HOME}" kitty
    stow --target="${HOME}" zsh_linux

    hostname=$(hostname)
    echo "hostname: $hostname"
    if [[ $hostname == brb* ]]; then
        echo "STOWING brb specific files into /usr/..."
        sudo stow --target="/usr/share" usr_share --adopt
        sudo stow --target="/usr/local" usr_local --adopt
        sudo desktop-file-install /usr/share/applications/code.desktop
        sudo desktop-file-install /usr/share/applications/code-url-handler.desktop
    fi
fi
if [[ "${machine}" == "Mac" ]]; then
    stow --target="${HOME}" zsh
fi


popd


pushd "${PROJ_ROOT}/.local/share"
if [[ -d "${HOME}/.local/share/jupyter" ]]; then
    stow --target="${HOME}/.local/share/jupyter" jupyter
fi
popd

pushd "${PROJ_ROOT}/.jupyter"
if [[ -d "${HOME}/.jupyter" ]]; then
    stow --target="${HOME}/.jupyter/nbconfig" nbconfig
fi
popd

# pushd "${PROJ_ROOT}/stow_packages/vim"
# stow --target="${HOME}/.vim" .vim
# popd
