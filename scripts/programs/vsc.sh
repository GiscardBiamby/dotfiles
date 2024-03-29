#!/bin/bash

# https://code.visualstudio.com/docs/setup/linux
echo "⌨️  Installing VSCode"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt install -y apt-transport-https
sudo apt update
sudo apt install -y code
rm microsoft.gpg
function install() {
    name="${1}"
    code --install-extension ${name} --force
}
install 2ndshift.fresh-material
install aaron-bond.better-comments
install AffenWiesel.matlab-formatter
install ban.spellright
install batisteo.vscode-django
install betwo.vscode-linux-binary-preview
install tamasfe.even-better-toml
install christian-kohler.path-intellisense
install clarkyu.vscode-sql-beautify
install codezombiech.gitignore
install DavidAnson.vscode-markdownlint
install dcasella.monokai-plusplus
install donjayamanne.githistory
install dunstontc.vscode-docker-syntax
install EditorConfig.EditorConfig
install Equinusocio.vsc-material-theme
install equinusocio.vsc-material-theme-icons
install esbenp.prettier-vscode
install foxundermoon.shell-format
install Gimly81.matlab
install GitHub.vscode-pull-request-github
install Gruntfuggly.todo-tree
install guyskk.language-cython
install hedinne.popping-and-locking-vscode
install idleberg.subway-dark
install jaredkent.laserwave
install jeffersonlicet.snipped
install johnpapa.vscode-peacock
install JohnyGeorges.jetjet-theme
install jolaleye.horizon-theme-vscode
install kriegalex.vscode-cudacpp
install kuscamara.electron
install mechatroner.rainbow-csv
install mgesbert.python-path
install mhutchie.git-graph
install mikestead.dotenv
install mohsen1.prettify-json
install mr-ubik.hackerman-syntax
install ms-azuretools.vscode-docker
install ms-python.python
install ms-python.vscode-pylance
install ms-toolsai.jupyter
install ms-vscode-remote.remote-containers
install ms-vscode-remote.remote-ssh
install ms-vscode-remote.remote-ssh-edit
install ms-vscode-remote.remote-wsl
install ms-vscode-remote.vscode-remote-extensionpack
install ms-vscode.cpptools
install ms-vscode.Theme-TomorrowKit
install ms-vsliveshare.vsliveshare
install ms-vsliveshare.vsliveshare-pack
install natqe.reload
install njpwerner.autodocstring
install oderwat.indent-rainbow
install origamid.origamid-theme
install p1c2u.docker-compose
install philsinatra.popping-and-locking-vscode-black
install PKief.material-icon-theme
install quilicicf.markdown-spec-formatter
install richie5um2.vscode-sort-json
install ryu1kn.partial-diff
install sabertazimi.latex-snippets
install sallar.vscode-duotone-dark
install shardulm94.trailing-spaces
install spikespaz.vscode-smoothtype
install stkb.rewrap
install streetsidesoftware.code-spell-checker
install stuart.unique-window-colors
install TakumiI.markdowntable
install tinaciousdesign.theme-tinaciousdesign
install tommorris.mako
install tomoki1207.pdf
install vikas.code-navigation
install vscode-icons-team.vscode-icons
install woodywoodsta.vscode-material-syntax-dark
install zaaack.markdown-editor

