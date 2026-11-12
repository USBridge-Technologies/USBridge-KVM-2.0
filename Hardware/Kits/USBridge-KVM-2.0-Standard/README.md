# USBridge KVM 2.0 Standard Kit (Complete Desktop Kit)

<div align="center">
<img src="images/specs-standard.webp" width="700" alt="USBridge KVM 2.0 Standard Hardware Overview">
</div>

The complete ready-to-use desktop IP-KVM appliance in a custom protective enclosure, featuring an interactive 1.3" IPS color status display, physical navigation controls, and full peripheral emulation out of the box.

* 👉 **[Buy USBridge KVM 2.0 Standard on usbridge.io ($117)](https://www.usbridge.io/hardware-agent/#buy-usbridge-kvm-2-0-standard)**

**Quick Jump:** [Specifications](#technical-specifications) • [In the Box](#in-the-box-package-contents) • [Features](#key-capabilities--features) • [DIY KVM & Firmware](#diy-kvm-setup-turn-your-sbc-into-an-ip-kvm) • [Hardware Setup](#3-step-hardware-setup) • [On-Screen Setup](#connect--initial-setup-via-front-panel-screen) • [3D Case & Parts](#3d-printable-enclosure-cad-files)

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
| **Network Interfaces** | Onboard Wi-Fi 6 & Bluetooth 5.4 *(see note below)* |
| **Status Screen** | 1.3" IPS full-color LCD (240×240), 3 physical buttons & 5-way joystick (Live Monitor Mode support) |
| **Power Management** | Ready for optional [ATX Power Control Board](../../Accessories/ATX-Board/) |
| **Enclosure Dimensions** | 69 × 36 × 34 mm (desktop unit) |
| **MicroSD with OS** | Included (Pre-flashed MicroSD card with Lifetime License) |
| **Operating System** | USBridge OS with Btrfs immutable snapshots & OTA updates |

> [!NOTE]
> * **ATX Remote Power Management:** Front-panel motherboard power control (Power SW, Reset SW, Power LED, HDD LED) can be added optionally with the galvanically isolated [ATX Power Control Board](../../Accessories/ATX-Board/). Included out of the box in the [Full Kit](../USBridge-KVM-2.0-Full/).
> * **Wired Ethernet Support:** If wired network connectivity is required, an external USB-to-Ethernet adapter or USB hub with an RJ45 port can be connected to the host port (not included in the standard kit).

---

## In the Box (Package Contents)

1. **USBridge KVM 2.0 Standard Appliance**: Fully assembled desktop unit in custom enclosure with integrated 1.3" IPS color screen, 5-way joystick, and physical buttons.
2. **USB 3.0 HDMI Video Capture Dongle**: High-throughput 1080p @ 60 FPS UVC capture stick.
3. **Pre-flashed MicroSD Card**: Pre-installed with USBridge OS and Lifetime License.

### Software License & OS Delivery

* **Lifetime OS License**: Included on the pre-flashed card and registered to your unit. USBridge OS licenses offer **100% lifetime ownership** — no subscriptions, renewal fees, or recurring charges.

---

## Key Capabilities & Features

Whether you deploy the pre-assembled **USBridge KVM 2.0 Standard** kit or provision your own SBC, **USBridge OS** provides an enterprise-grade out-of-band management suite:

* **Ultra-Low Latency Streaming**: Hardware-accelerated sub-frame encoding with Moonlight protocol and WebRTC.
* **Unified Ecosystem**: Connect from native desktop clients (Windows, macOS Apple Silicon, Linux), mobile apps (iOS, Android), or any web browser.
* **Zero-Config Remote Access (Tailscale)**: Built-in native Tailscale mesh VPN integration to securely access your KVM from anywhere in the world without port forwarding or static public IPs.
* **Gamepad & Peripheral Emulation**: USB HID keyboard, precision mouse, and virtual gamepad/controller passthrough for remote gaming, simulation, or specialized control.
* **Bi-Directional Stereo Audio & Mic**: Real-time audio streaming from the target machine and microphone passthrough in both directions.
* **Full Out-of-Band Control**: Direct BIOS/UEFI control, virtual ISO drive mounting for bare-metal OS installs, and seamless pairing.
* **Front-Panel Interactive Display**: Built-in settings menu, network status, master key QR code, and Live Monitor Mode.
* **Enterprise Security**: Cryptographic per-request API signing, encrypted DTLS-SRTP media transport, and seamless OTA updates.

### DIY KVM Setup: Turn Your SBC into an IP-KVM

Already own a supported single-board computer (Radxa Zero 3W / 3E, Radxa Cubie A7Z)? Flash **USBridge OS** and connect a standard USB capture dongle to build your own IP-KVM:

#### 3-Minute Flashing Guide (Video Tutorial)

Watch the complete guide on how to flash the firmware and perform the first boot:

[![DIY IP-KVM Flashing Guide](https://img.youtube.com/vi/9FyPjEfH5Wg/maxresdefault.jpg)](https://youtu.be/9FyPjEfH5Wg)

* [Download USBridge Firmware ➔](https://www.usbridge.io/hardware-agent/#firmware)
* [Step-by-step Flashing Guide ➔](../../../docs/content/9-updates-changelog/recovery-flashing-guide.md)
* [Hardware Board Comparison ➔](../../../docs/content/6-hardware-connectivity/board-comparison.md)

---

## 3-Step Hardware Setup

<div align="center">
<img src="images/setup-standard.png" width="900" alt="USBridge KVM 2.0 Standard 3-Step Setup Diagram">
</div>

1. **HDMI Cable**: Connect an HDMI cable from the target computer's GPU / motherboard video output to the included USB 3.0 capture dongle.
2. **USB-C Cable (Port 1 OTG)**: Connect a USB-C cable from Port 1 (OTG) to a USB port on the target computer for power delivery, peripheral emulation, and virtual storage mounting.
3. **Network Connection**: Connect to Wi-Fi 6 or plug in a USB Ethernet adapter.

### Critical: Capture Dongle Cable Orientation (`[5G]` vs `[480M]`)

The USB 3.0 HDMI capture dongle can negotiate in either of two hardware modes depending on the physical orientation of the USB-C plug:

* **`[5G]` Mode (SuperSpeed USB 3.0 — Target Mode)**: Full 5 Gbps bus bandwidth, uncompressed YUY2/NV12 video, zero JPEG compression artifacts, and minimal input latency (~45 ms).
* **`[480M]` Mode (High-Speed USB 2.0 — Fallback Mode)**: Compatibility fallback running at 480 Mbps. The stream falls back to lossy MJPEG compression with visible artifacts, color banding, and increased latency.

> [!IMPORTANT]
> **How to ensure `[5G]` Mode:**  
> Check the connection badge in the USBridge client interface or on-device screen:
> * If you see **`[480M]`**, simply **unplug the USB-C cable from the KVM Host port, rotate the plug 180°, and plug it back in**.
> * The dongle will immediately renegotiate into high-speed **`[5G]`** mode.

---

## Connect & Initial Setup via Front-Panel Screen

Because the **Standard Kit** comes fully assembled with the pre-flashed MicroSD card and an interactive 1.3" IPS color screen, initial network setup and pairing are executed directly on the device:

### 1. Wi-Fi Configuration
1. Power on the unit.
2. Navigate to **`Settings` ➔ `Internet` ➔ `Wi-Fi`**.
3. Select **`Enable Wi-Fi`**. After a few seconds, the **`Available Networks`** option becomes active.
4. Select **`Available Networks`** to scan for surrounding wireless networks.
5. Choose your Wi-Fi network to enter the password using the 3 front-panel physical buttons:
   * **Button 1**: Digits (`0–9`)
   * **Button 2**: Uppercase letters (`A–Z`)
   * **Button 3**: Lowercase letters (`a–z`)
6. Once the password is typed, **press and hold Button 3** to confirm and connect.
7. The assigned IP address is immediately displayed under **`Wi-Fi Status`** and on the main status dashboard.

### 2. Fast Screen Pairing
1. Navigate to **`Settings` ➔ `Authentication` ➔ `Show Master Key`**.
2. A pairing QR code appears on the 1.3" color screen.
3. **Mobile App**: Scan the QR code with the USBridge mobile app to pair instantly.
4. **Desktop Client**: Open the [Desktop Client App](../../../README.md#client-downloads), click **`+` ➔ Manual**, and enter the device IP and master key (or click the pairing link shown on screen).
5. **Web Client**: Connect directly in any browser via **[web.usbridge.io](https://web.usbridge.io/)**.

### 3. Live Monitor Mode
The front-panel 1.3" color screen isn't just for status — it features a dedicated **Monitor Mode**. Press the physical button to toggle the display into a miniature local monitor showing the target computer's live video output in real time.

For complete details on settings, see the [Full Initial Setup Documentation](../../../docs/content/1-getting-started/initial-setup.md).

---

## 3D Printable Enclosure (CAD Files)

<div align="center">
<img src="images/kvm20-case.png" width="700" alt="USBridge KVM 2.0 Case 3D Render">
</div>

We provide the complete production STEP models for 3D printing the desktop enclosure and tactile controls:

* 📦 [**USBridge_KVM_2.0_Case_V6.step**](./USBridge_KVM_2.0_Case_V6.step) — Main body enclosure designed for Zero-factor boards and the 1.3" Flip-HAT module.
* 📦 [**Key_Single.step**](./Key_Single.step) — Push-button cap for the 3 front-panel tactile switches.
* 📦 [**Joystick_Cap.step**](./Joystick_Cap.step) — Ergonomic 5-way joystick knob.
* **Recommended Technology**: High-Precision Resin (SLA / MSLA / DLP) with Tough / ABS-like resin for production-grade finish, or SLS Nylon (PA12).
* **FDM Alternative**: PETG, 0.12–0.16 mm layer height, 40–100% infill.

---

## Ready to Deploy?

Get your pre-assembled appliance or explore other models in the USBridge ecosystem:

* 🛒 **[Order USBridge KVM 2.0 Standard ($117) on usbridge.io ➔](https://www.usbridge.io/hardware-agent/#buy-usbridge-kvm-2-0-standard)**

### Explore Other USBridge KVM Kits

| Model | Form Factor | Capture Mode | Price | Details |
| :--- | :--- | :--- | :---: | :--- |
| **USBridge Nano** | Pocket Appliance + OLED | Built-in MIPI CSI (1080p60) | **$89** | [View Nano Kit Guide ➔](../USBridge-Nano/) |
| **USBridge KVM 2.0 Low** | Bare board + Extruded Heatsink | USB 3.0 Dongle (1080p60) | **$99** | [View Low Kit Guide ➔](../USBridge-KVM-2.0-Low/) |
| **USBridge KVM 2.0 Full** | Desktop Unit + Screen + ATX Power Board | USB 3.0 Dongle (1080p60) | **$139** | [View Full Kit Guide ➔](../USBridge-KVM-2.0-Full/) |

Explore all kits, expansion PCBs, and accessories in the **[Hardware Catalog ➔](../../README.md)**.
