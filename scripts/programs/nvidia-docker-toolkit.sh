#!/bin/bash

echo "🐋 Installing NVIDIA Container Toolkit"
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker

# On nvidia-container-toolkit nvidia-container-runtime vs nvidia-docker2, this is crazy:
# https://github.com/NVIDIA/nvidia-docker/issues/1268

# Setup the stable repository and the GPG key:
distribution=$(
    . /etc/os-release
    echo $ID$VERSION_ID
) &&
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg &&
    curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list |
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' |
        sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# install nvidia-docker2
sudo apt-get update
# sudo apt-get install -y nvidia-container-toolkit nvidia-container-runtime
sudo apt-get install -y nvidia-docker2

# Restart docker daemon:
sudo systemctl daemon-reload
sudo systemctl restart docker

# A working setup can be tested by running a base CUDA container:
echo "If the install worked, you should see nvidia-smi output:"
# sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
sudo docker run --rm --gpus all nvidia/cuda:10.2-base nvidia-smi
