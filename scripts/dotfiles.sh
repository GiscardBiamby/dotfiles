#!/bin/bash

. util.sh

python backup_dotfiles.py

pushd ../stow_packages
stow --target="${HOME}" bash
stow --target="${HOME}" conda
stow --target="${HOME}" direnv
stow --target="${HOME}" git
popd