#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"
set +e

# Zoom
echo "Installing Zoom (latest, amd64)…"

ARCH=amd64
LATEST_ENDPOINT="https://zoom.us/client/latest/zoom_${ARCH}.deb"

need_update=0
for cmd in curl dpkg-deb; do
    if ! command -v "$cmd" >/dev/null 2>&1; then need_update=1; fi
done
if [ $need_update -eq 1 ]; then
    sudo apt-get update || true
    sudo apt-get install -y curl dpkg-dev
fi

# Resolve the "latest" URL to its final, versioned URL
# Example final URL: https://zoom.us/client/5.17.11.3835/zoom_amd64.deb
echo "Resolving latest Zoom URL…"
FINAL_URL="$(curl -fsSLI -o /dev/null -w '%{url_effective}' "$LATEST_ENDPOINT" || true)"

if [ -z "$FINAL_URL" ]; then
    echo "⚠️  Could not resolve final URL; will use $LATEST_ENDPOINT directly."
    FINAL_URL="$LATEST_ENDPOINT"
fi

# Extract version from the final URL path if present
# …/client/<version>/zoom_amd64.deb
LATEST_VER="$(printf '%s\n' "$FINAL_URL" | sed -n 's#.*/client/\([^/]\+\)/zoom_amd64\.deb#\1#p')"
if [ -z "$LATEST_VER" ]; then
    LATEST_VER="latest"
fi
echo "Latest Zoom version (from URL): $LATEST_VER"

# Check installed version (if any)
INSTALLED_VER=""
if dpkg-query -W -f='${Status}\n' zoom 2>/dev/null | grep -q "install ok installed"; then
    INSTALLED_VER="$(dpkg-query -W -f='${Version}\n' zoom 2>/dev/null || true)"
    echo "Currently installed Zoom version: ${INSTALLED_VER}"
fi

# If we have a concrete latest version, and Zoom is installed and up-to-date, we can skip
if [ -n "$INSTALLED_VER" ] && [ "$LATEST_VER" != "latest" ]; then
    if dpkg --compare-versions "$INSTALLED_VER" ge "$LATEST_VER"; then
        echo "✅ Zoom is already up to date (installed: $INSTALLED_VER, latest: $LATEST_VER)."
        exit 0
    fi
fi

# Download the deb (to a predictable path under /tmp)
DEB_PATH="/tmp/zoom_${LATEST_VER}_${ARCH}.deb"
echo "Downloading: $FINAL_URL"
curl -fL --retry 3 -o "$DEB_PATH" "$FINAL_URL"

# Double-check the version inside the deb (if resolvable), prefer this for logging
DEB_VER="$(dpkg-deb -f "$DEB_PATH" Version 2>/dev/null || echo "")"
if [ -n "$DEB_VER" ]; then
    echo "Downloaded package reports Version: $DEB_VER"
else
    echo "Downloaded package version unknown (will let apt handle it)."
fi

# Install/upgrade via apt so dependencies are handled
echo "Installing Zoom from: $DEB_PATH"
# apt new-style local install (resolves deps):
sudo apt-get install -y "$DEB_PATH"

# Final report
if dpkg-query -W -f='${Status}\n' zoom 2>/dev/null | grep -q "install ok installed"; then
    NEW_VER="$(dpkg-query -W -f='${Version}\n' zoom 2>/dev/null || true)"
    echo "✅ Zoom installed: version ${NEW_VER}"
else
    echo "❌ Zoom installation appears to have failed."
    exit 1
fi

# Optional: clean the downloaded deb (comment out if you prefer to keep it)
rm -f "$DEB_PATH" || true
