#!/bin/bash

. ../util.sh

echo "📹🎙 Installing sqlitebrowser"
sudo add-apt-repository -y ppa:linuxgndu/sqlitebrowser
sudo apt update
install sqlitebrowser
