#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/util.sh"

# Script to update all plugins for various tools (e.g., oh-my-zsh, tmux, vim, etc.)
# Run this script after pulling updates to dotfiles repo.

# Update all git submodules recursively:
git submodule update --remote --merge --recursive

# Update tmux plugins using TPM:
echo "Updating tmux plugins..."

# Install/update tmux plugins non-interactively
tmux new -d 'sleep 0.1' \; send-keys C-b I
