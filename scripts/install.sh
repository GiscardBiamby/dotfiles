#!/bin/bash

. util.sh

WORKSTATION=""
if [[ "${1}" == "workstation" ]]; then
    WORKSTATION="workstation"
    echo "Installing for WORKSTATION!"
fi

# Update Ubuntu and get standard repository programs
sudo apt update && sudo apt full-upgrade -y

# git
add-apt-repository ppa:git-core/ppa
sudo apt update
install git

# Common
install curl
install gnupg
install gzip
install htop
install nmap
install silversearcher-ag
install pigz
install tmux
install tree
install unzip
install wget
install xclip

# Image processing
install jpegoptim
install optipng

# Fun stuff
install figlet
install lolcat

# Programs
if [[ "${WORKSTATION}" == "workstation" ]]; then
    # Run all scripts in programs/
    for f in programs/*.sh; do bash "$f" -H; done
else
    bash ./programs/anaconda.sh -H
    bash ./programs/direnv.sh -H
fi

bash ./dotfiles.sh -H

# Get all upgrades
sudo apt upgrade -y
sudo apt autoremove -y

# Fun hello
figlet "Hello!" | lolcat
