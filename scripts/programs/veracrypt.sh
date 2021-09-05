#!/bin/bash

. util.sh

echo "Installing veracrypt"

# You can either install GUI or console version, not both:

# GUI version
wget https://launchpad.net/veracrypt/trunk/1.24-update7/+download/veracrypt-1.24-Update7-Ubuntu-20.04-amd64.deb
sudo apt install -y ./veracrypt-1.24-Update7-Ubuntu-20.04-amd64.deb

# Console version
# wget https://launchpad.net/veracrypt/trunk/1.24-update7/+download/veracrypt-console-1.24-Update7-Ubuntu-20.04-amd64.deb
# sudo apt install -y ./veracrypt-console-1.24-Update7-Ubuntu-20.04-amd64.deb

rm ./veracrypt-1.24-Update7-Ubuntu-20.04-amd64.deb