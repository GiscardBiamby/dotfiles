#!/usr/bin/env bash
set -euo pipefail

OUT="ubuntu-health-$(hostname)/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$OUT"

log () { echo "[$(date +%H:%M:%S)] $*"; }

log "System basics"
{
  echo "== uname -a =="; uname -a
  echo; echo "== lsb_release -a =="; lsb_release -a 2>/dev/null || true
  echo; echo "== Kernel cmdline =="; cat /proc/cmdline
  echo; echo "== Uptime =="; uptime -p
} > "$OUT/00_system.txt"

log "Boot & service health"
{
  echo "== Failed systemd units =="; systemctl --failed --no-pager || true
  echo; echo "== Boot critical chain =="; systemd-analyze critical-chain || true
  echo; echo "== Boot time =="; systemd-analyze || true
} > "$OUT/01_systemd.txt"

log "Kernel/driver warnings & errors (current boot)"
{
  echo "== dmesg (err/crit/alert/emerg) =="; dmesg -T --level=err,crit,alert,emerg || true
  echo; echo "== journalctl (current boot, priority<=4) =="; journalctl -b -p 0..4 --no-pager || true
} > "$OUT/02_kernel_errors.txt"

log "Hardware & firmware"
{
  echo "== CPU =="; lscpu
  echo; echo "== Microcode =="; grep -m1 -H . /proc/cpuinfo | sed -n 's/.*microcode.*: *//p' || true
  echo; echo "== BIOS/UEFI =="; sudo dmidecode -t bios 2>/dev/null || true
  echo; echo "== PCI devices of interest =="; lspci -nnk | grep -A3 -E 'VGA|AMD|NVIDIA|Intel Corporation UHD|Network|Non-Volatile memory'
} > "$OUT/03_hardware.txt"

log "CPU frequency driver & governor (Zen3)"
{
  echo "== cpufreq driver =="; cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver 2>/dev/null || echo "N/A"
  echo; echo "== governors =="; cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null | sort -u || echo "N/A"
  echo; echo "== amd_pstate status =="; cat /sys/devices/system/cpu/amd_pstate/status 2>/dev/null || echo "N/A"
  echo; echo "== amd_pstate params =="; grep . /sys/module/amd_pstate/parameters/* 2>/dev/null || true
} > "$OUT/04_cpu_freq.txt"

log "Memory, swap, zswap/zram"
{
  echo "== free -h =="; free -h
  echo; echo "== swapon =="; swapon --show
  echo; echo "== zswap =="; grep . /sys/module/zswap/parameters/* 2>/dev/null || true
  echo; echo "== zram =="; lsblk -o NAME,TYPE,SIZE,MOUNTPOINT | grep -i zram || true
} > "$OUT/05_memory_swap.txt"

log "GPU & display (Wayland)"
{
  echo "== Kernel DRM/amdgpu messages (boot) =="; journalctl -b | grep -iE 'amdgpu|drm|gpu|graphics|vulkan' || true
  echo; echo "== Current session (user) Wayland/desktop logs =="; journalctl --user -b | grep -iE 'wayland|gnome-shell|kwin_wayland|sway' || true
  echo; echo "== Mesa / GL (if installed) =="; command -v glxinfo >/dev/null && glxinfo -B || echo "glxinfo not installed (mesa-utils)"
  echo; echo "== Vulkan (if installed) =="; command -v vulkaninfo >/dev/null && vulkaninfo --summary || echo "vulkan-tools not installed"
  echo; echo "== Monitors =="; command -v hwinfo >/dev/null && sudo hwinfo --monitor 2>/dev/null || true
} > "$OUT/06_gpu_display.txt"

log "Disks & filesystems"
{
  echo "== lsblk =="; lsblk -f
  echo; echo "== mount =="; mount | sort
} > "$OUT/07a_storage.txt"

log "Disks & filesystems"
{
  echo "== lsblk =="; lsblk -f
  echo; echo "== mount =="; mount | sort
  echo; echo "== SMART summary =="; 
    for d in /dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1; do 
    echo "--- $d ---"; sudo smartctl -H "$d" 2>/dev/null || true; 
    done

    echo; echo "== SMART details (nvme) =="; 
    for n in /dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1; do 
    echo "--- $n ---"; sudo smartctl -a "$n" 2>/dev/null || true; 
    done
  echo; echo "== EXT4/XFS errors in logs =="; journalctl -b | grep -iE 'EXT4-fs error|xfs_(warning|error)' || true
} > "$OUT/07_storage.txt"

log "Network"
{
  echo "== ip =="; ip -br addr
  echo; echo "== routes =="; ip route
  echo; echo "== DNS in use =="; resolvectl status || systemd-resolve --status 2>/dev/null || true
  echo; echo "== NTP sync =="; timedatectl status
  echo; echo "== Interfaces stats (ethtool) =="; for i in $(ls /sys/class/net); do echo "--- $i ---"; sudo ethtool -S "$i" 2>/dev/null | egrep -i 'err|drop|crc|fault' || true; done
} > "$OUT/08_network.txt"

log "Security & integrity"
{
  echo "== Secure Boot =="; mokutil --sb-state 2>/dev/null || echo "mokutil not installed"
  echo; echo "== Spectre/Meltdown mitigations =="; grep . /sys/devices/system/cpu/vulnerabilities/* 2>/dev/null
  echo; echo "== AppArmor =="; sudo aa-status 2>/dev/null || true
} > "$OUT/09_security.txt"

log "Desktop & audio services (common culprits)"
{
  echo "== Failed user services =="; systemctl --user --failed --no-pager || true
  echo; echo "== PipeWire/Pulse =="; systemctl --user status pipewire.service pipewire-pulse.service wireplumber.service --no-pager || true
  echo; echo "== Tracker/miners (status/masked) =="; systemctl --user status tracker-miner-fs-3.service tracker-extract-3.service --no-pager || true
} > "$OUT/10_desktop_audio.txt"

log "Timers & scheduled jobs"
{
  systemctl list-timers --all --no-pager
} > "$OUT/11_timers.txt"

log "Recent OOM kills & segfaults (last 7 days)"
{
  journalctl --since "7 days ago" | grep -iE 'Out of memory: Kill process|oom-killer|segfault' || true
} > "$OUT/12_oom_segfaults.txt"

log "Unit-specific: NFS & other services you mentioned"
{
  echo "== List automounts =="; systemctl list-units --type=automount --all --no-pager
  echo; echo "== NFS mount attempts (last boot) =="; journalctl -b | grep -iE 'nfs|rpc.statd|mount|automount' || true
  echo; echo "== adguard/openrazer units if present =="; systemctl status adguard.service openrazer-daemon.service --no-pager 2>/dev/null || true
} > "$OUT/13_specific_units.txt"

log "Thermals & sensors (if sensors configured)"
{
  command -v sensors >/dev/null && sensors || echo "lm-sensors not installed or not configured"
  echo; echo "== GPU temps (amdgpu paths) ==";
    find /sys/class/drm -path "*/device/hwmon/hwmon*/temp*_input" -type f 2>/dev/null | while read -r f; do
    printf "%s: " "$f"
    awk '{printf "%.1f°C\n", $1/1000}' "$f"
    done
} > "$OUT/14_thermals.txt"

log "Package/stack versions likely relevant"
{
  echo "== Kernel =="
  uname -r
  echo; echo "== Mesa/graphics stack =="; dpkg -l | grep -E 'mesa|amdgpu|vulkan' || true
  echo; echo "== PipeWire =="; dpkg -l | grep -E '^ii\s+pipewire|^ii\s+wireplumber' || true
} > "$OUT/15_versions.txt"

log "Done. Files in $OUT/"
tar -czf "$OUT.tar.gz" "$OUT"
echo "Archive created: $OUT.tar.gz"
