#!/bin/bash
# file="${1}"
echo "${@}"
echo "Lauching with ${@}" >>"/home/gbiamby/code.log"

# This one worked for about a week and then crashed on 5/13. During the crash i was workin with
# raider and nautilus windows, and doing stuff with the vscode integrated terminal as well as the
# SLURM manager extension. Refreshing that extension while it as giving an error. But the crash just
# froze Ubuntu UI and i had to reboot.
# /usr/bin/code \
#     --enable-features=UseOzonePlatform \
#     --ozone-platform=wayland \
#     --enable-features=WaylandWindowDecorations \
#     --ozone-platform-hint=auto \
#     --enable-gpu-rasterization \
#     --enable-native-gpu-memory-buffers \
#     --enable-features=VaapiVideoDecoder \
#     --enable-features=VaapiVideoEncoder \
#     --enable-accelerated-video \
#     --enable-accelerated-video-decode \
#     --enable-accelerated-mjpeg-decode \
#     --enable-features=WebRTCPipeWireCapturer,UseSkiaRenderer,VaapiVideoDecoder,CanvasOopRasterization,VaapiVideoEncoder,RawDraw \
#     --new-window "${@}"

if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
    # * Optional: uncomment if you installed nvidia-vaapi-driver
    # * export LIBVA_DRIVER_NAME=nvidia

    # # * For debugging, just launch without any flags:
    # /usr/bin/code "${1}"

    # * NVIDIA, VM, 2025-10-19:
    # *     Wayland + GPU-accel VS Code (NVIDIA)
    # *     Optional (helps VA-API on NVIDIA if you installed nvidia-vaapi-driver):
    export LIBVA_DRIVER_NAME=nvidia
    /usr/bin/code \
        --ozone-platform=wayland \
        --enable-features=WaylandWindowDecorations,UseSkiaRenderer,CanvasOopRasterization,WebRTCPipeWireCapturer \
        --enable-gpu-rasterization \
        --enable-zero-copy \
        --enable-oop-rasterization \
        --use-vulkan \
        --new-window \
        "${@}"

else
    # * 2024-08-02: For use on ubxx VMs (which don't use wayland):
    /usr/bin/code \
        --enable-gpu-rasterization \
        --new-window "${@}"
fi
