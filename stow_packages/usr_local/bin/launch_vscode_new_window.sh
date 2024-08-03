#!/bin/bash
# file="${1}"
echo "${@}"
echo "Lauching with ${@}" >> "/home/gbiamby/code.log"
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
#     --new-window "${@}"

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


# Trying this starting with 2024-05-13
# /usr/bin/code \
#     --enable-features=UseOzonePlatform \
#     --ozone-platform=wayland \
#     --enable-features=WaylandWindowDecorations \
#     --ozone-platform-hint=auto \
#     --enable-gpu-rasterization \
#     --enable-native-gpu-memory-buffers \
#     --enable-features=WebRTCPipeWireCapturer,UseSkiaRenderer,VaapiVideoDecoder,CanvasOopRasterization,VaapiVideoEncoder,RawDraw \
#     --new-window "${@}"


# 2024-08-02: For use on ubxx VMs (which don't use wayland):
/usr/bin/code  \
    --enable-gpu-rasterization \
    --new-window "${@}"