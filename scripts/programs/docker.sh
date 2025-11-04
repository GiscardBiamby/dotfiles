#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"
set +e

echo "🐋 Installing Docker"

# * --- NEW: choose a supported vendor codename (override with DOCKER_VENDOR_CODENAME) ---
DOCKER_VENDOR_CODENAME="${DOCKER_VENDOR_CODENAME:-questing}"
ARCH="$(dpkg --print-architecture)"

sudo apt update || true
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# * --- Keyring (idempotent) ---
echo "keyring"
# Keyring (non-interactive, idempotent)
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /tmp/docker.gpg.asc
sudo gpg --dearmor --batch --yes -o /etc/apt/keyrings/docker.gpg /tmp/docker.gpg.asc
sudo chmod a+r /etc/apt/keyrings/docker.gpg
rm -f /tmp/docker.gpg.asc

# * --- NEW: remove/disable conflicting old Docker sources (idempotent & specific) ---
echo "remove/disable conflicting old Docker sources "
# These filenames showed up in your logs; remove them if present.
sudo rm -f /etc/apt/sources.list.d/archive_uri-https_download_docker_com_linux_ubuntu-*.list \
            /etc/apt/sources.list.d/archive_uri-https_download_docker_com_linux_ubuntu-*.sources
# Also neutralize any stray docker entries that might linger in other files.
if ls /etc/apt/sources.list.d/*docker* >/dev/null 2>&1; then
    for f in /etc/apt/sources.list.d/*docker*; do
        # Keep our canonical file (below) clean; comment others.
        if [ "$f" != "/etc/apt/sources.list.d/docker.list" ]; then
            sudo sed -i 's/^\s*deb /# deb /' "$f" || true
            sudo sed -i 's/^\s*Types:/# Types:/' "$f" || true
        fi
    done
fi

# * --- Repo line: write exactly once, idempotently (no multi-line quoting issues) ---
echo "Adding apt repo"
echo "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${DOCKER_VENDOR_CODENAME} stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

# Update only what we need; don't let other broken repos fail the run
sudo apt-get update || true

# * --- Install Docker Engine (idempotent) ---
# On first run this installs; on subsequent runs it confirms up-to-date.
echo "Installing docker"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io || {
    echo "⚠️  Docker packages not found yet. Double-check the repo line and codename: ${DOCKER_VENDOR_CODENAME}"
    echo "    You can override with: DOCKER_VENDOR_CODENAME=jammy ./programs/docker.sh"
    exit 1
}

# *--- Group setup (idempotent) ---
if ! getent group docker >/dev/null 2>&1; then
    sudo groupadd docker
fi
# Add current user if not already in group
if ! id -nG "$USER" | grep -qw docker; then
    sudo usermod -aG docker "$USER"
    ADDED_TO_GROUP=1
fi

# Enable & start services (idempotent)
if systemctl list-unit-files | grep -q '^docker\.service'; then
    sudo systemctl enable --now docker || true
fi
if systemctl list-unit-files | grep -q '^containerd\.service'; then
    sudo systemctl enable containerd || true
fi

# Choose docker command based on current session's group membership
DOCKER_CMD="docker"
if ! id -nG "$USER" | grep -qw docker; then
    DOCKER_CMD="sudo docker"
    JUST_ADDED_NOTE=1
fi

# Smoke test (don’t fail the script if the sample image pull/run fails)
$DOCKER_CMD info >/dev/null 2>&1 && $DOCKER_CMD run --rm hello-world || true

# Friendly hint if we just added the user (group isn’t active in this shell)
if [ "${JUST_ADDED_NOTE:-0}" = "1" ]; then
    echo "ℹ️  You're not in the active 'docker' group yet. Run 'newgrp docker' or log out/in."
fi

# Friendly note about new group taking effect
if [ "${ADDED_TO_GROUP:-0}" = "1" ]; then
    echo "ℹ️  You were added to the 'docker' group. Log out/in or run 'newgrp docker' for it to take effect."
fi
