# 🎧 Ubuntu Audio Optimization Guide (Blue Yeti + Realtek ALC897)

This guide summarizes all final changes and optimizations you applied to your Ubuntu 24.04 / PipeWire audio setup, to be reused on a new Ubuntu 25.10 installation.

---

## 🧩 Hardware Setup

- **Output device:** Blue Yeti USB Microphone (headphones connected to its 3.5 mm jack)
- **Mic input:** Blue Yeti built‑in microphone
- **Onboard sound:** Realtek ALC897 (used for speakers)

---

## ⚙️ System Overview

- Audio system: **PipeWire** (replaces PulseAudio)
- GUI control: **EasyEffects** for EQ + Limiter
- Purpose: Correct channel swap, improve quality, optimize output, and fix Yeti headphone volume

---

## ✅ 1. PipeWire Audio Configuration

Create or edit:

`~/.config/pipewire/pipewire-pulse.conf.d/10-pulse-format.conf`

```ini
pulse.cmd = [
  { cmd = "update-props"
    args = {
      audio.format = "F32"
      audio.rate   = 48000
    }
  }
]
```

→ Mixes and resamples audio at **32‑bit float, 48 kHz** for clean internal processing.
The sound card does 24bit, but mixing at 32 preserves quality

---

### (Optional) Global quality tuning

`~/.config/pipewire/pipewire.conf.d/10-audio-quality.conf`

```ini
context.properties = {
    default.clock.rate          = 48000
    default.clock.allowed-rates = [ 44100 48000 ]
    default.clock.quantum       = 1024
    default.clock.min-quantum   = 256
    resample.quality            = 9
    log.level                   = 2
}
```

If you do tasks like monitoring live audio, you may benefit by reducing buffer sizes:

In `10-audio-quality.conf `you set `default.clock.quantum = 1024`; you might reduce to `512` or `256` if no clicks/pops.

Use `default.clock.min-quantum = 128` to allow lower latency.
Caution: Lower buffers increase risk of underruns. Check stability.

---

## 🔁 2. Channel Swap (Realtek Speakers)

system uses wireplumber.conf.d:

```bash
mkdir -p ~/.config/wireplumber/wireplumber.conf.d
nano ~/.config/wireplumber/wireplumber.conf.d/51-swap-channels.conf
```

```bash
monitor.alsa.rules = [
  {
    matches = [
      { node.name = "alsa_output.pci-0000_1a_00.6.analog-stereo" }
    ]
    actions = {
      update-props = {
        audio.position = [ "FR", "FL" ]
      }
    }
  }
]
```

```bash
systemctl --user restart wireplumber
```

Verify that it’s applied

```bash
# Get the new node id
wpctl status | sed -n '/Sinks:/,/Sources:/p'

# Replace N with the new ID of your Realtek sink (likely different)
pw-cli enum-params N 2 | grep -A2 "audio.position"
```

---

## 🎛️ 3. Blue Yeti Configuration

---

## 🎚️ 4. EasyEffects Setup

### A. Limiter (Herm Thin)

| Setting       | Value     |
| ------------- | --------- |
| Mode          | Herm Thin |
| Oversampling  | 2×        |
| Attack        | 5 ms      |
| Release       | 50 ms     |
| Threshold     | –1 dB     |
| Boost         | ON        |
| Auto‑leveling | OFF       |

→ Transparent peak protection with no distortion.

---

### B. Equalizer

- **Number of Bands:** 10
- **Quality (Q):** ~1.0 – 1.4 for smooth shaping
- **Input Gain (Preamp):** –2 dB (acts as pre‑EQ headroom)
- **Output Gain:** 0 dB

#### Importable GraphicEQ Preset (`Realtek_Clean_Chain.txt`)

```
GraphicEQ: 60 2.5; 120 1.5; 500 -1.5; 2000 1.0; 6000 1.5; 9400 2.0
```

| Frequency | Gain (dB) | Effect     |
| --------- | --------- | ---------- |
|  60 Hz    |  +2.5     |  Warmth    |
|  120 Hz   |  +1.5     |  Body      |
|  500 Hz   |  –1.5     |  Less mud  |
|  2 kHz    |  +1.0     |  Presence  |
|  6 kHz    |  +1.5     |  Clarity   |
|  9.4 kHz  |  +2.0     |  Air       |

Chain order in EasyEffects:

```
Equalizer → Limiter → Output Device
```

Save preset as `Realtek_Clean_Chain` and link it to your chosen output device.

---

## 🪄 5. General EasyEffects Preferences

| Setting                    | Recommended |
| -------------------------- | ----------- |
| Launch Service at Startup  | ✅ On       |
| Process All Output Streams | ✅ On       |
| Shutdown on Window Closing | ❌ Off      |
| Ignore Monitor Streams     | ✅ On       |
| Cubic Volume               | Optional    |

Presets are now auto‑linked per device instead of “load last preset.”

---

```bash
# Restart audio stack safely
systemctl --user restart wireplumber pipewire pipewire-pulse
```

---

## ✅ Summary of Effects Chain

| Step | Tool                    | Key Settings                       |
| ---- | ----------------------- | ---------------------------------- |
| 1    | PipeWire                | 32‑bit float @ 48 kHz              |
| 2    | WirePlumber             | Channel swap + Yeti analog profile |
| 3    | EasyEffects EQ          | Gentle 6‑band tone curve           |
| 4    | EasyEffects Limiter     | Herm Thin, –1 dB threshold         |
| 5    | ALSA / PipeWire volumes | Full gain, analog path             |

---

🎉 **Result:**  
Natural, full‑range sound on both Realtek ALC897 speakers and Blue Yeti headphone output; proper channel orientation, no clipping, and clean, balanced loudness across apps.

---

```bash
mkdir -p ~/.config/pipewire/media-session.d
nano ~/.config/pipewire/media-session.d/bluez-monitor.conf
```

```bash
bluez-monitor = {
    properties = {
        # Auto switch to headset profile when mic is used
        "bluez5.autoswitch-profile" = true
        # Show debug info if needed
        "bluez5.enable-sbc-xq" = true
        "bluez5.enable-msbc" = true
        "bluez5.enable-hw-volume" = true
        # Enable modern high-quality codecs
        "bluez5.codecs" = [ sbc sbc_xq aac ldac aptx aptx_hd lc3 ]
    }
}
```

```
systemctl --user restart pipewire pipewire-pulse wireplumber
```

Now reconnect your Bluetooth headphones, then run:

```bash
wpctl inspect @DEFAULT_AUDIO_SINK@
```

## Optional: Auto-switch profiles between Music / Mic

When you join a call, most headsets switch to HFP/HSP, which sounds worse.
PipeWire can automatically switch back when the mic stops being used.

```bash
mkdir -p ~/.config/wireplumber/wireplumber.conf.d
nano ~/.config/wireplumber/wireplumber.conf.d/52-bt-auto-switch.conf
```

```bash
wireplumber.settings = {
  bluez5.autoswitch-profile = true
}
```

```bash
systemctl --user restart wireplumber
```

Now reconnect your Bluetooth headphones, then run:

```bash
wpctl inspect @DEFAULT_AUDIO_SINK@

# * Look for lines like:
# device.profile.name = "a2dp-sink-ldac"
# device.codec = "ldac"
```

If you see `headset-head-unit` or` hsp/hfp`, that’s the lower-quality mic mode.
