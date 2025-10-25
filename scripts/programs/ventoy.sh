#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"


# Ventoy
echo "Installing ventoy usb boot disk tool"

set -euo pipefail

# --- prerequisites ---
if ! command -v curl >/dev/null 2>&1 || ! command -v tar >/dev/null 2>&1; then
  sudo apt-get update || true
  sudo apt-get install -y curl tar
fi

# --- discover latest tag (API first, releases page fallback) ---
LATEST_TAG="$(
  curl -fsSL https://api.github.com/repos/ventoy/Ventoy/releases/latest 2>/dev/null \
    | awk -F'"' '/"tag_name":/ {print $4; exit}'
)"
if [ -z "${LATEST_TAG:-}" ]; then
  LATEST_TAG="$(
    curl -fsSL https://github.com/ventoy/Ventoy/releases 2>/dev/null \
      | grep -Eo 'releases/tag/v[0-9]+\.[0-9]+\.[0-9]+' \
      | head -n1 | sed 's#.*/##'
  )"
fi
[ -n "${LATEST_TAG:-}" ] || { echo "❌ Could not determine latest Ventoy version."; exit 1; }
VERSION="${LATEST_TAG#v}"
echo "Latest Ventoy: ${VERSION}"

# --- download & extract ---
TMP_TGZ="/tmp/ventoy-${VERSION}-linux.tar.gz"
URL="https://github.com/ventoy/Ventoy/releases/download/${LATEST_TAG}/ventoy-${VERSION}-linux.tar.gz"
echo "Downloading: ${URL}"
curl -fL --retry 3 -o "${TMP_TGZ}" "${URL}"

WORKDIR="$(mktemp -d)"
trap 'rm -rf "${WORKDIR}"' EXIT
tar -xzf "${TMP_TGZ}" -C "${WORKDIR}"
SRC_DIR="${WORKDIR}/ventoy-${VERSION}"
[ -d "${SRC_DIR}" ] || { echo "❌ Unexpected archive layout."; exit 1; }

# --- install to /opt/ventoy/ventoy-<ver> and update 'current' ---
INSTALL_BASE="/opt/ventoy"
INSTALL_DIR="${INSTALL_BASE}/ventoy-${VERSION}"
sudo install -d -m 0755 "${INSTALL_BASE}"
if [ ! -d "${INSTALL_DIR}" ]; then
  sudo rm -rf "${INSTALL_DIR}.partial" 2>/dev/null || true
  sudo mkdir -p "${INSTALL_DIR}.partial"
  sudo cp -a "${SRC_DIR}/." "${INSTALL_DIR}.partial/"
  sudo mv "${INSTALL_DIR}.partial" "${INSTALL_DIR}"
fi
sudo rm -f "${INSTALL_BASE}/current"
sudo ln -s "${INSTALL_DIR}" "${INSTALL_BASE}/current"

# --- one wrapper that preserves GUI env & elevates via pkexec ---
sudo tee /usr/local/bin/ventoygui-root >/dev/null <<'EOF'
#!/usr/bin/env bash
set -e
cd /opt/ventoy/current
exec pkexec env \
  DISPLAY="$DISPLAY" \
  XAUTHORITY="$XAUTHORITY" \
  WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-}" \
  XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-}" \
  /opt/ventoy/current/VentoyGUI.x86_64
EOF
sudo chmod +x /usr/local/bin/ventoygui-root

# --- single desktop shortcut ---
sudo tee /usr/share/applications/ventoy.desktop >/dev/null <<'EOF'
[Desktop Entry]
Name=Ventoy
Comment=Create bootable USB drives
Exec=/usr/local/bin/ventoygui-root
Icon=drive-removable-media
Terminal=false
Type=Application
Categories=System;Utility;
EOF

# (Optional) refresh desktop DB; ignore errors if tool not present
update-desktop-database >/dev/null 2>&1 || true

echo "✅ Ventoy ${VERSION} installed at ${INSTALL_DIR}"
echo "• Launcher: Applications menu → Ventoy (prompts for password)"
echo "• CLI (optional): pkexec /opt/ventoy/current/Ventoy2Disk.sh"

