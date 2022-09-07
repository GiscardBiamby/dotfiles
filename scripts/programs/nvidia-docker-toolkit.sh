#!/bin/bash

echo "🐋 Installing NVIDIA Container Toolkit"
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker

# Setup the stable repository and the GPG key:
distribution=$(
    . /etc/os-release
    echo $ID$VERSION_ID
)
echo "distribution: ${distribution}"
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

# install nvidia-docker2
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit nvidia-container-runtime

# Restart docker daemon:
sudo systemctl daemon-reload
sudo systemctl restart docker

# A working setup can be tested by running a base CUDA container:
echo "If the install worked, you should see nvidia-smi output:"
# sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
sudo docker run --rm --gpus all nvidia/cuda:10.2-base nvidia-smi
