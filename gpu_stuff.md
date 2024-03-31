Got a lot of the flags to use from this: https://github.com/electron/electron/issues/36633
Also found this, haven't explored yet: https://peter.sh/experiments/chromium-command-line-switches/

```yaml
--enable-features=WebRTCPipeWireCapturer,Vulkan,UseSkiaRenderer,VaapiVideoDecoder,CanvasOopRasterization,VaapiVideoEncoder,RawDraw
```

```yaml
WebRTCPipeWireCapturer,UseSkiaRenderer,CanvasOopRasterization,RawDraw
```

```bash
--enable-features=UseSkiaRenderer # skia_graphite=disabled_off
--enable-features=CanvasOopRasterization: does not affect canvas_oop_rasterization
```

```yaml
/usr/bin/code \
	--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer,Vulkan,UseSkiaRenderer,VaapiVideoDecoder,CanvasOopRasterization,VaapiVideoEncoder,RawDraw \
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
	--use-vulkan
```

broken:
```--gpu-sandbox-start-early \

```

---

# Canvas_oop_rasterization was on with this:

```bash
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
	--enable-features=WebRTCPipeWireCapturer,UseSkiaRenderer,VaapiVideoDecoder,CanvasOopRasterization,VaapiVideoEncoder,RawDraw \
	--use-vulkan
GPU Status:       2d_canvas:                              enabled
                  canvas_oop_rasterization:               enabled_on
                  direct_rendering_display_compositor:    disabled_off_ok
                  gpu_compositing:                        enabled
                  multiple_raster_threads:                enabled_on
                  opengl:                                 enabled_on
                  rasterization:                          enabled_force
                  raw_draw:                               enabled_on
                  skia_graphite:                          disabled_off
                  video_decode:                           enabled
                  video_encode:                           enabled
                  vulkan:                                 enabled_on
                  webgl:                                  enabled
                  webgl2:                                 enabled
                  webgpu:                                 enabled
```

---

```bash
/usr/bin/code \
	--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer,UseSkiaRenderer,VaapiVideoDecoder,CanvasOopRasterization,VaapiVideoEncoder,RawDraw \
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
	--enable-features= \
	--use-vulkan
GPU Status:       2d_canvas:                              enabled
                  canvas_oop_rasterization:               disabled_off
                  direct_rendering_display_compositor:    disabled_off_ok
                  gpu_compositing:                        enabled
                  multiple_raster_threads:                enabled_on
                  opengl:                                 enabled_on
                  rasterization:                          enabled_force
                  raw_draw:                               disabled_off_ok
                  skia_graphite:                          disabled_off
                  video_decode:                           enabled
                  video_encode:                           disabled_software
                  vulkan:                                 enabled_on
                  webgl:                                  enabled
                  webgl2:                                 enabled
                  webgpu:                                 enabled
```

---

```bash
/usr/bin/code \
	--enable-features=WebRTCPipeWireCapturer,UseSkiaRenderer,VaapiVideoDecoder,CanvasOopRasterization,VaapiVideoEncoder,RawDraw \
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
	--enable-features= \
	--use-vulkan
GPU Status:       2d_canvas:                              enabled
                  canvas_oop_rasterization:               disabled_off
                  direct_rendering_display_compositor:    disabled_off_ok
                  gpu_compositing:                        enabled
                  multiple_raster_threads:                enabled_on
                  opengl:                                 enabled_on
                  rasterization:                          enabled_force
                  raw_draw:                               disabled_off_ok
                  skia_graphite:                          disabled_off
                  video_decode:                           enabled
                  video_encode:                           disabled_software
                  vulkan:                                 enabled_on
                  webgl:                                  enabled
                  webgl2:                                 enabled
                  webgpu:                                 enabled
```

---

```bash
/usr/bin/code \
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
	--enable-features= \
	--enable-features=WebRTCPipeWireCapturer,UseSkiaRenderer,VaapiVideoDecoder,CanvasOopRasterization,VaapiVideoEncoder,RawDraw \
	--use-vulkan
\GPU Status:       2d_canvas:                              enabled
                  canvas_oop_rasterization:               enabled_on
                  direct_rendering_display_compositor:    disabled_off_ok
                  gpu_compositing:                        enabled
                  multiple_raster_threads:                enabled_on
                  opengl:                                 enabled_on
                  rasterization:                          enabled_force
                  raw_draw:                               enabled_on
                  skia_graphite:                          disabled_off
                  video_decode:                           enabled
                  video_encode:                           enabled
                  vulkan:                                 enabled_on
                  webgl:                                  enabled
                  webgl2:                                 enabled
                  webgpu:                                 enabled
```

---

```bash
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
	--enable-features= \
	--enable-features=WebRTCPipeWireCapturer,UseSkiaRenderer,VaapiVideoDecoder,CanvasOopRasterization,VaapiVideoEncoder,RawDraw \
	--use-vulkan
GPU Status:       2d_canvas:                              enabled
                  canvas_oop_rasterization:               enabled_on
                  direct_rendering_display_compositor:    disabled_off_ok
                  gpu_compositing:                        enabled
                  multiple_raster_threads:                enabled_on
                  opengl:                                 enabled_on
                  rasterization:                          enabled_force
                  raw_draw:                               enabled_on
                  skia_graphite:                          disabled_off
                  video_decode:                           enabled
                  video_encode:                           enabled
                  vulkan:                                 enabled_on
                  webgl:                                  enabled
                  webgl2:                                 enabled
                  webgpu:                                 enabled
```

---

```bash
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
	--enable-gpu-compositing \=
	--enable-features=WebRTCPipeWireCapturer,UseSkiaRenderer,VaapiVideoDecoder,CanvasOopRasterization,VaapiVideoEncoder,RawDraw \
	--use-vulkan
GPU Status:       2d_canvas:                              enabled
                  canvas_oop_rasterization:               enabled_on
                  direct_rendering_display_compositor:    disabled_off_ok
                  gpu_compositing:                        enabled
                  multiple_raster_threads:                enabled_on
                  opengl:                                 enabled_on
                  rasterization:                          enabled_force
                  raw_draw:                               enabled_on
                  skia_graphite:                          disabled_off
                  video_decode:                           enabled
                  video_encode:                           enabled
                  vulkan:                                 enabled_on
                  webgl:                                  enabled
                  webgl2:                                 enabled
                  webgpu:                                 enabled
```

---

```bash
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
	--enable-gpu-rasterization \
	--enable-drdc \
	--enable-features=WebRTCPipeWireCapturer,UseSkiaRenderer,VaapiVideoDecoder,CanvasOopRasterization,VaapiVideoEncoder,RawDraw \
	--use-vulkan

GPU Status:       2d_canvas:                              enabled
                  canvas_oop_rasterization:               enabled_on
                  direct_rendering_display_compositor:    disabled_off_ok
                  gpu_compositing:                        enabled
                  multiple_raster_threads:                enabled_on
                  opengl:                                 enabled_on
                  rasterization:                          enabled_force
                  raw_draw:                               enabled_on
                  skia_graphite:                          disabled_off
                  video_decode:                           enabled
                  video_encode:                           enabled
                  vulkan:                                 enabled_on
                  webgl:                                  enabled
                  webgl2:                                 enabled
                  webgpu:                                 enabled
```

---

```bash
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
	--enable-gpu-memory-buffer-compositor-resources
```


/usr/bin/code --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto --enable-gpu-rasterization --enable-native-gpu-memory-buffers --enable-features=VaapiVideoDecoder --enable-features=VaapiVideoEncoder --enable-accelerated-video --enable-accelerated-video-decode --enable-accelerated-mjpeg-decode --enable-unsafe-webgpu --enable-zero-copy --enable-raw-draw --enable-oop-rasterization --enable-gpu-compositing --enable-skia-graphite --enable-features=WebRTCPipeWireCapturer,UseSkiaRenderer,VaapiVideoDecoder,CanvasOopRasterization,VaapiVideoEncoder,RawDraw --use-vulkan --enable-gpu-memory-buffer-compositor-resources