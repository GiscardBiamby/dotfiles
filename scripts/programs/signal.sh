#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"

echo "🗨 Installing Signal"

# NOTE: These instructions only work for 64 bit Debian-based
# Linux distributions such as Ubuntu, Mint etc.

# 1. Install our official public software signing key
# * --- Keyring (idempotent) ---
echo "keyring"
# Keyring (non-interactive, idempotent)
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://updates.signal.org/desktop/apt/keys.asc -o /tmp/signal.asc
sudo gpg --dearmor --batch --yes -o /usr/share/keyrings/signal-desktop-keyring.gpg /tmp/signal.asc
sudo chmod a+r /usr/share/keyrings/signal-desktop-keyring.gpg
rm -f /tmp/signal.gpg.asc


# 2. Add our repository to your list of repositories
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main" \
    | sudo tee /etc/apt/sources.list.d/signal-desktop.list >/dev/null


# 3. Update your package database and install signal
sudo apt update -y | true && sudo apt install -y signal-desktop





