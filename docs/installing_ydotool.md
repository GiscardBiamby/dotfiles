```bash
sudo apt install scdoc;
cd ~/proj
git clone https://github.com/ReimuNotMoe/ydotool.git
cd ydotool; mkdir build; cd build
cmake .. && make -j `nproc`;

sudo make install;
systemctl daemon-reload;
systemctl --user enable ydotoold;
systemctl --user start ydotoold.service;
```

```bash
# --- CLEAN ROOT INSTALL FOR YDOTOOLD ---
# - Converts from any prior --user setup to a system (root) service
# - Socket: /run/ydotool/.ydotool_socket
# - Per-user env: ~/.config/environment.d/ydotool.conf
set -euo pipefail

# Pick the desktop user (who will run `ydotool`)
TARGET_USER="${SUDO_USER:-$USER}"
UIDN="$(id -u "$TARGET_USER")"
GIDN="$(id -g "$TARGET_USER")"
GRPN="$(id -gn "$TARGET_USER")"
HOME_DIR="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
SOCKET_PATH="/run/ydotool/.ydotool_socket"

echo "==> Using user: $TARGET_USER (UID=$UIDN GID=$GIDN GROUP=$GRPN)"
echo "==> Socket path: $SOCKET_PATH"

# 1) Remove/disable any user-scope unit (best-effort)
if command -v systemctl >/dev/null 2>&1; then
  echo "==> Disabling any user-scope ydotoold.service (best-effort)"
  sudo -u "$TARGET_USER" systemctl --user disable --now ydotoold.service >/dev/null 2>&1 || true
  sudo -u "$TARGET_USER" systemctl --user reset-failed ydotoold.service >/dev/null 2>&1 || true
fi
rm -f "$HOME_DIR/.config/systemd/user/ydotoold.service" 2>/dev/null || true
rm -f "$HOME_DIR/.config/systemd/user/basic.target.wants/ydotoold.service" 2>/dev/null || true
rm -f /usr/local/lib/systemd/user/ydotoold.service 2>/dev/null || true

# 2) Create system (root) unit
echo "==> Writing /etc/systemd/system/ydotoold.service"
sudo tee /etc/systemd/system/ydotoold.service >/dev/null <<EOF
[Unit]
Description=Starts ydotoold Daemon

[Service]
Type=simple
User=root
Group=${GRPN}
Restart=always
RestartSec=3
# Create /run/ydotool with group access so $TARGET_USER can reach the socket
RuntimeDirectory=ydotool
RuntimeDirectoryMode=0775
# Start daemon with socket owned by the desktop user
ExecStart=/usr/local/bin/ydotoold --socket-path=${SOCKET_PATH} --socket-own=${UIDN}:${GIDN} --socket-mode=0660
KillMode=process
TimeoutSec=180

[Install]
WantedBy=multi-user.target
EOF

# 3) Reload & start system service
echo "==> Enabling and starting system service"
sudo systemctl daemon-reload
sudo systemctl enable --now ydotoold.service
sudo systemctl --no-pager --full status ydotoold.service | sed -n '1,12p'

# * Note: for this part i put the YDOTOOL_SOCKET into stow_packages/user_env/.config/environment.d/env.conf manually:
# 4) Per-user environment (so ydotool auto-finds the socket)
echo "==> Installing per-user env at ${HOME_DIR}/.config/environment.d/ydotool.conf"
sudo -u "$TARGET_USER" mkdir -p "${HOME_DIR}/.config/environment.d"
sudo tee "${HOME_DIR}/.config/environment.d/ydotool.conf" >/dev/null <<EOF
YDOTOOL_SOCKET=${SOCKET_PATH}
EOF
sudo chown "$TARGET_USER:$GRPN" "${HOME_DIR}/.config/environment.d/ydotool.conf"

# Apply immediately for the running user manager (helpful before next login)
echo "==> Applying env to systemd-user for ${TARGET_USER}"
sudo -u "$TARGET_USER" systemctl --user set-environment "YDOTOOL_SOCKET=${SOCKET_PATH}" || true
sudo -u "$TARGET_USER" systemctl --user show-environment | grep -E '^YDOTOOL_SOCKET=' || true

# 5) Show the socket & do a quick functional test
echo "==> Verifying socket & permissions"
ls -ld /run/ydotool
ls -l  "${SOCKET_PATH}"

echo "==> Test typing via ydotool (this will type into the focused window):"
sudo -u "$TARGET_USER" env YDOTOOL_SOCKET="${SOCKET_PATH}" ydotool type "hello_from_root_service"

# 6) Summarize choices made
echo
echo "=== SUMMARY ==="
echo "Service scope:        SYSTEM (root)"
echo "Socket path:          ${SOCKET_PATH}"
echo "Socket owner:         ${TARGET_USER} (${UIDN}:${GIDN})"
echo "RuntimeDirectoryMode: 0775 (group traversal allowed)"
echo "Per-user env:         ${HOME_DIR}/.config/environment.d/ydotool.conf (systemd-user)"
echo "You can now run:      ydotool type \"hello\"   (new terminals after login will pick up env automatically)"

```
