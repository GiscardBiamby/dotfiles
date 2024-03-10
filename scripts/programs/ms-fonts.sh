#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
source "${SCRIPT_DIR}/../util.sh"

# https://www.pcworld.com/article/2863497/how-to-install-microsoft-fonts-in-linux-office-suites.html
# https://lexics.github.io/installing-ms-fonts
echo "Installing Microsoft Fonts (to help LibreOffice)"

pushd ~/
echo $(pwd)
mkdir -p .fonts

echo "Install Microsoft’s TrueType Core fonts"
install ttf-mscorefonts-installer
install cabextract

# Note: A lot of these commands below give output that complains about looped directories, but in
# the end it seems to work fine. All the fonts end up appearing like so:
#
# ~  $ tree ~/.fonts
# .fonts
# ├── calibrib.ttf
# ├── calibrii.ttf
# ├── calibri.ttf
# ├── calibriz.ttf
# ├── cambriab.ttf
# ├── cambriai.ttf
# ├── cambria.ttf
# ├── cambriaz.ttf
# ├── candarab.ttf
# ├── candarai.ttf
# ├── candara.ttf
# ├── candaraz.ttf
# ├── consolab.ttf
# ├── consolai.ttf
# ├── consola.ttf
# ├── consolaz.ttf
# ├── constanb.ttf
# ├── constani.ttf
# ├── constan.ttf
# ├── constanz.ttf
# ├── corbelb.ttf
# ├── corbeli.ttf
# ├── corbel.ttf
# ├── corbelz.ttf
# ├── other-essential-fonts
# │   ├── mtextra.ttf
# │   ├── symbol.ttf
# │   ├── webdings.ttf
# │   ├── wingding.ttf
# │   ├── wingdng2.ttf
# │   └── wingdng3.ttf
# ├── segoeUI
# │   ├── segoeuib.ttf
# │   ├── segoeuii.ttf
# │   ├── segoeuil.ttf
# │   ├── segoeuisl.ttf
# │   ├── segoeui.ttf
# │   ├── segoeuiz.ttf
# │   ├── seguili.ttf
# │   ├── seguisbi.ttf
# │   ├── seguisb.ttf
# │   └── seguisli.ttf
# └── tahoma
#     ├── tahomabd.ttf
#     └── tahoma.ttf


echo "Install Microsoft’s ClearType fonts"
wget -qO- http://plasmasturm.org/code/vistafonts-installer/vistafonts-installer | bash

echo "Install Tahoma fonts"
wget -q -O - https://gist.githubusercontent.com/Blastoise/b74e06f739610c4a867cf94b27637a56/raw/96926e732a38d3da860624114990121d71c08ea1/tahoma.sh | bash

echo "Install Segoe UI fonts"
wget -q -O - https://gist.githubusercontent.com/Blastoise/64ba4acc55047a53b680c1b3072dd985/raw/6bdf69384da4783cc6dafcb51d281cb3ddcb7ca0/segoeUI.sh | bash

echo "Installing other fonts (requried for docs containing maths symbols)"
wget -q -O - https://gist.githubusercontent.com/Blastoise/d959d3196fb3937b36969013d96740e0/raw/429d8882b7c34e5dbd7b9cbc9d0079de5bd9e3aa/otherFonts.sh | bash

sudo fc-cache -vr

popd

