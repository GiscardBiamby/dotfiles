#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
PROJ_ROOT="${SCRIPT_DIR}/../../.."
VIM_DIR="${PROJ_ROOT}/stow_packages/vim"
PACK_DIR="${VIM_DIR}/.vim/pack"
source "${SCRIPT_DIR}/../util.sh"

pushd "${PROJ_ROOT}"
mkdir -p "${PACK_DIR}"
ls -lah "${PACK_DIR}"

## https://www.reddit.com/r/dotfiles/comments/qgfpzz/let_your_dotfiles_project_be_your_vim_package/

# Keep this PACK_CLONE_DIR as a relative path so the git submodule works on any machine/user:
DOT_VIM_CLONE_DIR="stow_packages/vim/.vim"
if [[ ! -d "${DOT_VIM_CLONE_DIR}/pack/plugins/start/fzf.vim" ]]; then
    git submodule add --depth 1 https://github.com/junegunn/fzf.vim "${DOT_VIM_CLONE_DIR}/pack/plugins/start/fzf.vim"
fi
if [[ ! -d "${DOT_VIM_CLONE_DIR}/pack/plugins/start/vim-airline" ]]; then
    git submodule add --depth 1 https://github.com/vim-airline/vim-airline "${DOT_VIM_CLONE_DIR}/pack/plugins/start/vim-airline"
fi
if [[ ! -d "${DOT_VIM_CLONE_DIR}/pack/plugins/start/nerdtree" ]]; then
    git submodule add --depth 1 https://github.com/scrooloose/nerdtree "${DOT_VIM_CLONE_DIR}/pack/plugins/start/nerdtree"
fi
if [[ ! -d "${DOT_VIM_CLONE_DIR}/pack/plugins/start/vim-surround" ]]; then
    git submodule add --depth 1 https://github.com/tpope/vim-surround "${DOT_VIM_CLONE_DIR}/pack/plugins/start/vim-surround"
fi
if [[ ! -d "${DOT_VIM_CLONE_DIR}/pack/plugins/start/vim-smooth-scroll" ]]; then
    git submodule add --depth 1 https://github.com/terryma/vim-smooth-scroll "${DOT_VIM_CLONE_DIR}/pack/plugins/start/vim-smooth-scroll"
fi
if [[ ! -d "${DOT_VIM_CLONE_DIR}/pack/plugins/start/vim-cool" ]]; then
    git submodule add --depth 1 https://github.com/romainl/vim-cool "${DOT_VIM_CLONE_DIR}/pack/plugins/start/vim-cool"
fi
if [[ ! -d "${DOT_VIM_CLONE_DIR}/pack/plugins/start/vim-eunuch" ]]; then
    git submodule add --depth 1 https://github.com/tpope/vim-eunuch "${DOT_VIM_CLONE_DIR}/pack/plugins/start/vim-eunuch"
fi
# if [[ ! -d "${DOT_VIM_CLONE_DIR}/pack/plugins/start/PLUGIN_NAME" ]]; then
#     git submodule add --depth 1 https://github.com/ "${DOT_VIM_CLONE_DIR}/pack/plugins/start/PLUGIN_NAME"
# fi

## Colors
if [[ ! -d "${DOT_VIM_CLONE_DIR}/pack/colors/start/gruvbox" ]]; then
    git submodule add --depth 1 https://github.com/gruvbox-community/gruvbox "${DOT_VIM_CLONE_DIR}/pack/colors/start/gruvbox"
fi
if [[ ! -d "${DOT_VIM_CLONE_DIR}/pack/colors/start/vim-devicons" ]]; then
    git submodule add --depth 1 https://github.com/ryanoasis/vim-devicons "${DOT_VIM_CLONE_DIR}/pack/colors/start/vim-devicons"
fi
if [[ ! -d "${DOT_VIM_CLONE_DIR}/pack/colors/start/rainbow_parentheses.vim" ]]; then
    git submodule add --depth 1 https://github.com/junegunn/rainbow_parentheses.vim "${DOT_VIM_CLONE_DIR}/pack/colors/start/rainbow_parentheses.vim"
fi

# if [[ ! -d "${DOT_VIM_CLONE_DIR}/pack/colors/start/PLUGIN_NAME" ]]; then
#     git submodule add --depth 1 https://github.com/ "${DOT_VIM_CLONE_DIR}/pack/colors/start/PLUGIN_NAME"
# fi


## Syntax
if [[ ! -d "${DOT_VIM_CLONE_DIR}/pack/syntax/start/vim-indent-guides" ]]; then
    git submodule add --depth 1 https://github.com/preservim/vim-indent-guides "${DOT_VIM_CLONE_DIR}/pack/syntax/start/vim-indent-guides"
fi
# if [[ ! -d "${DOT_VIM_CLONE_DIR}/pack/syntax/start/PLUGIN_NAME" ]]; then
#     git submodule add --depth 1 https://github.com/ "${DOT_VIM_CLONE_DIR}/pack/syntax/start/PLUGIN_NAME"
# fi

# # TO update the submodules:
# git submodule update --remote --merge

popd

# #To see a list of plugin versions you've installed
# git submodule | cut -c67-

# # Uninstall a submodule:
# plugin=vim-airline
# git submodule deinit -f ${PACK_DIR}/plugins/start/$plugin
# git rm -r               ${PACK_DIR}/plugins/start/$plugin
# rm -rf     .git/modules/.vim/pack/plugins/start/$plugin
# git add .gitmodules
# git commit -m "Removed $plugin"
# git push
