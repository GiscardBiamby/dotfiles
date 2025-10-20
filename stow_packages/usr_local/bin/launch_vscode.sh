#!/bin/bash
# file="${1}"
# echo "${1}"
# echo "${@}"
# echo "XDG_SESSION_TYPE: ${XDG_SESSION_TYPE}"
# echo "Lauching with ${@}"

REAL_CLI="/usr/share/code/bin/code"   # VS Code's real CLI entrypoint
REAL_BIN="/usr/bin/code"              # The Electron binary launcher

# * If we're inside a VS Code terminal OR a VS Code instance is running, delegate to the real CLI
if [[ "$TERM_PROGRAM" == "vscode" ]] || "$REAL_CLI" --status >/dev/null 2>&1; then
    exec "$REAL_CLI" --reuse-window "$@"
fi

# * Otherwise, we are launching a new VS Code instance: add GPU/Wayland flags
if [[ $XDG_SESSION_TYPE == "wayland" ]]; then

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
    "$REAL_BIN" \
        --enable-gpu-rasterization \
        "${@}"
fi
