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
stow --target="${HOME}" zsh_linux
popd

# Manage vscode settings and keybindings if vscode is installed:
pushd ../.config/Code
if [[ -d "${HOME}/.config/Code/User" ]]; then
    stow --target="${HOME}/.config/Code/User" User
fi
popd

pushd ../.config
if [[ -d "${HOME}/.config/Code" ]]; then
    stow --target="${HOME}/.config/Code" Code
fi
popd

pushd ../.local/share
if [[ -d "${HOME}/.local/share/jupyter" ]]; then
    stow --target="${HOME}/.local/share/jupyter" jupyter
fi
popd

pushd ../.jupyter
if [[ -d "${HOME}/.jupyter" ]]; then
    stow --target="${HOME}/.jupyter/nbconfig" nbconfig
fi
popd
