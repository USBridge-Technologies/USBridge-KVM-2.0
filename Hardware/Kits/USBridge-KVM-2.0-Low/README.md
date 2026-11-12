# USBridge KVM 2.0 Low Kit (Minimalist Board Edition)

<div align="center">
<img src="images/specs-low.webp" width="700" alt="USBridge KVM 2.0 Low Hardware Overview">
</div>

The minimalist bare-board KVM kit engineered for dense server rack integration, homelabs, and custom enclosures where a compact footprint and passive cooling are required.

* 👉 **[Buy USBridge KVM 2.0 Low on usbridge.io ($99)](https://www.usbridge.io/hardware-agent/#buy-usbridge-kvm-2-0-low)**

**Quick Jump:** [Specifications](#technical-specifications) • [In the Box](#in-the-box-package-contents) • [Features](#key-capabilities--features) • [DIY KVM & Firmware](#diy-kvm-setup-turn-your-sbc-into-an-ip-kvm) • [Hardware Setup](#3-step-hardware-setup) • [Connect & Setup](#connect--initial-setup) • [SSH Access](#enabling-secure-ssh-access) • [Cooling Heatsink](#cnc-aluminum-heatsinks-cad-files)

---

## Technical Specifications

| Specification | Details |
| :--- | :--- |
| **Base Board** | Radxa Zero 3W |
| **Processor** | Rockchip RK3566 (Quad-Core Cortex-A55 up to 1.6 GHz) + 0.8 TOPS NPU |
| **Memory** | 1 GB LPDDR4 |
| **Video Capture** | External USB 3.0 UVC Capture Card (1080p @ 60 FPS) |
| **Stream Latency** | ~45 ms (Moonlight streaming pipeline) |
| **Streaming Protocol** | Moonlight protocol, sub-frame low latency & WebRTC |
| **Peripheral Control** | USB HID keyboard and mouse emulation, virtual ISO drive, gamepads |
| **Audio** | Audio output and microphone in both directions |
| **Network Interfaces** | Onboard Wi-Fi 6 & Bluetooth 5.4; Ethernet via USB hub + USB virtual Ethernet (`10.55.0.1`) |
| **Status Screen** | None (Headless operation via web panel, mobile app, and SSH) |
| **Cooling** | Passive solid extruded aluminum heatsink |
| **Ports** | USB-C 2.0 (OTG to target PC), USB-C 3.0 (Host for capture card), Micro HDMI |
| **Operating System** | USBridge OS with Btrfs immutable snapshots & OTA updates |

---

## In the Box (Package Contents)

1. **Radxa Zero 3W Board**: Pre-configured single-board computer with USBridge firmware.
2. **Aluminum Cooling Heatsink**: Custom high-efficiency passive cooling block.
3. **USB 3.0 HDMI Video Capture Dongle**: High-throughput 1080p @ 60 FPS UVC capture stick.
4. **USB-C Interconnect Cable**: Linking the KVM Host port to the capture dongle.
5. *Optional*: Pre-flashed MicroSD card with USBridge OS (Lifetime License included).

---

## Key Capabilities & Features

Whether you deploy the pre-assembled **USBridge KVM 2.0 Low** kit or provision your own SBC, **USBridge OS** provides an enterprise-grade out-of-band management suite:

* **Ultra-Low Latency Streaming**: Hardware-accelerated sub-frame encoding with Moonlight protocol and WebRTC.
* **Unified Ecosystem**: Connect from native desktop clients (Windows, macOS Apple Silicon, Linux), mobile apps (iOS, Android), or any web browser.
* **Zero-Config Remote Access (Tailscale)**: Built-in native Tailscale mesh VPN integration to securely access your KVM from anywhere in the world without port forwarding or static public IPs.
* **Gamepad & Peripheral Emulation**: USB HID keyboard, precision mouse, and virtual gamepad/controller passthrough for remote gaming, simulation, or specialized control.
* **Bi-Directional Stereo Audio & Mic**: Real-time audio streaming from the target machine and microphone passthrough in both directions.
* **Full Out-of-Band Control**: Direct BIOS/UEFI control, virtual ISO drive mounting for bare-metal OS installs, and seamless pairing.
* **Enterprise Security**: Cryptographic per-request API signing, encrypted DTLS-SRTP media transport, and seamless OTA updates.

### DIY KVM Setup: Turn Your SBC into an IP-KVM

Already own a supported single-board computer? Flash **USBridge OS** and connect a standard USB capture dongle to turn it into an enterprise-grade IP-KVM.

#### 3-Minute Flashing Guide (Video Tutorial)

Watch the complete guide on how to flash the firmware and perform the first boot:

[![DIY IP-KVM Flashing Guide](https://img.youtube.com/vi/9FyPjEfH5Wg/maxresdefault.jpg)](https://youtu.be/9FyPjEfH5Wg)

#### Firmware & Setup Links
* [Download USBridge Firmware ➔](https://www.usbridge.io/hardware-agent/#firmware)
* [Step-by-step Flashing Guide ➔](../../../docs/content/9-updates-changelog/recovery-flashing-guide.md)
* [Headless Provisioning Guide ➔](../../../docs/content/1-getting-started/headless-provisioning.md)
* [Hardware Board Comparison ➔](../../../docs/content/6-hardware-connectivity/board-comparison.md)

---

## 3-Step Hardware Setup

<div align="center">
<img src="images/setup-low.png" width="900" alt="USBridge KVM 2.0 Low 3-Step Setup Diagram">
</div>

1. **HDMI Cable**: Connect an HDMI cable from the target computer's GPU / motherboard video output to the included USB 3.0 capture dongle.
2. **USB-C Cable (OTG Port)**: Connect a USB-C cable from Port 1 (OTG) to a USB port on the target computer for power delivery, peripheral emulation, and virtual storage mounting.
3. **Network Connection**: Connect via onboard Wi-Fi 6, plug in a USB Ethernet adapter, or pair instantly over the USB cable (`10.55.0.1`) using the desktop app.

---

## Connect & Initial Setup

Once your USBridge KVM is powered and cabled up, connect to it using one of the quick pairing methods below.

### Default IP Address (`10.55.0.1` over USB)

Plug the board's OTG USB cable into your computer: your computer immediately receives a virtual USB network adapter (its own internet connection remains completely untouched), and the KVM is reachable at **`10.55.0.1`**.

Open **`http://10.55.0.1`** in any web browser to access the setup page:
* Displays the QR code for fast pairing
* Direct connection link and device master key
* Moonlight PIN authorization
* Network configuration settings

### On Your Local Network (Wi-Fi 6 / Ethernet)

When connected to your local network, your router assigns the KVM an IP address automatically via DHCP (there is no fixed default). The setup page displays the assigned address at the top.

---

### Ways to Connect (Pick One)

1. **Recommended — [Desktop Client App](../../../README.md#client-downloads)**: Click **`+`** ➔ **Over USB**. The app automatically detects the KVM over the cable and pairs by itself.
2. **Phone or Tablet**: Open `http://10.55.0.1` on the computer the KVM is plugged into and scan the displayed pairing QR code with the USBridge mobile app.
3. **Headless Provisioning (Automated Deployment)**: Place a `usbridge_provision.json` file onto the MicroSD card boot partition before first boot to pre-configure Wi-Fi, static IP, or authorization keys without needing a QR code. See [Headless Provisioning Guide](../../../docs/content/1-getting-started/headless-provisioning.md).
4. **[Web Client in Browser](https://web.usbridge.io/)**: No desktop app installed? Connect instantly in any browser via **[web.usbridge.io](https://web.usbridge.io/)** or click the Web Client link directly inside the `http://10.55.0.1` setup page. *(The [native desktop app](../../../README.md#client-downloads) is recommended for best video performance and hardware acceleration).*

For complete step-by-step setup details, see the [Full Initial Setup Documentation](../../../docs/content/1-getting-started/initial-setup.md).

---

## Enabling Secure SSH Access

For strict security, **SSH access is disabled by default** in USBridge OS to protect headless appliances against unauthorized network access.

On headless units like the **Low Kit**, SSH can be securely enabled:
1. **Via the Web Setup Page**: Enable SSH inside the authenticated web interface (`http://10.55.0.1` or device settings) after verifying ownership with the device master key.
2. **Via Headless Provisioning**: Pre-authorize SSH access by declaring `"ssh": true` in `usbridge_provision.json` on the MicroSD card boot partition before initial boot.

Once enabled, the SSH service runs securely on standard port `22`.

---

## CNC Aluminum Heatsinks (CAD Files)

<div align="center">
<img src="images/kvm20-heatsink.png" width="700" alt="Aluminum Heatsink 3D Render">
</div>

The Low Kit relies on massive passive heatsinks to maintain optimal Rockchip RK3566 operating temperatures without fans:

* 📦 [**Radiator_V6_Transverse_Ribs.step**](./Radiator_V6_Transverse_Ribs.step) — Transverse cross-cut ribs for maximum passive surface area and omnidirectional airflow.
* 📦 [**Radiator_V5.step**](./Radiator_V5.step) — Longitudinal fin profile for directed channel airflow.
* **Manufacturing Material**: CNC Machined Aluminum Alloy (6061-T6 or 6063).

---

## Ready to Deploy?

Get your pre-assembled appliance or explore other models in the USBridge ecosystem:

* 🛒 **[Order USBridge KVM 2.0 Low ($99) on usbridge.io ➔](https://www.usbridge.io/hardware-agent/#buy-usbridge-kvm-2-0-low)**

### Explore Other USBridge KVM Kits

| Model | Form Factor | Capture Mode | Price | Details |
| :--- | :--- | :--- | :---: | :--- |
| **USBridge Nano** | Pocket Appliance + OLED | Built-in MIPI CSI (1080p60) | **$89** | [View Nano Kit Guide ➔](../USBridge-Nano/) |
| **USBridge KVM 2.0 Standard** | Desktop Unit + 1.3" Color IPS Screen | USB 3.0 Dongle (1080p60) | **$117** | [View Standard Kit Guide ➔](../USBridge-KVM-2.0-Standard/) |
| **USBridge KVM 2.0 Full** | Desktop Unit + Screen + ATX Power Board | USB 3.0 Dongle (1080p60) | **$139** | [View Full Kit Guide ➔](../USBridge-KVM-2.0-Full/) |

Explore all kits, expansion PCBs, and accessories in the **[Hardware Catalog ➔](../../README.md)**.
