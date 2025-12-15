code_as_default_text_editor() {
    info "Setting up VSCode as default editor for common extensions"
    local extensions=(
        ".c"
        ".cpp"
        ".js"
        ".jsx"
        ".ts"
        ".tsx"
        ".json"
        ".md"
        ".sql"
        ".css"
        ".scss"
        ".sass"
        ".py"
        ".sum"
        ".rs"
        ".go"
        ".sh"
        ".log"
        ".toml"
        ".yml"
        ".yaml"
        "public.plain-text"
        "public.unix-executable"
        "public.data"
    )

    for ext in "${extensions[@]}"; do
        duti -s com.microsoft.VSCode $ext all
    done
}

setup_github_ssh() {
    ssh-keygen -t ed25519 -C "COMMENT"

    info "Adding ssh key to keychain"
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519

    info "Remember add ssh key to github account 'pbcopy < ~/.ssh/id_ed25519.pub'"
}

stow_dotfiles() {
    local files=(
        ".DS_Store"
        ".aliases"
        ".condarc"
        ".gitconfig"
        ".profile*"
        ".vimrc"
        ".zshrc"
        ".zprofile"
    )
    local folders=(
        ".config/espanso"
        ".config/fd"
        ".config/kitty"
        ".config/nvim"
        ".config/ripgrep"
        ".git-templates/hooks"
        # ".ssh"
    )
    info "Removing existing config files"
    for f in "${files[@]}"; do
        rm -f "$HOME/$f" || true
    done

    # Create the folders to avoid symlinking folders
    for d in "${folders[@]}"; do
        rm -rf "${HOME:?}/$d" || true
        mkdir -p "$HOME/$d"
    done

    # pushd stow_packages
    # local dotfiles="ag bash conda direnv espanso fd git kitty nvim ripgrep ssh tmux vim zsh"
    info "Stowing: dotfiles"
    for pkg_name in ag bash conda direnv espanso fd git nvim omz ripgrep tmux vim zsh; do
        # Add `-n` flag for dry run:
        stow -d ./stow_packages -S --verbose 1 --target $HOME "${pkg_name}"
    done
    # popd
}
