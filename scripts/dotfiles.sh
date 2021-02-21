#!/bin/bash

. util.sh

python backup_dotfiles.py

pushd ../stow_packages
stow --target="${HOME}" bash
stow --target="${HOME}" conda
stow --target="${HOME}" direnv
stow --target="${HOME}" git
stow --target="${HOME}" tmux
popd

pushd ../.config/Code
stow --target="${HOME}/.config/Code/User" User
popd