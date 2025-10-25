# BRB: Netplan + WoL Quick Setup

This is a short, repeatable checklist to recreate my **bridge + failover** network and **Wake‑on‑LAN** on Ubuntu (GNOME, NetworkManager).

---

## 1) Netplan: bridge on Aquantia, Realtek for WoL

Create `/etc/netplan/01-br0.yaml` with **root-only** permissions:

```bash
sudo tee /etc/netplan/01-br0.yaml >/dev/null <<'YAML'
network:
  version: 2
  renderer: NetworkManager

  ethernets:
    # Aquantia (10GbE) – *no IP here*, it will be a bridge port
    aqua0:
      dhcp4: false
      dhcp6: false
      link-local: []

    # Realtek (WoL NIC) – disabled by default; can be enabled for manual failover
    wol0:
      dhcp4: true
      dhcp6: true
      link-local: [ipv6]     # allow IPv6 link-local; avoid IPv4 169.254.* noise
      optional: true
      nameservers:
        search: [asgardgb.com]
      routes:
        - to: 0.0.0.0/0
          via: 10.87.0.1
          metric: 500        # higher metric -> prefer br0 when both are up

  bridges:
    br0:
      interfaces: [aqua0]
      dhcp4: true
      dhcp6: false
      macaddress: 00:23:a4:0e:09:84   # use the Aquantia MAC for stable DHCP reservation
      parameters:
        stp: false
        forward-delay: 0
      nameservers:
        search: [asgardgb.com]
YAML

sudo chmod 600 /etc/netplan/01-br0.yaml
```

Apply it:

```bash
sudo netplan generate
sudo netplan apply
```

**Expected state**

- `br0` gets the primary IP (e.g. `10.87.0.20`) via DHCP.
- `aqua0` is a bridge **port** (no IP).
- `wol0` is present, but we’ll keep it from auto-connecting.

Check:

```bash
ip -br a | egrep '^(br0|aqua0|wol0)'
nmcli device status
```

---

## 2) Make Realtek (wol0) **not autoconnect**

We keep `wol0` configured but **off by default**, so the system always prefers `br0`. You can still flip `wol0` **on** in GNOME Settings if you ever need manual failover.

```bash
# Find the NM connection names created by netplan
nmcli connection show

# Turn off autoconnect for wol0
sudo nmcli connection modify netplan-wol0 connection.autoconnect no
```

**GUI behavior:** In GNOME Settings → Network, `wol0` will appear **Disabled**. If Aquantia/`br0` ever dies, you may toggle `wol0` **On** there to regain connectivity. When both are on, routing prefers `br0` thanks to the lower metric on `br0`.

---

## 3) Wake‑on‑LAN (WoL)

### Verify WoL support & status

```bash
sudo ethtool wol0 | grep -i 'Wake-on'
# Should show: Supports Wake-on: pumbg  /  Wake-on: g
```

### (Optional) Persist WoL across reboots

Some drivers reset WoL after a cold boot. Install a tiny systemd unit:

```bash
sudo tee /etc/systemd/system/enable-wol@.service >/dev/null <<'UNIT'
[Unit]
Description=Enable Wake-on-LAN on %i
After=network-pre.target
Before=network.target

[Service]
Type=oneshot
ExecStart=/usr/sbin/ethtool -s %i wol g

[Install]
WantedBy=multi-user.target
UNIT

sudo systemctl enable --now enable-wol@wol0.service
```

**Notes**

- WoL also requires it to be **enabled in BIOS/UEFI** (e.g. _Wake on PCIe/PME_).
- Disabling the interface in GNOME does **not** stop WoL; the NIC still listens for magic packets if BIOS and `ethtool` show WoL enabled.

---

## 4) Quick troubleshooting

```bash
# Who is up and what IPs?
ip -br a

# NM connection states
nmcli device status
nmcli connection show

# Ensure br0 is default route
ip route

# Check WoL again
sudo ethtool wol0 | grep -i 'Wake-on'
```

**Common fixes**

- If `wol0` keeps coming up automatically: re-run  
  `sudo nmcli con mod netplan-wol0 connection.autoconnect no`
- If `br0` doesn’t get DHCP: check the switch/cable and DHCP reservation for MAC `00:23:a4:0e:09:84`.
- If WoL fails: verify BIOS WoL/PCIe power settings and that ErP/Deep Sleep isn’t cutting NIC standby power.
