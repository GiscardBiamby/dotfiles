#!/bin/bash

echo "🐋 Installing Docker"
sudo apt update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Create a user so you don't have to sudo for every docker command:
# https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# Test:
docker run hello-world

# Services:
sudo systemctl --now enable docker
# Enable docker service on bootup:
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
