


# Install the Community NVIDIA VA-API Driver (elFarto)

Written for **Ubuntu 25.10 + NVIDIA 3090 + Wayland + GNOME 49**, and installs the **elFarto community `nvidia-vaapi-driver`** for VA-API hardware video decoding.

This guide installs the [elFarto/nvidia-vaapi-driver](https://github.com/elFarto/nvidia-vaapi-driver)
community build of the VA-API shim for NVIDIA GPUs on Ubuntu 25.10 + Wayland + GNOME 49.

This driver provides **hardware video decoding (NVDEC)** for apps that use VA-API  
(e.g., Chromium, Firefox, mpv).  
> ⚠️ Note: It does **not** currently enable hardware encoding (NVENC) via VA-API.

---

## 🧰 0. Overview

After installation, the following file will exist:
```

/usr/lib/x86_64-linux-gnu/dri/nvidia_drv_video.so
```


Apps using VA-API (like Chromium and Firefox) will load this driver automatically  
if the environment variable `LIBVA_DRIVER_NAME=nvidia` is set.

---

## 📦 1. Remove any old or conflicting package

```bash
sudo apt remove --purge -y nvidia-vaapi-driver
sudo rm -f /usr/lib/x86_64-linux-gnu/dri/nvidia_drv_video.so
````

---

## 🔧 2. Install build dependencies

```bash
sudo apt update
sudo apt install -y build-essential meson ninja-build git pkg-config \
  libva-dev libdrm-dev libx11-dev libxcb1-dev libx11-xcb-dev libxcb-dri3-dev \
  libwayland-dev wayland-protocols libegl1-mesa-dev libgbm-dev libglvnd-dev
```

---

## 📂 3. Clone the repository

```bash
mkdir -p ~/src
cd ~/src
git clone https://github.com/elFarto/nvidia-vaapi-driver.git
cd nvidia-vaapi-driver
```

You can clone anywhere — `/home/<user>/src` is just a clean convention.
The build artifacts will go in `build/`, and the installed driver lives in `/usr/lib/...`.

---

## ⚙️ 4. Build and install

```bash
meson setup build --prefix=/usr
ninja -C build
sudo ninja -C build install
```

This installs the shared library:

```
/usr/lib/x86_64-linux-gnu/dri/nvidia_drv_video.so
```

---

## 🌍 5. Make the environment variable available to GUI apps

Create a systemd environment file for your user session:

```bash
mkdir -p ~/.config/environment.d
printf 'LIBVA_DRIVER_NAME=nvidia\n' > ~/.config/environment.d/90-libva.conf
```

Then **log out and back in** (or reboot) and verify:

```bash
systemctl --user show-environment | grep LIBVA
```

You should see:

```
LIBVA_DRIVER_NAME=nvidia
```

---

## 👥 6. Ensure proper device permissions

```bash
ls -l /dev/dri/renderD128
groups $USER
```

If you’re not in the `render` group:

```bash
sudo usermod -aG render $USER
# log out and back in
```

---

## ✅ 7. Verify installation

Run:

```bash
vainfo | grep -E 'Driver version|Entrypoint'
```

Expected output:

```bash
Driver version: VA-API NVDEC driver [direct backend]
VAProfileH264High : VAEntrypointVLD
VAProfileHEVCMain : VAEntrypointVLD
...
```

You’ll see many `VAEntrypointVLD` entries (decode).
You will **not** see `VAEntrypointEnc*` (encode not supported via VA-API).

---

## ▶️ 8. Test with `mpv`

```bash
sudo apt install -y mpv
LIBVA_DRIVER_NAME=nvidia mpv --hwdec=vaapi --vo=gpu --gpu-context=wayland \
  /path/to/video.mp4
```

If decoding works, CPU usage should drop compared to software decoding.

---

## 🌐 9. Enable VA-API in browsers

### Chromium / Chrome

Launch with:

```bash
chromium --ozone-platform=wayland \
  --enable-features=VaapiVideoDecoder,WebRTCPipeWireCapturer,UseSkiaRenderer \
  --enable-gpu-rasterization --enable-zero-copy --enable-oop-rasterization
```

Then check `chrome://gpu` → **Video Decode: Hardware accelerated**.

> **Note:** Hardware encoding (e.g. WebRTC) will still be software-only on NVIDIA.

### Firefox (Deb version recommended)

Set in `about:config`:

```
media.ffmpeg.vaapi.enabled = true
media.hardware-video-decoding.enabled = true
media.rdd-ffmpeg.enabled = true
```

Launch with:

```bash
MOZ_ENABLE_WAYLAND=1 firefox
```

Then check `about:support` → **HARDWARE_VIDEO_DECODING: available by default**.

If you see “blocklisted”, verify:

* `LIBVA_DRIVER_NAME=nvidia` is visible in `systemctl --user show-environment`
* You’re using the **.deb**, not the Snap build of Firefox

---

## ♻️ 10. Update or rebuild later

```bash
cd ~/src/nvidia-vaapi-driver
git pull
rm -rf build
meson setup build --prefix=/usr
ninja -C build
sudo ninja -C build install
```

---

## 🧹 11. Reverting to Ubuntu’s package version (optional)

```bash
sudo rm -f /usr/lib/x86_64-linux-gnu/dri/nvidia_drv_video.so
sudo apt install -y nvidia-vaapi-driver
```

---

## 🧩 Troubleshooting

* **`vainfo` shows Mesa/iHD instead of NVIDIA**
  → Your session env didn’t load. Recheck `~/.config/environment.d` and reboot.

* **Firefox blocklisted VA-API**
  → Confirm `.deb` build, correct env var, and membership in `render` group.

* **Chrome/Chromium shows software decode**
  → Verify flags and that `chrome://gpu` lists `Video Decode: Hardware accelerated`.

---

### ✅ End Result

Once installed and verified:

* VA-API decode is enabled for NVIDIA on Wayland
* Hardware video decode works in Chromium, Firefox, mpv
* System remains fully compatible with regular NVIDIA drivers

```


