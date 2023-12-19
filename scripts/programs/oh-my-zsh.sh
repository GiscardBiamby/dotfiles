#!/bin/bash

. ../util.sh

echo "Installing Oh-my-zsh"

if [[ ! -f ~/.oh-my-zsh/oh-my-zsh.sh ]]; then
    info "Installing oh my zsh..."
    ZSH=~/.oh-my-zsh ZSH_DISABLE_COMPFIX=true sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    chmod 744 ~/.oh-my-zsh/oh-my-zsh.sh
else
    warn "oh-my-zsh already installed"
fi

# Install zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/esc/conda-zsh-completion.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/conda-zsh-completion
