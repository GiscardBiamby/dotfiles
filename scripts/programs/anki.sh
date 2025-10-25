#!/bin/bash

# Get the directory of this script so that we can reference paths correctly no matter which folder
# the script was launched from:
SCRIPT_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../util.sh"

echo "Installing Anki (latest release that has a Linux tarball)…"


# --- prerequisites (idempotent) ---
# note: libraries can't be detected via `command -v`, just install them
sudo apt-get update || true
sudo apt-get install -y curl tar zstd jq libxcb-xinerama0 libxcb-cursor0 libnss3 || true

# --- find the newest release WITH a Linux asset (Qt6 or launcher) ---
# We scan up to the latest 50 releases and pick the first with a matching asset.
JSON="$(curl -fsSL "https://api.github.com/repos/ankitects/anki/releases?per_page=50")"

match_line="$(printf '%s' "$JSON" | jq -r '
  .[] | {tag: .tag_name, assets: (.assets // [])}
  | . as $rel
  | ($rel.assets[]? | select(.name|test("^(anki-.*-linux-qt6\\.tar\\.zst|anki-launcher-.*-linux\\.tar\\.zst)$"))
     | "\($rel.tag)|\(.name)|\(.browser_download_url)")' \
  | head -n1)"

echo "match line: ${match_line}"
if [ -z "${match_line}" ]; then
  echo "❌ Could not find a recent Anki release with a Linux tarball." >&2
  echo "   Check https://github.com/ankitects/anki/releases manually." >&2
  exit 1
fi

TAG="${match_line%%|*}"                     # e.g. 25.09
rest="${match_line#*|}"
ASSET_NAME="${rest%%|*}"                    # anki-25.09-linux-qt6.tar.zst OR anki-launcher-25.09-linux.tar.zst
DL_URL="${rest#*|}"

echo "Selected release: ${TAG}"
echo "Asset: ${ASSET_NAME}"
echo "URL: ${DL_URL}"

# --- download asset ---
TMP_TAR="/tmp/${ASSET_NAME}"
echo "Downloading ${ASSET_NAME} ..."
curl -fL --retry 3 -o "${TMP_TAR}" "${DL_URL}"

# --- extract per docs; try --zstd first, then fall back to unzstd pipe ---
WORKDIR="$(mktemp -d)"
trap 'rm -rf "${WORKDIR}"' EXIT

echo "Extracting ${ASSET_NAME} ..."
if ! tar --zstd -xf "${TMP_TAR}" -C "${WORKDIR}"; then
  echo "tar --zstd failed; retrying with unzstd pipe…"
  unzstd -c "${TMP_TAR}" | tar -x -C "${WORKDIR}"
fi

# find the extracted folder that contains install.sh (handles both qt6 and launcher tars)
SRC_DIR="$(find "${WORKDIR}" -maxdepth 2 -type f -name install.sh -printf '%h\n' | head -n1)"
if [ -z "${SRC_DIR}" ]; then
  echo "❌ Could not find install.sh in the extracted archive." >&2
  echo "   Contents:"; find "${WORKDIR}" -maxdepth 2 -print | sed 's/^/   /'
  exit 1
fi

# --- run official installer (installs under /usr/local/, puts 'anki' in PATH) ---
echo "Running Anki installer from: ${SRC_DIR}"
( cd "${SRC_DIR}" && sudo ./install.sh )

echo "✅ Anki installed. Launch with: anki"

