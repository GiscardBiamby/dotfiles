#!/bin/bash

echo "Installing Chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb

# During the installation process, the official Google repository will be added to your
# system. You can use the cat command to verify the file contents:
cat /etc/apt/sources.list.d/google-chrome.list

rm ./google-chrome-stable_current_amd64.deb
