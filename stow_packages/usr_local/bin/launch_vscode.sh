#!/bin/bash
# file="${1}"
# echo "${1}"
# echo "${@}"
# echo "XDG_SESSION_TYPE: ${XDG_SESSION_TYPE}"
# echo "Lauching with ${1}"
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
#     --enable-unsafe-webgpu \
#     --enable-zero-copy \
#     --enable-raw-draw \
#     --enable-oop-rasterization \
#     --enable-gpu-compositing \
#     --enable-skia-graphite \
#     --enable-features=WebRTCPipeWireCapturer,UseSkiaRenderer,VaapiVideoDecoder,CanvasOopRasterization,VaapiVideoEncoder,RawDraw \
#     --use-vulkan \
#     --enable-gpu-memory-buffer-compositor-resources \
#     --unity-launch "${1}"

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
#     --unity-launch "${1}"

# # Trying this starting with 2024-05-13
# /usr/bin/code \
#     --enable-features=UseOzonePlatform \
#     --ozone-platform=wayland \
#     --enable-features=WaylandWindowDecorations \
#     --ozone-platform-hint=auto \
#     --enable-gpu-rasterization \
#     --enable-native-gpu-memory-buffers \
#     --enable-features=WebRTCPipeWireCapturer,UseSkiaRenderer,VaapiVideoDecoder,CanvasOopRasterization,VaapiVideoEncoder,RawDraw \
#     --unity-launch "${1}"

if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
    # * For debugging, just launch without any flags:
    # /usr/bin/code "${1}"

    # * 2025-01-31 This works. You'll know it stops working if running `code ./some_file.txt` on the
    # *  command line opens a new window (wrong) or if it opens the file in a new tab of an existing
    # *  vs code window (correct)
    # * Using any fo these BREAKS this setup:
    # *     --use-vulkan
    # *     --enable-gpu-memory-buffer-compositor-resources
    # *     --enable-gpu-rasterization
    /usr/bin/code \
        --enable-features=UseOzonePlatform \
        --ozone-platform=wayland \
        --enable-features=WaylandWindowDecorations \
        --ozone-platform-hint=auto \
        --enable-native-gpu-memory-buffers \
        --enable-unsafe-webgpu \
        --enable-zero-copy \
        --enable-raw-draw \
        --enable-gpu-rasterization \
        --enable-oop-rasterization \
        --canvas-oop-rasterization \
        --enable-gpu-compositing \
        --enable-skia-graphite \
        --enable-features=WebRTCPipeWireCapturer,UseSkiaRenderer,VaapiVideoDecoder,CanvasOopRasterization,VaapiVideoEncoder,RawDraw \
        "${1}"
    # * Trying this starting on 2024-08-01
    # * Removed RawDraw from --enable-features, as with vscode version that I updated to today (1.92.0)
    # * it breaks the rendering for vscode (blank window)
    # /usr/bin/code \
    #     --enable-features=UseOzonePlatform \
    #     --ozone-platform=wayland \
    #     --enable-features=WaylandWindowDecorations \
    #     --ozone-platform-hint=auto \
    #     --enable-gpu-rasterization \
    #     --enable-native-gpu-memory-buffers \
    #     --enable-features=WebRTCPipeWireCapturer,UseSkiaRenderer,VaapiVideoDecoder,CanvasOopRasterization,VaapiVideoEncoder \
    #     --unity-launch "${1}"
else
    # 2024-08-02: For use on ubxx VMs (which don't use wayland):
    /usr/bin/code \
        --enable-gpu-rasterization \
        --new-window "${@}"
fi
