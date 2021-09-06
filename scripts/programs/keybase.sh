#!/bin/bash

. util.sh

echo "🔐  Installing Keybase"
curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb
sudo apt install ./keybase_amd64.deb
run_keybase
