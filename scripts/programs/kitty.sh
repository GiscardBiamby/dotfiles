#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"


echo "Installing GPU-accelerated Kitty Terminal 🐱..."
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# Add kitty to path
sudo ln -s ~/.local/kitty.app/bin/kitty /usr/local/bin/

# Create Desktop And Application Shortcuts
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/

# Add icon
sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop

# For desktop shortcut
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/Desktop
sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/Desktop/kitty*.desktop
sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/Desktop/kitty*.desktop

# Allow launching of the shortcut
gio set ~/Desktop/kitty*.desktop metadata::trusted true
chmod a+x ~/Desktop/kitty*.desktop

# Download themes
mkdir -p ~/.config/kitty/kitty-themes/
git clone --depth 1 https://github.com/dexpota/kitty-themes.git ~/.config/kitty/kitty-themes


# Uninstall
# rm -rf ~/.config/kitty
# rm -rf ~/.local/kitty.app
# rm ~/.local/share/applications/kitty.desktop
# rm ~/Desktop/kitty.desktop
# sudo rm /usr/local/bin/kitty
