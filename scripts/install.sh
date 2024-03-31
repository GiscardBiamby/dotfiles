#!/bin/bash

. util.sh

WORKSTATION=""
if [[ "${1}" == "workstation" ]]; then
    WORKSTATION="workstation"
    echo "Installing for WORKSTATION!"
fi

# Update Ubuntu and get standard repository programs
sudo apt update -y

# git
add-apt-repository ppa:git-core/ppa
sudo apt update

# Common
install p7zip
install p7zip-rar
install git
install curl
install "dconf*"
install ffmpeg
install gnupg
install gzip
install htop
install jq
install libvirtiofsd
install ncdu
install net-tools
install nmap
install silversearcher-ag
install pandoc
install pigz
install python-is-python3
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
install wakeonlan
install wget
install xclip
install zsh


# Image processing
install jpegoptim
install optipng

# Fun stuff
install figlet
install lolcat

# TODO: Is this still needed now that we use zsh plugins?
git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1


# Programs
if [[ "${WORKSTATION}" == "workstation" ]]; then
    # Fix issue where if a security key is connected to the machine, Ubuntu login screens tries to
    # ask you for a smartcard instead of letting you pick a user:
    sudo -u gdm env -u XDG_RUNTIME_DIR \
        -u DISPLAY DCONF_PROFILE=gdm dbus-run-session \
        gsettings set org.gnome.login-screen enable-smartcard-authentication false

    # For workstation (meaning I want all command line + GUI apps), run all scripts in
    # ./scripts/programs/:
    for f in programs/*.sh; do bash "./$f" -H; done
    pip install gitup
else
    bash ./programs/oh-my-zsh.sh -H
    # For server, only install command line things:
    bash ./programs/mamba.sh -H
    bash ./programs/direnv.sh -H
    bash ./programs/vim.sh -H
    # bash ./programs/docker.sh -H
    # bash ./programs/nvidia-docker-toolkit.sh -H
    bash ./programs/nvm-npm-node-packages.sh -H
    pip install gitup
fi

# Pull submodules (e.g., used in vim/.vim/ for plugins):
git submodule update --init --recursive
# git submodule update --remote --merge
# # TO update the submodules(only one is needed, but what's the difference/which is better?):
# git submodule update --recursive --remote


# Use GNU stow to deploy all the dotfiles:
bash ./dotfiles.sh -H

# Install diff-so-fancy
#
# Note: it seems like i still have to run this step manually for some reason, to get diff-so-fancy
# to work
source ~/.bash_profile
nvm use node
npm install -g diff-so-fancy

# Get all upgrades
# sudo apt upgrade -y
# sudo apt autoremove -y

# Fun hello
figlet "Hello!" | lolcat
