#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"

echo "✒️ Installing obsidian ✒️"
gh_user_name="obsidianmd"
gh_project_name="obsidian-releases"
function get_latest_github_release_version() {
    # Get latest release (this might be brittle -- api might change)
    local gh_user_name="${1}"
    local gh_project_name="${2}"
    release_version_num=$(wget -q -O - "https://api.github.com/repos/${gh_user_name}/${gh_project_name}/releases/latest" \
    | jq -r '.name')
}


mkdir -p "${SCRIPT_DIR}/downloads/obsidian"
pushd "${SCRIPT_DIR}/downloads/obsidian"

get_latest_github_release_version $gh_user_name $gh_project_name
echo "Downloading obsidian version ${release_version_num}"
local_file="obsidian_${release_version_num}_amd64.deb"
# shellcheck disable=SC2046
wget $(wget -q -O - "https://api.github.com/repos/${gh_user_name}/${gh_project_name}/releases/latest" \
    | jq -r ".assets[] | select(.name | endswith(\"${release_version_num}_amd64.deb\")).browser_download_url") \
    -O "${local_file}"
sudo dpkg -i "${local_file}"

echo "Finished obsidian install."
