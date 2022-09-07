#!/bin/bash

# Firefox browser
echo "🦊 Installing SublimeText"
curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add
sudo add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"

## Install
sudo apt update
sudo apt install -y sublime-text
