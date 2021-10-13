#!/bin/bash
set +e

. util.sh

echo "📮 Installing postman"
# https://www.how2shout.com/linux/how-to-install-postman-on-ubuntu-20-04-lts-linux/
wget https://dl.pstmn.io/download/latest/linux64 -O ./programs/downloads/linux64
sudo tar -xvf ./programs/downloads/linux64 -C /usr/bin

# TODO: Add to .bashrc
export PATH=$PATH:/usr/bin/Postman

# Setup desktop shortcut
{
    echo "[Desktop Entry]"
    echo "Name=Postman API Tool"
    echo "GenericName=Postman"
    echo "Comment=Testing API"
    echo "Exec=/usr/bin/Postman/Postman"
    echo "Terminal=false"
    echo "X-MultipleArgs=false"
    echo "Type=Application"
    echo "Icon=/usr/bin/Postman/app/resources/app/assets/icon.png"
    echo "StartupWMClass=Postman"
    echo "StartupNotify=true"
} >> /usr/share/applications/Postman.desktop

rm ./programs/downloads/linux64

# Uninstall
# sudo rm -r /usr/bin/Postman
# sudo rm -r /usr/share/applications/Postman.desktop
# sudo rm -r ~/Desktop/Postman.desktop