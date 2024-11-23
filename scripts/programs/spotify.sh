# #!/bin/bash

# # Get the directory of this script so that we can reference paths correctly no matter which folder
# # the script was launched from:
# SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# # shellcheck disable=SC1091
# source "${SCRIPT_DIR}/../util.sh"

# echo "🎵 Installing Spotify"
# curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
# echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
# sudo apt update
# install spotify-client
