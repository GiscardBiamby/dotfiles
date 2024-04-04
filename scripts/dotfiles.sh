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
stow --target="${HOME}" local
stow --target="${HOME}" jupyter --restow
stow --target="${HOME}" omz
stow --target="${HOME}" ripgrep
stow --target="${HOME}" shellcheck
stow --target="${HOME}" tmux
stow --target="${HOME}" vim
stow --target="${HOME}" vscode

stow --target="${HOME}" kitty
stow --target="${HOME}" zsh_linux

hostname=$(hostname)
echo "hostname: $hostname"



popd



# pushd "${PROJ_ROOT}/stow_packages/vim"
# stow --target="${HOME}/.vim" .vim
# popd
