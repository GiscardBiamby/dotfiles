#!/bin/bash

. util.sh

echo "Installing Zotero"

# Installation based on this repo: https://github.com/retorquere/zotero-deb
wget -qO- https://github.com/retorquere/zotero-deb/releases/download/apt-get/install.sh | sudo bash
sudo apt update
sudo apt install -y libreoffice-java-common zotero
