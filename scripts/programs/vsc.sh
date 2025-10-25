#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"

# https://code.visualstudio.com/docs/setup/linux
echo "⌨️  Installing VSCode"
pushd "${SCRIPT_DIR}/downloads"
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
popd
sudo apt install -y apt-transport-https
sudo apt update
sudo apt install -y code

# Debian and moving files to trash
#
# If you see an error when deleting files from the VS Code Explorer on the Debian operating system,
# it might be because the trash implementation that VS Code is using is not there.
sudo apt install gvfs libglib2.0-bin

## Not sure if I want this or not. gedit or whatever small default editor is nicer to open text files from
## the ubuntu file explorer:
# sudo update-alternatives --set editor /usr/bin/code


function install() {
    name="${1}"
    code --install-extension ${name} --force
}


install 2ndshift.fresh-material
install aaron-bond.better-comments
install akamud.vscode-theme-onedark
install bauke.horizon-vscode
install benjaminbenais.copilot-theme
install betwo.vscode-linux-binary-preview
install charliermarsh.ruff
install christian-kohler.path-intellisense
install codezombiech.gitignore
install danielnichols.slurm-dashboard
install davidanson.vscode-markdownlint
install daylerees.rainglow
install dcasella.monokai-plusplus
install donjayamanne.githistory
install dracula-theme.theme-dracula
install dunstontc.vscode-docker-syntax
install dunstontc.vscode-gitignore-syntax
install earthslurm.stql
install editorconfig.editorconfig
install eliverlara.andromeda
install equinusocio.vsc-material-theme
install equinusocio.vsc-material-theme-icons
install esbenp.prettier-vscode
install euskadi31.json-pretty-printer
install foxundermoon.shell-format
install george-alisson.html-preview-vscode
install gruntfuggly.todo-tree
install guyskk.language-cython
install hedinne.popping-and-locking-vscode
install idleberg.subway-dark
install itsmelion.laserkai
install james-yu.latex-workshop
install jaredkent.laserwave
install jeffersonlicet.snipped
install johnpapa.vscode-peacock
install johnygeorges.jetjet-theme
install juupje.slurmassist
install kriegalex.vscode-cudacpp
install kuscamara.electron
install lamborghinious.auto-scroll
install marnix.tokyo-night-pro
install mathematic.vscode-latex
install mechatroner.rainbow-csv
install mervin.markdown-formatter
install mgesbert.python-path
install mhutchie.git-graph
install mikestead.dotenv
install mohsen1.prettify-json
install mousavian.ssh-config-syntax-highlighter
install mr-ubik.hackerman-syntax
install ms-azuretools.vscode-docker
install ms-python.black-formatter
install ms-python.debugpy
install ms-python.flake8
install ms-python.isort
install ms-python.mypy-type-checker
install ms-python.pylint
install ms-python.python
install ms-python.vscode-pylance
install ms-toolsai.jupyter
install ms-toolsai.jupyter-keymap
install ms-toolsai.jupyter-renderers
install ms-toolsai.vscode-jupyter-cell-tags
install ms-toolsai.vscode-jupyter-slideshow
install ms-vscode-remote.remote-containers
install ms-vscode-remote.remote-ssh
install ms-vscode-remote.remote-ssh-edit
install ms-vscode-remote.remote-wsl
install ms-vscode-remote.vscode-remote-extensionpack
install ms-vscode.cpptools
install ms-vscode.cpptools-themes
install ms-vscode.remote-explorer
install ms-vscode.remote-server
install ms-vscode.theme-tomorrowkit
install ms-vscode.wordcount
install ms-vsliveshare.vsliveshare
install natqe.reload
install njpwerner.autodocstring
install nvidia.nsight-vscode-edition
install oderwat.indent-rainbow
install origamid.origamid-theme
install p1c2u.docker-compose
install philsinatra.popping-and-locking-vscode-black
install pkief.material-icon-theme
install quilicicf.markdown-spec-formatter
install redhat.vscode-xml
install redhat.vscode-yaml
install richie5um2.vscode-sort-json
install ryu1kn.partial-diff
install sabertazimi.latex-snippets
install sallar.vscode-duotone-dark
install sebastian-lay.auto-reload
install shardulm94.trailing-spaces
install shd101wyy.markdown-preview-enhanced
install sissel.shopify-liquid
install spikespaz.vscode-smoothtype
install stkb.rewrap
install streetsidesoftware.code-spell-checker
install takumii.markdowntable
install tamasfe.even-better-toml
install technosophos.vscode-make
install timonwong.shellcheck
install tinaciousdesign.theme-tinaciousdesign
install tinkertrain.theme-panda
install tommorris.mako
install tomoki1207.pdf
install tyriar.sort-lines
install vikas.code-navigation
install voidei.vscode-vimrc
install vscode-icons-team.vscode-icons
install woodywoodsta.vscode-material-syntax-dark
install xshrim.txt-syntax
install zaaack.markdown-editor
install ziyasal.vscode-open-in-github

