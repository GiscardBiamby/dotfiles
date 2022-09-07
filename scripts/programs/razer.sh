#!/bin/bash

. ../util.sh

echo " Installing Open Razer"
sudo add-apt-repository ppa:openrazer/stable -y
sudo apt update
sudo apt install openrazer-meta
sudo gpasswd -a $USER plugdev
echo "A reboot may be required"


echo " Installing polychromatic, a UI for Razer products"
sudo add-apt-repository ppa:polychromatic/stable
sudo apt update

# Full installation
sudo apt install polychromatic

# Or, selectively install components
# sudo apt install polychromatic-controller polychromatic-tray-applet polychromatic-cli