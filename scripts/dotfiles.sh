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


pushd "${PROJ_ROOT}/stow_packages"
stow --target="${HOME}" ag
stow --target="${HOME}" bash
stow --target="${HOME}" conda
stow --target="${HOME}" direnv
stow --target="${HOME}" git
stow --target="${HOME}" shellcheck
stow --target="${HOME}" tmux
stow --target="${HOME}" vim
if [[ "${machine}" == "Linux" ]]; then
    stow --target="${HOME}" kitty
    stow --target="${HOME}" zsh_linux
fi
if [[ "${machine}" == "Mac" ]]; then
    stow --target="${HOME}" zsh
fi
popd

mkdir -p "${HOME}/.config"
stow -v --target="${HOME}/.config" --dir="${PROJ_ROOT}/stow_packages" chrome
stow -v --target="${HOME}/.oh-my-zsh" --dir="${PROJ_ROOT}/stow_packages" omz

# Manage vscode settings and keybindings if vscode is installed:
pushd "${PROJ_ROOT}/.config/Code"
if [[ -d "${HOME}/.config/Code/User" ]]; then
    stow --target="${HOME}/.config/Code/User" User
fi
popd

pushd "${PROJ_ROOT}/.config"
if [[ -d "${HOME}/.config/Code" ]]; then
    stow --target="${HOME}/.config/Code" Code
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
