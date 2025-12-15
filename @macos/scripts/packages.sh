packages=(
    bat       #  https://github.com/sharkdp/bat
    bandwhich #  https://github.com/imsnif/bandwhich
    cmake
    coreutils # GNU core utilities
    ctags
    curl
    direnv
    duti    #  https://github.com/moretension/duti
    espanso #  https://github.com/federico-terzi/espanso
    eza     #  https://github.com/eza-community/eza
    fzf     #  https://github.com/junegunn/fzf
    fd      #  https://github.com/sharkdp/fd
    gettext
    gh
    gnupg
    gzip
    htop
    imagemagick
    jq
    libpq
    macpass #  https://macpassapp.org/
    mas
    micromamba
    ncdu
    nedit
    node
    nvm
    openjdk
    openssh
    openssl
    pandoc
    pigz
    postgresql
    python3
    protobuf
    ripgrep #  https://github.com/BurntSushi/ripgrep
    shellcheck
    stow
    svn
    tealdeer #  https://github.com/dbrgn/tealdeer
    the_silver_searcher
    tmux
    tree
    usbutils
    util-linux
    wakeonlan
    wget
    yubico-piv-tool
    yubikey-agent
    ykman
    zoxide
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
)

install_packages() {
    info "Installing packages..."
    install_brew_formulas "${packages[@]}"

    info "Cleaning up brew packages..."
    brew cleanup
}
