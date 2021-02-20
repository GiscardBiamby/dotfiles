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
install "dconf*"
install gnupg
install gzip
install htop
install nmap
install silversearcher-ag
install pigz
install stow
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

git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1


# Programs
if [[ "${WORKSTATION}" == "workstation" ]]; then
    # For workstation (meaning I want all command line + GUI apps), run all scripts in
    # ./scripts/programs/:
    for f in programs/*.sh; do bash "$f" -H; done
else
    # For server, only install command line things:
    bash ./programs/anaconda.sh -H
    bash ./programs/direnv.sh -H
    bash ./programs/docker.sh -H
    bash ./programs/nvidia-docker-toolkit.sh -H
    bash ./programs/nvm-npm-node-packages.sh -H
fi

# Use GNU stow to deploy all the doffiles:
bash ./dotfiles.sh -H

# Install diff-so-fancy
#
# Note: it seems like i still have to run this step manually for some reason, to get diff-so-fancy
# to work
source ~/.bashrc
nvm use node
npm install -g diff-so-fancy

# Get all upgrades
sudo apt upgrade -y
sudo apt autoremove -y

# Fun hello
figlet "Hello!" | lolcat
