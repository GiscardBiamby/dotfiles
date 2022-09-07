#!/bin/bash

. ../util.sh

echo "Installing Zotero"

# Installation based on this repo: https://github.com/retorquere/zotero-deb

# GB: commenting out on 2021-12-11, due the downloads from github being broken. see the PSA on the
# github repo (https://github.com/retorquere/zotero-deb): PSA: THE DOWNLOADS FROM GITHUB FOR THIS
# REPO ARE BROKEN. RE-RUN install.sh TO SWITCH TO THE SOURCEFORGE-HOSTED REPO
# wget -qO- https://github.com/retorquere/zotero-deb/releases/download/apt-get/install.sh | sudo bash
wget -qO- https://downloads.sourceforge.net/project/zotero-deb/install.sh | sudo bash

sudo apt update
sudo apt install -y libreoffice-java-common zotero
