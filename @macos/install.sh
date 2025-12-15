#!/usr/bin/env bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail

# shellcheck disable=SC1091
. "${SCRIPT_DIR}/scripts/utils.sh"
. "${SCRIPT_DIR}/scripts/brew.sh"
. "${SCRIPT_DIR}/scripts/apps.sh"
. "${SCRIPT_DIR}/scripts/cli.sh"
. "${SCRIPT_DIR}/scripts/config.sh"
. "${SCRIPT_DIR}/scripts/osx.sh"
. "${SCRIPT_DIR}/scripts/fonts.sh"
. "${SCRIPT_DIR}/scripts/packages.sh"
. "${SCRIPT_DIR}/scripts/oh-my-zsh.sh"

cleanup() {
    echo "Finishing..."
}

wait_input() {
    read -p "Press enter to continue: "
}

trap cleanup EXIT

main() {
    info "Installing ..."

    info "======= Homebrew packages ======="
    # wait_input
    install_packages
    success "Finished installing Homebrew packages"

    info "======= Homebrew Fonts ======="
    # wait_input
    install_fonts
    success "Finished installing fonts"

    info "======= Oh-my-zsh ======="
    # wait_input
    install_oh_my_zsh
    success "Finished installing Oh-my-zsh"

    info "======= MacOS Apps ======="
    # wait_input
    install_macos_apps

    install_masApps
    success "Finished installing macOS apps"

    info "======= NeoVim ======="
    # wait_input
    install_neovim
    success "Finished installing neovim"

    #info "======= PiP modules ======="
    #wait_input
    #install_python_packages
    #success "Finished installing python packages"

    info "======= Configuration ======="
    wait_input
    # setup_osx
    # success "Finished configuring MacOS defaults. NOTE: A restart is needed"
    code_as_default_text_editor
    success "Finished setting up VSCode as default text editor"
    stow_dotfiles

    info "Creating development folders"
    mkdir -p ~/proj

    success "Finished stowing dotfiles"

    info "======= SSH Key ======="
    setup_github_ssh
    success "Finished setting up SSH Key"

    info "======= NeoVim Plugins ======="
    wait_input
    nvim +PlugInstall +qall
    success "Finished installing nvim plugins"

    #if ! hash rustc &>/dev/null; then
    #  info "======= Rust Setup ======="
    #  wait_input
    #  rustup-init
    #fi

    success "Done"

    info "System needs to restart. Restart?"

    select yn in "y" "n"; do
        case $yn in
            y)
                sudo shutdown -r now
                break
                ;;
            n) exit ;;
        esac
    done
}

main
