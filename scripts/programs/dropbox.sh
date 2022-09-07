#!/bin/bash

. ../util.sh

echo "Installing dropbox"
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
# This might freeze up the scripts, not sure how to best handle it:
nohup ~/.dropbox-dist/dropboxd &
