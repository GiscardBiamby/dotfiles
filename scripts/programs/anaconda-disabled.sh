# #!/bin/bash

# . ../util.sh

# echo "🐍 Installing anaconda"

# if [[ ! -f "anaconda3_x86_64.sh" ]]; then
#     wget -O - https://www.anaconda.com/distribution/ 2>/dev/null |
#         sed -ne 's@.*\(https:\/\/repo\.anaconda\.com\/archive\/Anaconda3-.*-Linux-x86_64\.sh\)\">64-Bit (x86) Installer.*@\1@p' |
#         xargs wget -O ./programs/downloads/anaconda3_x86_64.sh
# fi

# # Silent install (note: it doesn't add the PATH stuff to .bashrc, so make sure to add
# # that into the .bashrc in this dotfiles repo):
# bash ./programs/downloads/anaconda3_x86_64.sh -b \
#     -p ~/anaconda3

# # activate in current shell session:
# eval "$(~/anaconda3/bin/conda shell.bash hook)"

# # Install conda's shell functions:
# conda init
# conda update conda
# conda install -c conda-forge conda-bash-completion

# rm ./programs/downloads/anaconda3_x86_64.sh
