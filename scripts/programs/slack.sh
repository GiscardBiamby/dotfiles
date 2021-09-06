#!/bin/bash

echo "💬 Install Slack"
# sudo snap install slack --classic
wget https://downloads.slack-edge.com/releases/linux/4.19.2/prod/x64/slack-desktop-4.19.2-amd64.deb
dpkg -i slack-desktop*.deb
sudo apt-get update
sudo apt-get upgrade slack-desktop
