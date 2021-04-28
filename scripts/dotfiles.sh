#!/bin/bash

. util.sh

python backup_dotfiles.py

pushd ../stow_packages
stow --target="${HOME}" bash
stow --target="${HOME}" conda
stow --target="${HOME}" direnv
stow --target="${HOME}" git
stow --target="${HOME}" tmux
stow --target="${HOME}" ag
popd

# Manage vscode settings and keybindings if vscode is installed:
pushd ../.config/Code
if [[ -d "${HOME}/.config/Code/User" ]]; then
    stow --target="${HOME}/.config/Code/User" User
fi
popd
