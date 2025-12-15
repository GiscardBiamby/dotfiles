# Cask apps:
apps=(
    anki
    cursor
    docker
    dropbox
    firefox
    google-chrome
    iterm2
    keepassxc
    mactex
    obs
    rectangle
    signal
    slack
    sublime-text
    texstudio
    typora
    veracrypt
    visual-studio-code
    vlc
    zotero
)

# Apple Store apps:
# masApps=(
#   "937984704"   # Amphetamine
#   "1444383602"  # Good Notes 5
#   #"768053424"   # Gappling (svg viewer)
# )

install_macos_apps() {
    info "Installing macOS apps..."
    install_brew_casks "${apps[@]}"
}

install_masApps() {
    info "App Store Apps Install disabled. Skipping this step"
    #info "Installing App Store apps..."
    #for app in "${masApps[@]}"; do
    #  mas install $app
    #done
}

install_mamba() {

    info "Configuring conda..."
    # https://docs.conda.io/projects/conda/en/latest/user-guide/configuration/pip-interoperability.html:
    conda config --set pip_interop_enabled True
    conda config --set auto_activate_base False

    # Not sure if the channel is required. It could be that it didn't work when i tried without the
    # channel because I forgot to restart the terminal (I sourced ~/.bash_profile instead):
    # mamba install -c tartansandal conda-bash-completion
    # mamba install -c tartansandal mamba-bash-completion
}
