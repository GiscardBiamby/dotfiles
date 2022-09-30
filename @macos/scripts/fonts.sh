fonts=(
    font-caskaydia-cove-nerd-font
    font-consolas-for-powerline
    font-fira-code-nerd-font
    font-fira-code
    font-meslo-lg-nerd-font
    font-hack-nerd-font
    font-source-code-pro
    font-jetbrains-mono
)

install_fonts() {
    info "Installing fonts..."
    brew tap homebrew/cask-fonts
    install_brew_casks "${fonts[@]}"
}
