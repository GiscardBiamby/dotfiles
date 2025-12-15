install_oh_my_zsh() {
    if [[ ! -f ~/.oh-my-zsh/oh-my-zsh.sh ]]; then
        info "Installing oh my zsh..."
        ZSH=~/.oh-my-zsh ZSH_DISABLE_COMPFIX=true sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -s --batch --unattended

        chmod 744 ~/.oh-my-zsh/oh-my-zsh.sh
    else
        warn "oh-my-zsh already installed"
    fi

    # Install zsh plugins
    pushd "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/"
    if [[ ! -d zsh-autosuggestions ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions zsh-autosuggestions
    fi
    if [[ ! -d zsh-syntax-highlighting ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git zsh-syntax-highlighting
    fi
    if [[ ! -d conda-zsh-completion ]]; then
        git clone https://github.com/esc/conda-zsh-completion.git conda-zsh-completion
    fi
    if [[ ! -d yt-dlp ]]; then
        git clone https://github.com/clavelm/yt-dlp-omz-plugin.git yt-dlp
    fi
    if [[ ! -d zsh-bat ]]; then
        git clone https://github.com/fdellwing/zsh-bat.git zsh-bat
    fi
    if [[ ! -d fzf-tab ]]; then
        git clone https://github.com/Aloxaf/fzf-tab fzf-tab
    fi
    popd
}
