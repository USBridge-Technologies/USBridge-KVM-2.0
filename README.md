# USBridge KVM 2.0 | Ultra-Low Latency IP KVM

<div align="center">
<img src="asset/1.png" width="1400" alt="USBridge IP KVM 2.0 - Remote Access at Level 0">

<p align="center">
  <b>Remote access at Level 0. Zero latency. Absolute hardware autonomy.</b><br>
  The Software Agent works while the system is alive. KVM 2.0 goes below it — all in one unified USBridge Client.
</p>

[![Website](https://img.shields.io/badge/USBridge-WEBSITE-black)](https://www.usbridge.io/hardware-agent/)
[![Web Client](https://img.shields.io/badge/Web_Client-web.usbridge.io-blue)](https://web.usbridge.io)
[![Documentation](https://img.shields.io/badge/Docs-README-orange)](./docs/README.md)
[![YouTube](https://img.shields.io/badge/YouTube-@KVMUSBridge-FF0000?logo=youtube&logoColor=white)](https://www.youtube.com/@KVMUSBridge)
[![X / Twitter](https://img.shields.io/badge/X-@USBridgeKVM-black?logo=x&logoColor=white)](https://x.com/USBridgeKVM)
[![Discord](https://img.shields.io/badge/Discord-Community-7289DA?logo=discord&logoColor=white)](https://discord.gg/XwNpCrGfsB)
[![Reddit](https://img.shields.io/badge/Reddit-r%2FUSBridge-FF4500?logo=reddit&logoColor=white)](https://www.reddit.com/r/USBridge/)
</div>

---

## Overview

**System frozen or won't boot? The KVM is still there.**

The **USBridge KVM 2.0** is an out-of-band remote management appliance operating at hardware Level 0. Whether you need BIOS/UEFI setup, boot-loader rescue, an OS reinstallation, or remote reboot of an unresponsive bare-metal server, USBridge KVM bypasses the host operating system entirely.

Engineered with the **Moonlight streaming protocol**, it delivers smooth **1080p @ 60 FPS** with **~45 ms ultra-low latency**, peripheral passthrough, hardware-isolated immutable Btrfs storage snapshots, and an on-device OCR engine with an MCP server for autonomous AI administration.

---

## Choose Your KVM: Four Devices, One KVM OS

Every edition runs the same unified USBridge KVM OS with regular OTA updates, REST API, Moonlight engine, and client compatibility.

<div align="center">
<img src="asset/kvm-lineup-devices.png" width="1400" alt="USBridge KVM Lineup: Nano, Low, Standard, and Full">
</div>

| Feature | **USBridge Nano** | **USBridge KVM 2.0 Low** | **USBridge KVM 2.0 Standard** | **USBridge KVM 2.0 Full** |
| :--- | :---: | :---: | :---: | :---: |
| **Target Use** | Ultra-compact pocket KVM | Minimalist board for server racks | Complete ready-to-run desktop kit | Ultimate Pro kit with ATX & screen |
| **Price** | **$89** | **$99** | **$117** | **$139** |
| **Base Board** | Sipeed NanoKVM (SG2002) | Radxa Zero 3W | Radxa Zero 3W | Radxa Zero 3W |
| **Processor** | 1 RISC-V core @ 1.0 GHz | 4 Cortex-A55 cores @ 1.6 GHz | 4 Cortex-A55 cores @ 1.6 GHz | 4 Cortex-A55 cores @ 1.6 GHz |
| **RAM** | 256 MB DDR3 | 1 GB LPDDR4 | 1 GB LPDDR4 | 1 GB LPDDR4 |
| **Video Capture** | Built-in HDMI (MIPI CSI) | USB 3.0 Dongle (1080p 60 FPS) | USB 3.0 Dongle (1080p 60 FPS) | USB 3.0 Dongle (1080p 60 FPS) |
| **Video Stream** | 1080p @ 60 FPS | 1080p @ 60 FPS | 1080p @ 60 FPS | 1080p @ 60 FPS |
| **Network** | Ethernet port (RJ45) | Wi-Fi 6 (Ethernet via USB hub) | Wi-Fi 6 (Ethernet via USB hub) | Wi-Fi 6 (Ethernet via USB hub) |
| **Status Screen** | 128×64 Mono OLED | — | 240×240 IPS Color Display | 240×240 IPS Color Display |
| **Enclosure** | Custom compact case | Bare board + Heatsink | Custom SLS PA12 case | Custom SLS PA12 case |
| **Dimensions** | 49 × 41 × 41 mm | Minimal footprint | 69 × 36 × 34 mm | 69 × 36 × 34 mm |
| **ATX Power Control** | — | Optional expansion | Optional expansion | **Included** (ATX board + wires) |
| **MicroSD with OS** | Included | Optional | Included | Included |
| **Lifetime OS License** | Included | Included | Included | Included |

---

## Key Capabilities (Hardware Autonomy at Level 0)

<img src="asset/t1.svg" width="1400" alt="USBridge client ecosystem and BIOS-in-Terminal OCR engine">

### ⚡ Zero Latency Streaming (Moonlight Engine)
* **~45 ms latency**: Sub-frame hardware encoding guarantees imperceptible input lag between mouse/keyboard and display response.
* **1080p @ 60 FPS**: Smooth high-refresh rendering suitable for fast desktop work, terminal scrolling, and even dynamic gaming.
* **Zero dropped frames**: Hardware network optimization ensures consistent frame delivery even over variable connections.

### 💻 BIOS as Text Over SSH (BIOS-in-Terminal)
* **On-device local OCR**: The KVM analyses the video stream locally without cloud connections.
* **Native terminal connection**: Connect with standard `ssh user@<kvm-ip>` — no browser, no heavy video stream required.
* **Copy & paste**: Easily copy serial numbers, MAC addresses, and POST error codes as plain text.
* Navigate with arrow keys, Enter, and Esc just like a physical console.

<img src="asset/t3.svg" width="1400" alt="MCP AI-agent automation and the turnkey USBridge KVM 2.0">

### 🤖 Scripts & AI Agents (Automation & MCP Server)
* **Starlark scripting (Python syntax)**: Write scripts that inspect on-screen text and trigger keypresses predictably.
* **Built-in MCP Server**: Integrate AI agents (e.g., Claude, LLMs) via the Model Context Protocol to read screens, adjust BIOS settings, and mount ISOs autonomously.
* **End-to-end OS installations**: Automate complete unattended deployments from BIOS setup through GRUB to final boot.

<img src="asset/t2.svg" width="1400" alt="Immutable Btrfs snapshots and virtual ISO media">

### 💾 Virtual Media & Immutable Snapshots
* **No more physical USB sticks**: Mount ISOs as CD/DVD drives to install OSes directly from BIOS.
* **Drive emulation**: Mount IMG, VDI, VMDK images or physical host disks as USB hard drives.
* **RAM caching & Overlay**: Streams directly from your computer with high-speed memory caching. Read-Write Overlay writes deltas to a separate layer, leaving golden source images untouched.
* **Ransomware & corruption protection**: 30 seconds after file changes cease, KVM automatically snapshots storage as read-only Btrfs. Even with host `root` privileges, compromised machines cannot alter or erase completed snapshots.

### 🔌 Hardware Power Control (ATX Module)
* **Hard reset & power cycling**: Power on, gracefully power down, or force reset even when the operating system is completely frozen.
* **Galvanic isolation**: Certified up to 3.75 kV isolation protects the KVM against electrical noise, surges, and ground loops from the host computer.
* **Safety interlock**: Button triggers require holding to confirm in the UI, eliminating accidental server reboots.
* **Live LED monitoring**: Front-panel Power and HDD activity LEDs are reported directly in the client app.

### 🌐 Access From Anywhere
* **Built-in Tailscale P2P Mesh**: Access your KVM remotely with end-to-end encryption without configuring public IPs or opening router ports.
* **Zero setup local connection**: Direct USB gadget networking (`10.55.0.1`) provides instant local out-of-the-box configuration.

---

## Client Downloads

<img src="asset/client.svg" width="1400" alt="USBridge client for Windows, macOS, Linux, Android, iOS and web">

Manage your hardware KVMs and software agents from a single unified application.

**Unified Installer (Client + Software Agent):**  
[Windows Setup (.exe)](https://github.com/USBridge-Technologies/USBridge-Remote/releases/latest/download/USBridge-Windows-x86_64-Setup.exe) · [macOS Apple Silicon (.dmg)](https://github.com/USBridge-Technologies/USBridge-Remote/releases/latest/download/USBridge-macOS-arm64.dmg)

| Platform | Installer | Portable / Alternative | Store / Package Manager |
| :--- | :--- | :--- | :--- |
| **Windows** (x86_64) | [Setup (.exe)](https://github.com/USBridge-Technologies/USBridge-Remote/releases/latest/download/USBridge-Windows-x86_64-Setup.exe) | [Portable (.zip)](https://github.com/USBridge-Technologies/USBridge-Remote/releases/latest/download/USBridgeClient-Windows-x86_64.zip) | — |
| **macOS** (Apple Silicon) | [Disk Image (.dmg)](https://github.com/USBridge-Technologies/USBridge-Remote/releases/latest/download/USBridgeClient-macOS-arm64.dmg) | — | — |
| **Linux** (x86_64) | [Debian / Ubuntu (.deb)](https://github.com/USBridge-Technologies/USBridge-Remote/releases/latest/download/USBridgeClient-Linux-x86_64.deb)<br>[Fedora / RHEL (.rpm)](https://github.com/USBridge-Technologies/USBridge-Remote/releases/latest/download/USBridgeClient-Linux-x86_64.rpm)<br>[Arch (.pkg.tar.zst)](https://github.com/USBridge-Technologies/USBridge-Remote/releases/latest/download/USBridgeClient-Linux-x86_64.pkg.tar.zst) | [AppImage](https://github.com/USBridge-Technologies/USBridge-Remote/releases/latest/download/USBridgeClient-Linux-x86_64.AppImage) | [APT / DNF / pacman repo](https://github.com/USBridge-Technologies/USBridge-Remote#install-from-the-terminal)<br>[Snap Store](https://snapcraft.io/usbridge-client) |
| **Android** (ARM64) | [APK (self-updating)](https://github.com/USBridge-Technologies/USBridge-Remote/releases/latest/download/USBridgeClient-Android-arm64-selfupdate.apk) | — | [Google Play](https://play.google.com/store/apps/details?id=io.usbridge.client) |
| **iOS / iPadOS** | — | — | [Apple App Store](https://apps.apple.com/us/app/usbridge-client/id6787665935) |
| **Web Browser** | — | [Open web.usbridge.io](https://web.usbridge.io) | Works in Chrome, Edge, Safari, Firefox |

*For terminal install commands and headless deployment, see the [USBridge-Remote Repository](https://github.com/USBridge-Technologies/USBridge-Remote).*

---

## Comparison: USBridge KVM 2.0 vs Other IP KVM Solutions

| Feature | **USBridge KVM 2.0** | **JetKVM Mini** | **PiKVM V4 Mini** | **TinyPilot Voyager 3** |
| :--- | :---: | :---: | :---: | :---: |
| **Price** | **from $99** | $39 | from $252 | $399 |
| **Video Resolution & Rate** | **1080p @ 60 FPS** | 1080p @ 30 / 720p @ 60 | 1920 × 1200 @ 60 FPS | 1920 × 1200 @ 60 FPS |
| **Video Latency** | **~45 ms (Moonlight)** | Not stated | Not stated | 80–100 ms |
| **Network Interfaces** | **Wi-Fi 6**, Ethernet via USB | 100 Mbps Ethernet / Wi-Fi | Gigabit Ethernet | Gigabit Ethernet |
| **ATX Power Control** | ✅ **Included in Full** (Isolated) | ❌ | ✅ | ❌ |
| **Virtual Media (ISO/IMG)** | ✅ **Fast RAM cache + Overlay** | ✅ | ✅ | ✅ |
| **On-Device Status Screen** | ✅ **240×240 IPS Color** | ✅ | ✅ | ✅ |
| **Immutable Storage Snapshots** | ✅ **Btrfs Read-Only Snapshots** | ❌ | ❌ | ❌ |
| **BIOS-in-Terminal & AI (OCR, MCP)** | ✅ **Local OCR + MCP Server** | ❌ | ❌ | Paid license |

> [!NOTE]
> **What about the USBridge Nano?**
> The **USBridge Nano** ($89) is an ultra-compact pocket appliance based on the Sipeed SG2002 RISC-V SoC with native MIPI CSI HDMI capture. It is intended for administrators seeking the smallest form factor with built-in Ethernet, running the same USBridge OS streaming core.

---

## Quick Start: 3-Step Hardware Connection

<img src="asset/Hardware Connection.svg" width="1400" alt="Hardware Connection Diagram">

Connecting USBridge KVM 2.0 to your target computer takes less than 2 minutes:

1. **Port 1 (OTG USB-C):** Connect to a USB port on the target machine. This single cable powers the KVM, emulates keyboard & mouse, and provides virtual drive mass storage.
2. **Port 2 (Host USB-C) + Dongle:** Plug the external HDMI capture dongle into Port 2 using the provided USB-C cable. Connect the dongle to your target computer's GPU / motherboard HDMI output.
3. **Network Connection:** Connect to your local network via Wi-Fi 6 or plug into Ethernet (using a USB-to-Ethernet adapter or via direct USB gadget IP `10.55.0.1`).

> [!IMPORTANT]
> **Capture Dongle Mode: `[5G]` vs `[480M]`**
> The USB-C video capture dongle operates in two modes depending on cable orientation:
> * **`[5G]` Mode (USB 3.0):** High-speed mode delivering full 5 Gbps bandwidth, uncompressed color, and lowest latency. **Always verify this mode in the app.**
> * **`[480M]` Mode (USB 2.0):** Fallback mode (480 Mbps). May introduce noticeable compression artifacts or delay.
> 
> *Fix:* If the client displays `[480M]`, simply unplug the Type-C cable from the KVM, flip the connector 180°, and reconnect it to lock into `[5G]`.

### Optional: ATX Power Control Board Wiring

<img src="asset/Power Management Module.svg" width="1400" alt="ATX Power Management Module Wiring">

Connect the 8-pin ribbon cable from the KVM to the ATX board, then connect the DuPont jumper wires to your motherboard's Front Panel header:

| ATX Board Pin | Motherboard Front Panel Header | Purpose |
| :--- | :--- | :--- |
| **`|PWR|`** | **Power Switch** (`PWR_SW`) | Remote power on and shutdown |
| **`|RST|`** | **Reset Switch** (`RESET`) | Remote hard reboot |
| **`|LED1|`** | **Power LED** (`P_LED`) | Real-time power state feedback |
| **`|LED2|`** | **HDD LED** (`H_LED`) | Drive activity monitoring |

---

## Already Have a Board? Install USBridge Firmware

Turn standard off-the-shelf single-board computers into an enterprise-grade out-of-band management appliance.

### Supported Boards:
* **Sipeed NanoKVM** (SOPHGO SG2002 RISC-V) — on-board MIPI capture, Ethernet.
* **Radxa Zero 3W / 3E** (Rockchip RK3566 quad-core) — Wi-Fi 6 / Ethernet, USB 3.0 capture.
* **Radxa Cubie A7Z** (Allwinner A733 8-core) — high-performance processing, USB 3.0 capture.

👉 **Download firmware images:** [USBridge Hardware Downloads](https://www.usbridge.io/hardware-agent/#firmware)  
👉 **Flashing guides:** [Flashing & Recovery Guide](./docs/content/9-updates-changelog/recovery-flashing-guide.md) · [Flash-Tool Directory](./flash-tool/)

### Connecting After Flashing:
* **Default USB Gadget IP:** `10.55.0.1`  
  Connect the board to your PC via USB. Open `http://10.55.0.1` in any browser for immediate pairing, setup QR code, Moonlight PIN, and Wi-Fi configuration.
* **Auto-Discovery:** In the desktop USBridge Client, click **`+` ➔ Over USB** to pair with the board automatically.

---

## Accessories

| Accessory | Description | Details |
| :--- | :--- | :--- |
| **Screen Module (Flip-HAT 1.3" LCD)** | 240×240 IPS status screen designed specifically for Zero-factor boards. Mounts on the back of the PCB so the CPU remains open for large heatsinks and active cooling. | [LCD Flip-HAT Specs](./USBridge-Flip-HAT-1.3-LCD/) |
| **ATX Power Control Board** | Galvanically isolated (up to 3.75 kV) front-panel adapter board for Power, Reset, Power LED, and HDD LED headers. | [ATX Board Guide](./docs/content/6-hardware-connectivity/power-management-module-control.md) |
| **HDMI Capture Dongle (1080p @ 60 FPS)** | High-throughput UVC video capture card optimized for USB 3.0 `[5G]` mode and sub-frame hardware encoding. | Included with Standard & Full kits |

---

## Documentation & Hardware Reference

Complete technical guides are located in the [`docs/`](./docs/README.md) directory:

* **[Getting Started & Provisioning](./docs/content/1-getting-started/)** — Quick start, network configuration, and headless bulk setup.
* **[BIOS-in-Terminal & OCR](./docs/content/3-bios-in-terminal/)** — Local OCR engine, SSH terminal access, and Starlark scripting.
* **[Snapshots & Storage Management](./docs/content/4-snapshots-state-management/)** — Btrfs snapshots, rollback, and security.
* **[Virtual Media Mounting](./docs/content/5-remote-disk-image-mounting/)** — Mounting ISOs, bootable disks, and RAM cache.
* **[Hardware Reference & Pinouts](./docs/content/6-hardware-connectivity/)** — Architecture, board comparison, and power thermal guidelines.
* **[Developer REST API](./docs/content/10-developer-api/)** — Full API reference for headless integrations and custom scripting.
* **[Hardware Models & Schematics](./Hardware/)** — PCB files and 3D printable STL/STEP enclosures.

---

## Community & Independent Reviews

| Creator / Channel | Review / Tutorial | Link |
| :--- | :--- | :--- |
| **Learn To HomeLab** | *Is This The Best KVM On The Market?* | [Watch Review](https://www.youtube.com/watch?v=U3GhuyD-gzw) |
| **Barmine Tech** | *The Best KVM I've Used? USBridge KVM 2.0 (Independent Review)* | [Watch Review](https://www.youtube.com/watch?v=DA_hMD3T0Qg) |
| **Jonatan Castro** | *Unboxing & What's in the box (Spanish)* | [Watch Review](https://www.youtube.com/watch?v=7YJS81rI3U8&t) |
| **USBridge Official** | *NanoKVM with USBridge firmware: 60 FPS instead of lag* | [Watch on YouTube](https://youtu.be/q8rX7o-Svqs) |
| **USBridge Official** | *Official Overview & Feature Walkthrough* | [Watch on YouTube](https://youtu.be/4h5Q8XpDzqI) |
| **USBridge Official** | *Assembly & Packaging of USBridge KVM 2.0* | [Watch on YouTube](https://youtu.be/l6QtajSYtwQ) |

Join our community on [Discord](https://discord.gg/XwNpCrGfsB) and [Reddit](https://www.reddit.com/r/USBridge/) to discuss homelab setups, custom automation scripts, and firmware updates!
