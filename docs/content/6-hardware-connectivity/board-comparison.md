# IP-KVM Board Comparison: Sipeed NanoKVM vs Radxa Zero 3W / 3E vs Radxa Cubie A7Z

USBridge firmware turns three different boards into the same IP-KVM: same [client apps](../7-software-access/desktop-app.md), same [Moonlight streaming](../2-kvm-vkm/video-streaming-quality.md), same [REST API](../10-developer-api/rest-api-reference.md), same OTA updates. What differs is the hardware underneath: how the HDMI signal gets in (MIPI or USB), how much CPU and RAM is left for OCR and AI, and how sound reaches you. This page puts them side by side so you can pick the right one, whether you're building a DIY KVM or reflashing a NanoKVM you already own.

**In short:**

* **Lowest latency, smallest budget:** [Sipeed NanoKVM](./nanokvm.md). HDMI capture over MIPI, hardware H.264 at 1080p60. No BIOS-in-Terminal, sound over USB only.
* **Full feature set, best value:** **Radxa Zero 3W / 3E**. 4 cores, an NPU for OCR, eMMC. Capture over a USB dongle (+10–15 ms), MIPI capture is coming.
* **Most CPU headroom:** **Radxa Cubie A7Z**. 8 cores; OCR runs on the CPU. Capture over a USB dongle (+10–15 ms), MIPI capture is coming.
* **Nothing to assemble:** [USBridge KVM 2.0](https://www.usbridge.io/hardware-agent/?utm_campaign=board-comparison&utm_medium=docs&utm_source=github#buy-usbridge-kvm-2-0), the turnkey appliance built on the Radxa Zero 3W.

---

## 1. Hardware

| | **Sipeed NanoKVM** | **Radxa Zero 3W / 3E** | **Radxa Cubie A7Z** |
| :--- | :--- | :--- | :--- |
| **SoC** | SOPHGO SG2002 | Rockchip RK3566 | Allwinner A733 |
| **CPU** | 1 × RISC-V C906, 1 GHz (runs at 850 MHz) | 4 × ARM Cortex-A55 | 8 cores (2 × Cortex-A76 + 6 × Cortex-A55) |
| **RAM** | 256 MB (~158 MB for Linux, the rest is reserved for video) | 1–2 GB LPDDR4X | Several RAM options |
| **AI accelerator used by USBridge** | — | NPU (RKNN) for OCR | — (OCR on the CPU) |
| **HDMI capture** | Built in: HDMI → MIPI CSI (LT6911) | External USB (UVC) capture card · MIPI planned | External USB (UVC) capture card · MIPI planned |
| **Network** | 100 Mbit Ethernet | 3W: Wi-Fi · 3E: Ethernet | Wi-Fi 6 |
| **Boot / storage** | microSD only | microSD or onboard eMMC (Install to eMMC) | microSD only (eMMC not enabled yet) |
| **Front-panel display** | ✅ NanoKVM's I2C OLED | 3W: ✅ · 3E: not supported yet | ✅ |
| **ATX power control** | ✅ Sipeed ATX-B board | ✅ [Power management module](./power-management-module-control.md) | ✅ [Power management module](./power-management-module-control.md) |
| **Firmware download** | [usbridge.io/hardware-agent](https://www.usbridge.io/hardware-agent/) | [usbridge.io/hardware-agent](https://www.usbridge.io/hardware-agent/) | [usbridge.io/hardware-agent](https://www.usbridge.io/hardware-agent/) |

---

## 2. Video Latency and Streaming

Latency is where the boards differ the most, and it comes down to how the picture gets in.

| | **Sipeed NanoKVM** | **Radxa Zero 3W / 3E** | **Radxa Cubie A7Z** |
| :--- | :--- | :--- | :--- |
| **Capture path** | MIPI CSI → hardware scaler → encoder, no CPU copy | USB capture card → USB → encoder | USB capture card → USB → CPU colour conversion → encoder |
| **Capture → encoded frame** | **~20 ms** (measured, 1080p60) | MIPI + **10–15 ms** | MIPI + **10–15 ms** |
| **Latency rank** | 🥇 **Lowest** | 🥈 Low | 🥈 Low |
| **Max mode** | 1080p60 | Set by the capture card (e.g. 1080p60 on USB 3.0 MS2130, 720p60 / 1080p30 on the bundled dongle) | Set by the capture card |
| **Hardware encoder** | H.264 | H.264, HEVC | H.264 |
| **Moonlight** | ✅ | ✅ | ✅ |
| **Web client (WebRTC)** | ✅ | ✅ | ✅ |

**Why MIPI wins:** a USB capture card has to compress or pack each frame, push it over USB and hand it to the SoC, which then decodes or converts it before encoding. On the NanoKVM the HDMI bridge feeds the SoC's camera interface directly and the frame goes to the hardware encoder without the CPU touching a pixel. MIPI capture for the Radxa boards is in development and will remove those extra 10–15 ms.

On top of the capture figures comes the network: on wired LAN or Wi-Fi 6 the whole glass-to-glass path is typically **under 50 ms** on every board (see [Video Streaming & Quality §4](../2-kvm-vkm/video-streaming-quality.md#4-latency)).

---

## 3. Audio

| | **Sipeed NanoKVM** | **Radxa Zero 3W / 3E** | **Radxa Cubie A7Z** |
| :--- | :--- | :--- | :--- |
| **Target's sound** | **USB only**: the KVM is a USB sound card on the target; pick it as the playback device | HDMI audio from the capture card | HDMI audio from the capture card |
| **Your microphone into the target** | ✅ | ✅ | ✅ |
| **MIDI into the target** | ✅ | ✅ | ✅ |

On the NanoKVM, sound before the target's OS loads its USB audio driver (BIOS beeps, boot chimes) is not heard. See [Audio Redirection](../2-kvm-vkm/audio-redirection.md).

---

## 4. Features

| Feature | **Sipeed NanoKVM** | **Radxa Zero 3W / 3E** | **Radxa Cubie A7Z** |
| :--- | :---: | :---: | :---: |
| Keyboard, mouse, absolute pointer, touch/pen | ✅ | ✅ | ✅ |
| [Gamepad (XInput)](../2-kvm-vkm/gamepad.md) | ✅ | ✅ | ✅ |
| [Virtual media](../5-remote-disk-image-mounting/mounting-iso-images.md) (ISO, qcow2, VDI/VMDK, whole drives) | ✅ USB 2.0, ~26 MB RAM cache | ✅ up to 1 GB RAM cache | ✅ up to 1 GB RAM cache |
| [Immutable Btrfs snapshots](../4-snapshots-state-management/snapshots-overview.md) | ✅ | ✅ | ✅ |
| [BIOS-in-Terminal (SSH + OCR)](../3-bios-in-terminal/technology-overview.md) | — | ✅ NPU-accelerated | ✅ on the CPU |
| AI Vision / [MCP screen reading](../3-bios-in-terminal/mcp-ai-agents.md) | — | ✅ | ✅ |
| [Starlark scripting on screen text](../3-bios-in-terminal/scripting-automation.md) | — | ✅ | ✅ |
| [Tailscale, zero port forwarding](../2-kvm-vkm/network.md) | ✅ | ✅ | ✅ |
| Setup over the USB cable (`10.55.0.1`) | ✅ | ✅ | ✅ |
| A/B OTA updates with rollback | ✅ | ✅ | ✅ |
| Power & performance settings (CPU/NPU/encoder caps) | — | ✅ | ✅ |

---

## 5. Which One Should I Get?

| You want… | Pick |
| :--- | :--- |
| The snappiest mouse and the lowest video latency, today | **Sipeed NanoKVM** |
| BIOS screens as text over SSH, AI agents, Starlark automation | **Radxa Zero 3W / 3E** or **Cubie A7Z** |
| eMMC boot, so the microSD card only holds snapshots | **Radxa Zero 3W / 3E** |
| The most CPU left over for OCR and future features | **Radxa Cubie A7Z** |
| A finished box with display, cooling and Wi-Fi, flashed and ready | **[USBridge KVM 2.0](https://www.usbridge.io/hardware-agent/?utm_campaign=board-comparison&utm_medium=docs&utm_source=github#buy-usbridge-kvm-2-0)** |

Ready to build one? See the [DIY setup in the main README](../../../README.md#diy-kvm-setup-full-bios-control-in-3-minutes), the [Recovery Flashing Guide](../9-updates-changelog/recovery-flashing-guide.md) for every board, and the [NanoKVM page](./nanokvm.md) for reflashing a NanoKVM. Firmware for every board, and the ready-made KVM 2.0, are on [usbridge.io/hardware-agent](https://www.usbridge.io/hardware-agent/).
