#!/bin/bash

. ../util.sh

echo "Installing dropbox"
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -

# Nohup to launch GUI app detached (aka. "disowned", "disentangled", "decoupled") (from:
# https://askubuntu.com/a/46211):
nohup ~/.dropbox-dist/dropboxd &
