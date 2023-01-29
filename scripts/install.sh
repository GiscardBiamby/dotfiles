#!/bin/bash

. util.sh

WORKSTATION=""
if [[ "${1}" == "workstation" ]]; then
    WORKSTATION="workstation"
    echo "Installing for WORKSTATION!"
fi

# Update Ubuntu and get standard repository programs
add-apt-repository ppa:git-core/ppa
sudo apt update && sudo apt update -y

# Common
install git
install curl
install "dconf*"
install ffmpeg
install gnupg
install gzip
install htop
install jq
install ncdu
install net-tools
install nmap
install silversearcher-ag
install pandoc
install pigz
install shellcheck
install stow
install texlive-xetex
install texlive-fonts-recommended
install texlive-plain-generic
install texlive-extra-utils
install texstudio
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
    for f in programs/*.sh; do bash "sudo $f" -H; done
    pip install gitup
else
    # For server, only install command line things:
    bash ./programs/mamba.sh -H
    bash ./programs/direnv.sh -H
    # bash ./programs/docker.sh -H
    # bash ./programs/nvidia-docker-toolkit.sh -H
    bash ./programs/nvm-npm-node-packages.sh -H
    pip install gitup
fi

# Use GNU stow to deploy all the doffiles:
bash ./dotfiles.sh -H

# Install diff-so-fancy
#
# Note: it seems like i still have to run this step manually for some reason, to get diff-so-fancy
# to work
source ~/.bash_profile
nvm use node
npm install -g diff-so-fancy

# Get all upgrades
sudo apt upgrade -y
sudo apt autoremove -y

# Fun hello
figlet "Hello!" | lolcat
