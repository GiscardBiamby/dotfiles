#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJ_ROOT="${SCRIPT_DIR}/../"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
source "${SCRIPT_DIR}/util.sh"

pushd "${SCRIPT_DIR}"
python backup_dotfiles.py
popd

pushd "${PROJ_ROOT}/stow_packages"
stow --target="${HOME}" ag
stow --target="${HOME}" bash
stow --target="${HOME}" conda
stow --target="${HOME}" direnv
stow --target="${HOME}" git
stow --target="${HOME}" kitty
stow --target="${HOME}" tmux
stow --target="${HOME}" vim
stow --target="${HOME}" zsh_linux
popd

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

pushd "${PROJ_ROOT}/stow_packages/vim"
stow --target="${HOME}/.vim" .vim
popd
