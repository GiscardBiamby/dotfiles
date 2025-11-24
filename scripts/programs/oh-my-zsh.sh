#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"

echo "Installing Oh-my-zsh"

if [[ ! -f ~/.oh-my-zsh/oh-my-zsh.sh ]]; then
    info "Installing oh my zsh..."
    ZSH=~/.oh-my-zsh ZSH_DISABLE_COMPFIX=true sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -s --batch --unattended

    chmod 744 ~/.oh-my-zsh/oh-my-zsh.sh
else
    warn "oh-my-zsh already installed"
fi

# Install zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
git clone https://github.com/esc/conda-zsh-completion.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/conda-zsh-completion"
git clone https://github.com/clavelm/yt-dlp-omz-plugin.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/yt-dlp"
git clone https://github.com/fdellwing/zsh-bat.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-bat"
git clone https://github.com/Aloxaf/fzf-tab "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab"
