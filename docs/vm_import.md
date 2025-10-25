```bash
sudo apt update
sudo apt install \
  virt-manager \
  libvirt-daemon-system libvirt-clients \
  qemu-system-x86 qemu-utils \
  ovmf \
  swtpm swtpm-tools \
  bridge-utils \
  virtinst \
  guestfs-tools \
  virtiofsd


```

Enable services:

```bash
sudo systemctl enable --now libvirtd
sudo usermod -aG libvirt,kvm $(whoami)
newgrp libvirt
newgrp kvm
# You have to reboot for the groups to take effect
```

Verify kvm acceleration:

```bash
lscpu | grep -i virtualization
lsmod | grep -E 'kvm_(intel|amd)'

# Example of good output, AMD-V cpu capability is there, and the kvm_amd module is loaded
Virtualization:                          AMD-V
kvm_amd               249856  0
kvm                  1466368  1 kvm_amd
ccp                   159744  1 kvm_amd

```

## Repoint the built-in "default" pool to `/data/vms`

```bash
sudo mkdir -p /data/vms
# libvirt needs to read/write here
sudo chown -R libvirt-qemu:kvm /data/vms
sudo chmod 0750 /data/vms

# If a default pool already exists, stop and undefine it
sudo virsh pool-destroy default 2>/dev/null || true
sudo virsh pool-undefine default 2>/dev/null || true

# Recreate "default" pool pointing at /data/vms
sudo virsh pool-define-as --name default --type dir --target /data/vms
sudo virsh pool-start default
sudo virsh pool-autostart default

# Verify
virsh pool-list --all
virsh pool-info default
```

## 1) Recreate the default NAT network exactly like your old XML

This keeps virbr0 as a NAT’d network 192.168.122.0/24 with dnsmasq, just like before.

No conflict with your br0: you can run both. Attach a VM either to network='default' (NAT) or bridge='br0' (LAN).

```bash
# If a default network exists, remove it first
sudo virsh net-destroy default 2>/dev/null || true
sudo virsh net-undefine default 2>/dev/null || true

# Define from your old XML (preserves UUID, MAC, IP/DHCP, virbr0)
sudo virsh net-define /tmp/default-net.xml
sudo virsh net-autostart default
sudo virsh net-start default

# Verify
virsh net-info default
ip addr show virbr0
```

```bash
# Stop & remove any existing 'default' pool definition
sudo virsh pool-destroy default 2>/dev/null || true
sudo virsh pool-undefine default 2>/dev/null || true


# Create /data/vms and set sane permissions
sudo chown -R libvirt-qemu:kvm /data/vms
sudo chmod 0750 /data/vms
sudo chown libvirt-qemu:kvm /data/vms/*.qcow2 /data/vms/*.img  || true
sudo chmod 0640 /data/vms/*.qcow2 /data/vms/*.img || true

# Make a pool XML at /tmp/default-pool.xml (edit UUID if you want to re-use your old one)
# Simplest operationally: make /data/vms owned by libvirt-qemu:kvm with 0750, and ensure all images are libvirt-qemu:kvm and 0640.
cat <<'EOF' | sudo tee /tmp/default-pool.xml
<pool type='dir'>
  <name>default</name>
  <uuid>faedab32-e0bf-49dd-adcd-1192ede98aae</uuid> <!-- keep your old pool UUID -->
  <target>
    <path>/data/vms</path>
    <permissions>
      <mode>0750</mode>   <!-- matches your old pool’s dir mode -->
      <owner>0</owner>    <!-- root -->
      <group>0</group>    <!-- root -->
    </permissions>
  </target>
</pool>
EOF


# Define, build, start, autostart
sudo virsh pool-define /tmp/default-pool.xml
sudo virsh pool-build default
sudo virsh pool-start default
sudo virsh pool-autostart default
```

```bash
# Define from XML
sudo virsh define /home/gbiamby/proj/vms/libvirt-backup/domains/win10-hems.xml

# Sanity check
virsh dominfo win10-hems
virsh dumpxml win10-hems | sed -n '1,120p'

# Start
sudo virsh start win10-hems

# Confirm disk & NIC attached as expected
virsh domblklist win10-hems
virsh domiflist win10-hems

```










--- 






Machine type 

```bash
➜  brb:~/dotfiles/scriptsqemu-system-x86_64 -machine help | grep q35
pc-q35-zesty         Ubuntu 17.04 PC (Q35 + ICH9, 2009)
pc-q35-yakkety       Ubuntu 16.10 PC (Q35 + ICH9, 2009)
ubuntu-q35           Ubuntu 25.10 PC (Q35 + ICH9, 2009) (alias of pc-q35-questing)
pc-q35-questing      Ubuntu 25.10 PC (Q35 + ICH9, 2009)
pc-q35-plucky        Ubuntu 25.04 PC (Q35 + ICH9, 2009)
pc-q35-oracular      Ubuntu 24.10 PC (Q35 + ICH9, 2009)
pc-q35-noble         Ubuntu 24.04 PC (Q35 + ICH9, 2009)
pc-q35-mantic-maxcpus Ubuntu 23.10 PC (Q35 + ICH9, maxcpus=1024, 2009)
pc-q35-mantic        Ubuntu 23.10 PC (Q35 + ICH9, 2009)
pc-q35-mantic-hpb-maxcpus Ubuntu 23.10 PC (Q35 + ICH9, +host-phys-bits=true, maxcpus=1024, 2009)
pc-q35-mantic-hpb    Ubuntu 23.10 PC (Q35 + ICH9, +host-phys-bits=true, 2009)
pc-q35-lunar         Ubuntu 23.04 PC (Q35 + ICH9, 2009)
pc-q35-lunar-hpb     Ubuntu 23.04 PC (Q35 + ICH9, +host-phys-bits=true, 2009)
pc-q35-kinetic       Ubuntu 22.10 PC (Q35 + ICH9, 2009)
pc-q35-kinetic-hpb   Ubuntu 22.10 PC (Q35 + ICH9, +host-phys-bits=true, 2009)
pc-q35-jammy-maxcpus Ubuntu 22.04 PC (Q35 + ICH9, maxcpus=1024, 2009)
pc-q35-jammy         Ubuntu 22.04 PC (Q35 + ICH9, 2009)
...
```


Short answer: you don’t have to change it—**run it first with the original `pc-q35-6.2`**. It’s listed on your host (deprecated but supported), which is ideal for a smooth migration. If it boots and everything works, you can leave it there. If you want to modernize later, bumping to a newer q35 (e.g. `pc-q35-10.1`) is fine—just do it deliberately.

## What changing the machine type does (and why to be cautious)

* It updates the *virtual chipset/board version*. Windows may re-enumerate some devices (PCI paths can shift), sometimes triggering driver re-installs or activation checks.
* Keeping the **same** machine type avoids those surprises.
* Newer q35 can bring small fixes/features, but there’s usually no performance gain worth risking a migration hiccup.

## Recommended path

1. **Define and boot as-is** (keep `machine='pc-q35-6.2'`).
   If it starts cleanly, you’re done.

2. **(Optional) Upgrade later** to `pc-q35-10.1` (or `q35` which aliases to the latest) **only after** you’ve confirmed the VM is healthy. Do this with the VM shut down and after taking a snapshot/backup.

### Commands

**Run with the current machine type:**

```bash
# define and start (as you already planned)
sudo virsh define /path/to/win10-hems.xml
sudo virsh start win10-hems
```

**If you decide to upgrade the machine type later:**

```bash
# 1) shutdown and snapshot (optional but smart)
sudo virsh shutdown win10-hems
sudo virsh snapshot-create-as --domain win10-hems pre-q35-upgrade

# 2) edit the domain XML
sudo virsh edit win10-hems
# change:
#   <type arch='x86_64' machine='pc-q35-6.2'>hvm</type>
# to:
#   <type arch='x86_64' machine='pc-q35-10.1'>hvm</type>

# 3) start it back up
sudo virsh start win10-hems
```

## If you’re not sure whether the guest is Win10 or Win11

* **Win11** normally needs **UEFI + TPM 2.0**. If your XML is BIOS (no OVMF loader) and no TPM device, it’s likely **Win10**.
* You can quickly check whether the disk has an EFI System Partition:

  ```bash
  sudo apt install guestfs-tools
  virt-filesystems -a /data/vms/win10.qcow2 -l | grep -i efi
  ```

  If you see an EFI partition, it’s UEFI; otherwise likely BIOS.

## TL;DR

* Keep `pc-q35-6.2` for the first boot (safest).
* If you want, upgrade to `pc-q35-10.1` later with the VM off and after a snapshot.
