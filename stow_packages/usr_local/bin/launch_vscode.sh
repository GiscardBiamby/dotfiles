#!/bin/bash
# file="${1}"
# echo "${1}"
# echo "${@}"
# echo "XDG_SESSION_TYPE: ${XDG_SESSION_TYPE}"
# echo "Lauching with ${1}"

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
        "${@}"

    # ## 2025-03-09:
    # /usr/bin/code \
    #     --enable-features=UseOzonePlatform \
    #     --ozone-platform=wayland \
    #     --enable-features=WaylandWindowDecorations \
    #     --ozone-platform-hint=auto \
    #     --enable-native-gpu-memory-buffers \
    #     --enable-unsafe-webgpu \
    #     --enable-zero-copy \
    #     --enable-raw-draw \
    #     --enable-gpu-rasterization \
    #     --enable-oop-rasterization \
    #     --canvas-oop-rasterization \
    #     --enable-gpu-compositing \
    #     --enable-skia-graphite \
    #     --enable-features=WebRTCPipeWireCapturer,UseSkiaRenderer,VaapiVideoDecoder,CanvasOopRasterization,VaapiVideoEncoder \
    #     "${1}"

else
    # 2024-08-02: For use on ubxx VMs (which don't use wayland):
    /usr/bin/code \
        --enable-gpu-rasterization \
        --new-window "${@}"
fi
