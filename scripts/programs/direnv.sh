#!/bin/bash

. util.sh

echo "Installing direnv"

curl -qfsSL https://github.com/direnv/direnv/releases/download/v2.19.0/direnv.linux-amd64 -o direnv
chmod +x direnv
sudo mv direnv /usr/local/bin
