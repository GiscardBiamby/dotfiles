# stow packages

This describes the specifications for `.desktop` files: <https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html>

.desktop shortcut icons are stowed (symlink from /usr/share/applications/*.desktop to ~/dotfiles/stow_packages/usr_share/applications/*.desktop).

These two custom `code*.desktop` files point to `/usr/local/bin/launch_vscode.sh` instead of `/usr/share/code/code`. This shell script passes all the flags to enable a bunch of GPU acceleration and Wayland in vscode. You can test if it is working by running `xwininfo` from a terminal, and then moving the mouse cursor over the vscode window (or any window). If the cursor changes into a crosshairs shape it's using X11, if it stays as a mouse cursor arrow shape then it's wayland.

TO enable the GPU and wayland flags to work for when you simply use the `code` command from the terminal, i have an alias in `.zsh_aliases` that aliases code to run `/usr/local/bin/launch_vscode.sh`.

You can alos check by running `code --status` and looking at which gpu features are enabled. After setting this all up on my current system (AMD 6xxx GPU) `code --status` gives the following:

```log
Process Argv:     --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto --enable-gpu-rasterization --enable-native-gpu-memory-buffers --enable-features=VaapiVideoDecoder --enable-features=VaapiVideoEncoder --enable-accelerated-video --enable-accelerated-video-decode --enable-accelerated-mjpeg-decode --enable-unsafe-webgpu --enable-zero-copy --enable-raw-draw --enable-oop-rasterization --enable-gpu-compositing --enable-skia-graphite --enable-features=WebRTCPipeWireCapturer,UseSkiaRenderer,VaapiVideoDecoder,CanvasOopRasterization,VaapiVideoEncoder,RawDraw --use-vulkan --enable-gpu-memory-buffer-compositor-resources --unity-launch --crash-reporter-id ee68fc9a-5eef-49c6-9173-8c419e59e9c6
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

All the ways of launching vscode with the Ubuntu dock shortcut, right clicking the dock shortcut and doing "new empty window", and running `code` from the command line all open vscode with Wayland and GPU support now. They don't consolidate which icons appear as "open" in the dock though. Small price to pay.

```bash
sudo desktop-file-install /usr/share/applications/code.desktop
sudo desktop-file-install /usr/share/applications/code-url-handler.desktop
```