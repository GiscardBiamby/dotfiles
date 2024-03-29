#!/bin/bash

function install() {
    which $1 &>/dev/null

    if [ $? -ne 0 ]; then
        echo "Installing: ${1}..."
        sudo apt install $1 -y
    else
        echo "Already installed: ${1}"
    fi
}

# TODO: Add function that downloads files and skips download if file is already local.
# Use instead of wget
