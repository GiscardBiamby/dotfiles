#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/util.sh"

# Sync submodule URLs from .gitmodules to .git/config (safe to run always)
git submodule sync --recursive

# Ensure all submodules are initialized and checked out
git submodule update --init --recursive

# Update all git submodules recursively:
git submodule update --remote --merge --recursive

# Reset nested submodules to their recorded commits
pushd "${SCRIPT_DIR}/../stow_packages/tmux/.tmux/plugins/tpm"
git submodule update --init
popd

# Update tmux plugins using TPM:
echo "Updating tmux plugins..."

# Install/update tmux plugins non-interactively
tmux new -d 'sleep 0.1' \; send-keys C-b I
