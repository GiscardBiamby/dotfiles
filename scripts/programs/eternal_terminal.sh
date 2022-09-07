#!/bin/bash

. ../util.sh

echo " Installing Eternal Terminal"
echo "Maybe need to reconsider installing this. At some point it was causing ubuntu shutdown to hang for exactly one minute"
sudo add-apt-repository ppa:jgmath2000/et -y
sudo apt update
sudo apt-get install et
