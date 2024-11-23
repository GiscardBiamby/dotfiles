#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"
set +e

echo "🐋 Installing Docker"
sudo apt update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Create a user so you don't have to sudo for every docker command:
# https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
#
# Note: seems like yuo may need to logout and/or reboot to have the group settings take effect
sudo groupadd docker
sudo usermod -aG docker $USER
# newgrp docker

# Test:
docker run hello-world

# Services:
sudo systemctl --now enable docker
# Enable docker service on bootup:
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
