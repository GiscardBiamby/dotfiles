#!/bin/bash

. util.sh

echo "Installing keepassxc"
sudo add-apt-repository ppa:phoerious/keepassxc -y
sudo apt update
install keepassxc
