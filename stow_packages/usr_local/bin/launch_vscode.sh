#!/bin/bash
# * VS Code launcher script that adds GPU acceleration and Wayland support when launching a new instance
REAL_CLI="/usr/share/code/bin/code"   # VS Code's real CLI entrypoint
REAL_BIN="/usr/bin/code"              # The Electron binary launcher

# * This version is slower:
# vscode_running() {
#     # If Code is running, --status begins with a Version line; otherwise prints a Warning
#     if "$REAL_CLI" --status 2>&1 | grep -q '^Version:'; then
#         return 0
#     else
#         return 1
#     fi
# }

vscode_running() {
    # Match any process containing 'code' (more permissive)
    pgrep -f '/usr/share/code' >/dev/null 2>&1
}

has_arg() { printf '%s\0' "$@" | grep -z -q -- "$1"; }

# * If we're inside a VS Code terminal OR a VS Code instance is running, delegate to the real CLI
if [[ "$TERM_PROGRAM" == "vscode" ]] || vscode_running; then
    # Explicit request for a new window wins
    if has_arg --new-window "$@"; then
        exec "$REAL_CLI" "$@"
    fi

    # If *no* file/folder args, treat launcher invoke (incl. Shift-click) as "open a fresh window"
    if [[ $# -eq 0 ]]; then
        exec "$REAL_CLI" --new-window
    fi

    # Otherwise, user opened a path → reuse existing window
    exec "$REAL_CLI" --reuse-window "$@"
fi

# * Otherwise, we are launching a new VS Code instance: add GPU/Wayland flags
if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
    echo "Launching wayland"

    # # * For debugging, just launch without any flags:
    # "$REAL_BIN" "${@}"

    # * NVIDIA, VM, 2025-10-19:
    # *     Wayland + GPU-accel VS Code (NVIDIA)
    # *     If you installed nvidia-vaapi-driver you can include the ",VaapiVideoDecoder,VaapiVideoEncoder" part.
    # *     Declare LIBVA_DRIVER_NAME=nvidia or LIBVA_DRIVER_NAME=radeonsi in .zshrc_local
    # *     Optional (helps VA-API on NVIDIA if you installed nvidia-vaapi-driver):
    "$REAL_BIN" \
        --ozone-platform=wayland \
        --enable-features=WaylandWindowDecorations,UseSkiaRenderer,CanvasOopRasterization,WebRTCPipeWireCapturer,VaapiVideoDecoder,VaapiVideoEncoder \
        --enable-gpu-rasterization \
        --enable-zero-copy \
        --enable-oop-rasterization \
        --use-vulkan \
        "${@}"

else
    echo "Launching NON-wayland"
    "$REAL_BIN" \
        --enable-gpu-rasterization \
        "${@}"
fi
