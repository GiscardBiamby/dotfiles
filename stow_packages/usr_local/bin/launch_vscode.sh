#!/bin/bash
# file="${1}"
echo "${1}"
echo "Lauching with ${1}"
/usr/bin/code \
    --enable-features=UseOzonePlatform \
    --ozone-platform=wayland \
    --enable-features=WaylandWindowDecorations \
    --ozone-platform-hint=auto \
    --enable-gpu-rasterization \
    --enable-native-gpu-memory-buffers \
    --enable-features=VaapiVideoDecoder \
    --enable-features=VaapiVideoEncoder \
    --enable-accelerated-video \
    --enable-accelerated-video-decode \
    --enable-accelerated-mjpeg-decode \
    --enable-unsafe-webgpu \
    --enable-zero-copy \
    --enable-raw-draw \
    --enable-oop-rasterization \
    --enable-gpu-compositing \
    --enable-skia-graphite \
    --enable-features=WebRTCPipeWireCapturer,UseSkiaRenderer,VaapiVideoDecoder,CanvasOopRasterization,VaapiVideoEncoder,RawDraw \
    --use-vulkan \
    --enable-gpu-memory-buffer-compositor-resources \
    --unity-launch "${1}"

