#!/bin/bash

. util.sh

echo "🖌 Installing Pinta"
sudo add-apt-repository ppa:pinta-maintainers/pinta-stable
sudo apt update
sudo apt-get install pinta
