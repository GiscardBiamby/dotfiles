# #!/bin/bash

# # Get the directory of this script so that we can reference paths correctly no matter which folder
# # the script was launched from:
# SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# # shellcheck disable=SC1091
# source "${SCRIPT_DIR}/../util.sh"

# echo "Installing pgAdmin (apt repo + desktop package)"

# # --- Detect OS codename, allow override via PGADMIN_VENDOR_CODENAME ---
# OS_CODENAME="$( (lsb_release -cs 2>/dev/null) || ( . /etc/os-release && echo "${VERSION_CODENAME:-}" ) || echo "" )"
# PGADMIN_VENDOR_CODENAME="${PGADMIN_VENDOR_CODENAME:-${OS_CODENAME:-noble}}"
# FALLBACK_CODENAME="noble"
# PG_LIST_FILE="/etc/apt/sources.list.d/pgadmin4.list"
# PG_KEYRING="/etc/apt/keyrings/pgadmin.gpg"

# # --- Ensure prerequisites are present (idempotent) ---
# sudo apt-get update || true
# sudo apt-get install -y ca-certificates curl gpg software-properties-common

# # --- Install pgAdmin key into keyring (non-interactive + idempotent) ---
# sudo install -m 0755 -d /etc/apt/keyrings
# curl -fsSL https://www.pgadmin.org/static/packages_pgadmin_org.pub -o /tmp/pgadmin.gpg.asc
# sudo gpg --dearmor --batch --yes -o "${PG_KEYRING}" /tmp/pgadmin.gpg.asc
# sudo chmod a+r "${PG_KEYRING}"
# rm -f /tmp/pgadmin.gpg.asc

# # --- Disable any stale/broken pgAdmin entries (e.g., questing without signed-by) ---
# if [ -f "${PG_LIST_FILE}" ]; then
#   sudo sed -i 's|^deb |# deb |' "${PG_LIST_FILE}" || true
# fi

# # helper to write a repo line deterministically
# write_repo() {
#   local codename="$1"
#   echo "deb [signed-by=${PG_KEYRING}] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/${codename} pgadmin4 main" \
#   | sudo tee "${PG_LIST_FILE}" >/dev/null
# }

# # helper: scoped apt update (only pgAdmin list, so other repos can't fail this)
# scoped_update() {
#   sudo apt-get \
#     -o Dir::Etc::sourcelist="${PG_LIST_FILE}" \
#     -o Dir::Etc::sourceparts="-" \
#     -o APT::Get::List-Cleanup="0" \
#     update
# }

# # --- Try with the detected codename first; fall back to noble if needed ---
# echo "Configuring pgAdmin repo for codename: ${PGADMIN_VENDOR_CODENAME}"
# write_repo "${PGADMIN_VENDOR_CODENAME}"
# if ! scoped_update; then
#   if [ "${PGADMIN_VENDOR_CODENAME}" != "${FALLBACK_CODENAME}" ]; then
#     echo "⚠️  pgAdmin repo not available for '${PGADMIN_VENDOR_CODENAME}', falling back to '${FALLBACK_CODENAME}'"
#     write_repo "${FALLBACK_CODENAME}"
#     if ! scoped_update; then
#       echo "❌ pgAdmin repo failed for both '${PGADMIN_VENDOR_CODENAME}' and '${FALLBACK_CODENAME}'. Disabling to avoid noisy apt errors."
#       sudo sed -i 's|^deb |# deb |' "${PG_LIST_FILE}" || true
#       exit 1
#     fi
#   else
#     echo "❌ pgAdmin repo failed for fallback codename '${FALLBACK_CODENAME}'. Disabling."
#     sudo sed -i 's|^deb |# deb |' "${PG_LIST_FILE}" || true
#     exit 1
#   fi
# fi

# # --- Install pgAdmin desktop (idempotent) ---
# INSTALL_FAILED=0
# sudo apt-get install -y pgadmin4-desktop || INSTALL_FAILED=1

# # --- NEW: Fail clearly if still not installable (likely due to python3.12 not present for this release) ---
# if [ "${INSTALL_FAILED}" -ne 0 ]; then
#   echo "❌ pgadmin4-desktop could not be installed."
#   if ! apt-cache policy python3.12 | grep -q 'Candidate: [^ ]\+'; then
#     echo "   Reason: python3.12 is not available for this Ubuntu release (required by pgadmin4-server)."
#   fi
#   echo "   You can try: PGADMIN_VENDOR_CODENAME=noble $0"
#   exit 1
# fi

# echo "✅ pgAdmin installed."
# echo "ℹ️  You can copy ~/.pgadmin/pgadmin4.db between machines to transfer server definitions."
