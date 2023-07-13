# Log

---

## 2023-02-01 Fix Issue where system cannot resume from suspend/sleep/hibernate

__Issue__: Affects ubuntu 22.04, Nvidia driver 525.x, wayland. Probably X11 and ubuntu 21.x too. When you try to resume the system you get a black screen or weird stuttering/slow-down/choppiness effects. For the current system it's a mostly black screen with corrupted UI elements. Like 99% of the UI elements don't render but those that do still look weird.

Check logs: `journalctl -b -1 -x --grep=nvidia`

Loosely based off this post: <https://forums.developer.nvidia.com/t/can-t-resume-after-suspend-with-515-driver-on-ubuntu-20-04/217343/2>.

Tested that I am able to resume from both suspend and hibernate.

Things I changed today to make it work (The final step that made it work was the `NVreg_PreserveVideoMemoryAllocations` one, so I'm not sure if the steps before that are required):

* Re-enable the nvidia suspend/resume services (I had disabled them in previous debugging attempts):
  ```bash
  sudo systemctl enable nvidia-hibernate.service
  sudo systemctl enable nvidia-resume.service
  sudo systemctl enable nvidia-suspend.service
  ```
* Fix `/etc/default/grub`. I think UUID might matter as well but I already had that for enabling hibernate to swap file. I had `nvidia.modeset` but changed it to `nvidia-drm.modeset`: `GRUB_CMDLINE_LINUX_DEFAULT="splash amd_iommu=on resume=UUID=9a280027-7847-4d87-80b3-d42c0f5292a9 resume_offset=8710144 nvidia-drm.modeset=1 nouveau.blacklist=1"`
* `sudo bash -c "echo options nvidia NVreg_PreserveVideoMemoryAllocations=1 > /etc/modprobe.d/nvidia-power-management.conf"`
* `sudo update-grub`
* `sudo update-initramfs -uv`

---

## 2023-02-01 Resize swap to 64GB

Followed instructions here: <https://askubuntu.com/a/1177939>

```bash
# Turn swap off
# This moves stuff in swap to the main memory and might take several minutes
sudo swapoff -a

# Create an empty swapfile
# Note that "1G" is basically just the unit and count is an integer.
# Together, they define the size. In this case 64GB.
sudo dd if=/dev/zero of=/swapfile bs=1G count=64

# Set the correct permissions
sudo chmod 0600 /swapfile


sudo mkswap /swapfile  # Set up a Linux swap area
sudo swapon /swapfile  # Turn the swap on
```

Check if it worked `grep Swap /proc/meminfo`

Make it permanent: `/swapfile swap swap sw 0 0` (`/swapfile none swap sw 0 0` is OK too)

---

## 2023-02-01 Enable Hibernate on Swap File

Followed instructions from [here](https://ubuntuhandbook.org/index.php/2021/08/enable-hibernate-ubuntu-21-10/).

Find UUID and Offset

```bash
$ df -h
Filesystem      Size  Used Avail Use% Mounted on
tmpfs           3.2G  2.9M  3.2G   1% /run
/dev/nvme1n1p2  916G  120G  750G  14% /
tmpfs            16G  335M   16G   3% /dev/shm
tmpfs           5.0M  4.0K  5.0M   1% /run/lock
tmpfs            16G     0   16G   0% /run/qemu
/dev/nvme0n1    1.8T  1.2T  543G  69% /home
/dev/nvme1n1p1  511M  138M  374M  27% /boot/efi
tmpfs           3.2G  4.7M  3.1G   1% /run/user/1000
```

We want the one where root partition (/) is mounted, i.e., `/dev/nvme1n1p2`.
Note: Presumably this is the partition we want becuase it contains `/swapfile`.

Then find its UUID via command: `blkid`

```bash
$ blkid
/dev/nvme0n1: LABEL="wd2tb_sn850" UUID="ab63ced0-6d4d-4479-a151-8d07c64cc8d7" BLOCK_SIZE="4096" TYPE="ext4"
/dev/nvme1n1p2: UUID="9a280027-7847-4d87-80b3-d42c0f5292a9" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="e479fdd4-76fe-44b5-a269-51a2823628b7"
```

The one we want matches the filesystem/partition from the previous step. In this case it is: `9a280027-7847-4d87-80b3-d42c0f5292a9`.

To find the physical offset for /swapfile, run the command:

```bash
$ sudo filefrag -v /swapfile
[sudo] password for gbiamby: 
Filesystem type is: ef53
File size of /swapfile is 68719476736 (16777216 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..    2047:    8710144..   8712191:   2048:            
   1:     2048..    4095:    5715968..   5718015:   2048:    8712192:
   2:     4096..    6143:    5722112..   5724159:   2048:    5718016:
   3:     6144..    8191:    4620288..   4622335:   2048:    5724160:
   4:     8192..   10239:    4628480..   4630527:   2048:    4622336:
   5:    10240..   12287:    4632576..   4634623:   2048:    4630528:
   6:    12288..   14335:     817152..    819199:   2048:    4634624:
...
```

Copy the start number under physical\_offset. It’s `8710144` in my case.
Finally, edit the Grub configuration file (or use Grub-Customizer) via the command `sudo gedit` /etc/default/grub\`

Then add `resume=UUID=xxx resume_offset=xxx` as value of `GRUB_CMDLINE_LINUX_DEFAULT`. Also replace ‘xxx’ with the id and/or offset value.
So I add: `resume=UUID=9a280027-7847-4d87-80b3-d42c0f5292a9 resume_offset=8710144`
My final /etc/default/grub entry looks like this: `GRUB_CMDLINE_LINUX_DEFAULT="splash amd_iommu=on resume=UUID=9a280027-7847-4d87-80b3-d42c0f5292a9 resume_offset=8710144 nvidia.modeset=1"`

Then run: `sudo update-grub`

Reboot and see if hibernate works: `systemctl hibernate`

### Enable Hibernate in Power-off menu

`sudo gedit /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla`

Add to file and save:

```
[Re-enable hibernate by default in upower]
Identity=unix-user:*
Action=org.freedesktop.upower.hibernate
ResultActive=yes

[Re-enable hibernate by default in logind]
Identity=unix-user:*
Action=org.freedesktop.login1.hibernate;org.freedesktop.login1.handle-hibernate-key;org.freedesktop.login1;org.freedesktop.login1.hibernate-multiple-sessions;org.freedesktop.login1.hibernate-ignore-inhibit
ResultActive=yes
```

From Ubuntu Software, install Extension Manager.

From extension manager, install "Hibernate Status Button"

Hibernate should now appear in the System -> Power Off / Logout Menu

---

## 2022-01-31 - Chrome setup for hardware acceleration with Nvidia, under Ubuntu 22.04

In the file: `/usr/share/applications/google-chrome.desktop`, don't need anything!
Change the GPU settings in `chrome://flags/`:

* Override software rendering list: Enabled
* GPU rasterization: Enabled
* WebGL Draft Extensions: Enabled
* Zero-copy rasterizer: Enabled
* Desktop PWA Borderless: Enabled
* Preferred Ozone platform: Auto
* Parallel downloading: Enabled
* Enables Out-of-Process Printer Drivers: Enabled
* Hardware decode acceleration for k-SVC VP9: Enabled
* Enables Display Compositor to use a new gpu thread.: Enabled
* Out-of-process 2D canvas rasterization.: Enabled
* Enable raw draw: Enabled

Check effective settings in `chrome://gpu/`. Current output is:

```
Graphics Feature Status
Canvas: Hardware accelerated
Canvas out-of-process rasterization: Enabled
Direct Rendering Display Compositor: Disabled
Compositing: Software only. Hardware acceleration disabled
Multiple Raster Threads: Enabled
OpenGL: Enabled
Rasterization: Hardware accelerated on all pages
Raw Draw: Enabled
Video Decode: Software only. Hardware acceleration disabled
Video Encode: Software only. Hardware acceleration disabled
Vulkan: Disabled
WebGL: Hardware accelerated but at reduced performance
WebGL2: Hardware accelerated but at reduced performance
WebGPU: Disabled
```

I think video decoding needs some nvidia driver like vaapi

According to this Driver 525 breaks vaapi. Vaapi released a new version (0.0.8) which may fix this, however they did not publish a package for Ubuntu. I entered a github issue for it.
<https://github.com/elFarto/nvidia-vaapi-driver/issues/126>

I already enabled the environment variables in `stow_packages/bash/.bashrc_brb`, just waiting for the new ubuntu .deb package.

<https://wiki.archlinux.org/title/Hardware_video_acceleration>

Other links

<https://askubuntu.com/questions/1093954/vainfo-returns-libva-error-usr-lib-x86-64-linux-gnu-dri-i965-drv-video-so-ini>

# Setup AMD GPU Pro Drivers

__Update__: Abandon effort to install amdgpu-pro drivers. Or even the amdgpu ones from the amd website. The reason is (1) the open source one seems to work fine for the most part. The only thing missing is AMF for media encoding, e.g., I cannot use the AMD dGPU for hardware encoding in OBS Studio. (2) Installing amdgpu drivers is straightforward except for the fact that it doesn't work with my version of the linux kernel. I get apt errors when I try to install them. Things related to configuring kms. Seems like it is related to gcc and/or llvm version differences. If I were running a 5.x kernel I think the process would work. Not sure.

## Uninstall Attempts to Install amdgpu:

* Boot into recovery mode (not sure if necessary)
* `sudo amdgpu-install --uninstall && sudo apt --fix-broken install && sudo apt autoremove`
* Make sure amdgpu is NOT blacklisted, and reboot
* Run `glxinfo | grep "OpenGL vendor string" | cut -f2 -d":" | xargs`, it should return "AMD".
* `vainfo` should return clean results and no errors

## Install amdgpu Driver from AMD

<https://amdgpu-install.readthedocs.io/en/latest/install-script.html>
This looks promising: <https://www.reddit.com/r/Amd/comments/rkrbyl/amd_updates_amdgpupro_driver_for_linux_with_a_new/>

<https://askubuntu.com/questions/1417418/unmet-dependencies-ubuntu-22-04-amdgpu-hip-support>

I also ran into this issue after upgrading a machine to 22.04.1 LTS and using an older RX 580 GPU with kernel version 5.15.0-56. In case anyone out there is in my situation and comes here, as of this writing (Dec 2022), the following worked for me:

Use the amdgpu-install version 22.40 from <https://repo.radeon.com/amdgpu-install/22.40/ubuntu/jammy/amdgpu-install_5.4.50401-1_all.deb>

* Install with the command `sudo amdgpu-install --usecase=workstation -y  --opencl=rocr --vulkan=pro --accept-eula --no-32`

* Install the Mesa OpenCL shared library with `sudo apt install -y mesa-opencl-icd`

The `-y` and `--accept-eula` skips the EULA prompt and the apt prompt. `--usecase=workstation`, `--opencl=rocr`, and `--vulkan=pro` install options installs both graphics and OpenCL components, skipping the open-source vulkan. Finally, the `--no-32` skips installing 32-bit components, which was also giving me issues on some attempts.

`mesa-opencl-icd` is required in order to get the library `libMesaOpenCL.so.1` on my system. After installing this, I am able to see my GPU with `clinfo -l`:

```bash
$> sudo clinfo -l
Platform #0: AMD Accelerated Parallel Processing
Platform #1: Clover
`-- Device #0: Radeon RX 580 Series (polaris10, LLVM 13.0.1, DRM 3.49, 5.15.0-56-generic)
Platform #2: Portable Computing Language
 `-- Device #0: pthread-Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz
```

Fixed issue with apt errors by running:

```bash
sudo apt remove libgl1-amdgpu-mesa-dri mesa-amdgpu-va-drivers amdgpu-lib
sudo apt --fix-broken install
sudo apt autoremove
```

Ensure you are using AMDGPU-PRO driver: `glxinfo | grep "OpenGL vendor string" | cut -f2 -d":" | xargs`
If it returns AMD, then you are running open source driver. If it returns Advanced Micro Devices, Inc., then you are running proprietary driver.

If you install or reinstall amdgpu, and then get a blackscreen when rebooting, check `/etc/modprobe.d/blacklist-amdgpu.conf`, make sure it is not blacklisting the amdgpu driver.
