# USBridge KVM 2.0 Full Kit (Flagship Edition with ATX)

<div align="center">
<img src="images/specs-full.webp" width="700" alt="USBridge KVM 2.0 Full Hardware Overview">
</div>

The flagship, all-in-one IP-KVM appliance. Includes the complete KVM 2.0 desktop unit with an interactive color IPS display, active/passive cooling, and a dedicated galvanically isolated ATX Power Management board with DuPont jumpers for complete bare-metal hardware control.

* 👉 **[Buy USBridge KVM 2.0 Full on usbridge.io ($139)](https://www.usbridge.io/hardware-agent/#buy-usbridge-kvm-2-0)**

**Quick Jump:** [Specifications](#technical-specifications) • [In the Box](#in-the-box-package-contents) • [Features](#key-capabilities--features) • [DIY KVM & Firmware](#diy-kvm-setup-turn-your-sbc-into-an-ip-kvm) • [Hardware Setup](#4-step-hardware-setup) • [Dongle Orientation](#critical-capture-dongle-cable-orientation-5g-vs-480m) • [ATX Wiring](#atx-power-control-wiring) • [On-Screen Setup](#connect--initial-setup-via-front-panel-screen) • [3D Case & Parts](#production-cad-files-3d-models--heatsinks)

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
| **ATX Power Control** | **Included** — Hardware Power, Reset, Power LED & HDD LED telemetry (Optocoupler isolation up to 3.75 kV) |
| **Cooling** | Custom aluminum cooling heatsink |
| **Enclosure Dimensions** | 69 × 36 × 34 mm (desktop unit) |
| **MicroSD with OS** | Included (Pre-flashed MicroSD card with Lifetime License) |
| **Operating System** | USBridge OS with Btrfs immutable snapshots & OTA updates |

> [!NOTE]
> **Wired Ethernet Support:** If wired network connectivity is required, an external USB-to-Ethernet adapter or USB hub with an RJ45 port can be connected to the host port (not included in the standard kit).

---

## In the Box (Package Contents)

1. **USBridge KVM 2.0 Full Appliance**: Fully assembled desktop unit in custom enclosure with integrated 1.3" IPS color screen, 5-way joystick, and physical buttons.
2. **ATX Power Control Board**: Dedicated adapter board with 8-pin ribbon cable.
3. **DuPont Jumper Wire Set**: Female-to-female jumper wires to bridge to motherboard Front Panel headers.
4. **USB 3.0 HDMI Video Capture Dongle**: High-throughput 1080p @ 60 FPS UVC capture stick.
5. **Pre-flashed MicroSD Card**: Pre-installed with USBridge OS and Lifetime License.

### Software License & OS Delivery

* **Lifetime OS License**: Included on the pre-flashed card and registered to your unit. USBridge OS licenses offer **100% lifetime ownership** — no subscriptions, renewal fees, or recurring charges.

---

## Key Capabilities & Features

Whether you deploy the pre-assembled **USBridge KVM 2.0 Full** kit or provision your own SBC, **USBridge OS** provides an enterprise-grade out-of-band management suite:

* **Ultra-Low Latency Streaming**: Hardware-accelerated sub-frame encoding with Moonlight protocol and WebRTC.
* **Unified Ecosystem**: Connect from native desktop clients (Windows, macOS Apple Silicon, Linux), mobile apps (iOS, Android), or any web browser.
* **Zero-Config Remote Access (Tailscale)**: Built-in native Tailscale mesh VPN integration to securely access your KVM from anywhere in the world without port forwarding or static public IPs.
* **Gamepad & Peripheral Emulation**: USB HID keyboard, precision mouse, and virtual gamepad/controller passthrough for remote gaming, simulation, or specialized control.
* **Bi-Directional Stereo Audio & Mic**: Real-time audio streaming from the target machine and microphone passthrough in both directions.
* **Full Out-of-Band & ATX Control**: Direct BIOS/UEFI control, virtual ISO drive mounting, and true bare-metal recovery via hardware power cycling.
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

## 4-Step Hardware Setup

<div align="center">
<img src="images/setup-full.png" width="900" alt="USBridge KVM 2.0 Full 4-Step Setup Diagram">
</div>

1. **HDMI Cable**: Connect an HDMI cable from the computer's GPU / motherboard video output to the included USB 3.0 capture dongle.
2. **USB-C Cable (Port 1 OTG)**: Connect from Port 1 to the host computer for power, input emulation, and virtual storage mounting.
3. **ATX Control Board**: Plug the ribbon cable into the KVM's 8-pin GPIO port, then attach jumper wires to the motherboard Front Panel headers (`PWR_SW`, `RESET`, `P_LED`, `H_LED`).
4. **Network Connection**: Connect to Wi-Fi 6 or plug in a USB Ethernet adapter.

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

## ATX Power Control Wiring

The included **ATX Power Control Board** provides physical isolation up to 3.75 kV between the KVM and the target motherboard. Connect the DuPont wires to your motherboard's front-panel header pins:

| Signal | Description | Behavior |
| :--- | :--- | :--- |
| **`PWR_SW`** | Power Switch | Momentary pulse to power on / graceful ACPI shutdown; hold for 5s for hard cutoff |
| **`RESET_SW`** | Reset Switch | Instant hardware reboot for unrecoverable crashes or kernel panics |
| **`PWR_LED`** | Power Indicator | Real-time telemetry in client UI showing whether the host motherboard is powered |
| **`HDD_LED`** | Disk Activity | Real-time storage read/write activity indicator |

For complete schematics and pinout diagrams, see the **[ATX Board Guide ➔](../../Accessories/ATX-Board/)**.

---

## Connect & Initial Setup via Front-Panel Screen

Because the **Full Kit** comes fully assembled with the pre-flashed MicroSD card and an interactive 1.3" IPS color screen, initial pairing is executed directly on the device:

### 1. First Boot & Network Status
Power on the unit. USBridge OS boots within seconds, initializes the front-panel display, and automatically connects to your local network via Wi-Fi 6 or wired Ethernet. The screen displays:
* Current IP address assigned by your router (DHCP)
* Host link status and stream health
* Live video resolution and FPS

### 2. Fast Screen Pairing
1. Use the 5-way joystick to open the on-device menu.
2. Navigate to **`Settings` ➔ `Authentication` ➔ `Show Master Key`**.
3. A pairing QR code appears on the 1.3" color screen.
4. **Mobile App**: Scan the QR code with the USBridge mobile app to pair instantly.
5. **Desktop Client**: Open the [Desktop Client App](../../../README.md#client-downloads), click **`+` ➔ Manual**, and enter the device IP and master key (or click the pairing link shown on screen).
6. **Web Client**: Connect directly in any browser via **[web.usbridge.io](https://web.usbridge.io/)**.

### 3. Live Monitor Mode
The front-panel 1.3" color screen isn't just for status — it features a dedicated **Monitor Mode**. Press the physical button to toggle the display into a miniature local monitor showing the target computer's live video output in real time.

For complete details on settings, see the [Full Initial Setup Documentation](../../../docs/content/1-getting-started/initial-setup.md).

---

## Production CAD Files (3D Models & Heatsinks)

<div align="center">
<img src="images/kvm20-case.png" width="450" alt="Case Render">
<img src="images/kvm20-heatsink.png" width="450" alt="Heatsink Render">
</div>

We provide the complete production STEP models for 3D printing the desktop enclosure and tactile controls:

* 📦 [**USBridge_KVM_2.0_Case_V6.step**](./USBridge_KVM_2.0_Case_V6.step) — Enclosure body designed for Zero-factor boards and the 1.3" Flip-HAT module.
* 📦 [**Key_Single.step**](./Key_Single.step) — Push-button cap for the 3 front-panel tactile switches.
* 📦 [**Joystick_Cap.step**](./Joystick_Cap.step) — Ergonomic 5-way joystick knob.
* 📦 [**Radiator_V6_Transverse_Ribs.step**](./Radiator_V6_Transverse_Ribs.step) — Transverse cross-cut aluminum heatsink.
* **Recommended Technology**: High-Precision Resin (SLA / MSLA / DLP) with Tough / ABS-like resin for production-grade finish, or SLS Nylon (PA12).
* **FDM Alternative**: PETG, 0.12–0.16 mm layer height, 40–100% infill.

---

## Ready to Deploy?

Get your pre-assembled appliance or explore other models in the USBridge ecosystem:

* 🛒 **[Order USBridge KVM 2.0 Full ($139) on usbridge.io ➔](https://www.usbridge.io/hardware-agent/#buy-usbridge-kvm-2-0)**

### Explore Other USBridge KVM Kits

| Model | Form Factor | Capture Mode | Price | Details |
| :--- | :--- | :--- | :---: | :--- |
| **USBridge Nano** | Pocket Appliance + OLED | Built-in MIPI CSI (1080p60) | **$89** | [View Nano Kit Guide ➔](../USBridge-Nano/) |
| **USBridge KVM 2.0 Low** | Bare board + Extruded Heatsink | USB 3.0 Dongle (1080p60) | **$99** | [View Low Kit Guide ➔](../USBridge-KVM-2.0-Low/) |
| **USBridge KVM 2.0 Standard** | Desktop Unit + 1.3" Color IPS Screen | USB 3.0 Dongle (1080p60) | **$117** | [View Standard Kit Guide ➔](../USBridge-KVM-2.0-Standard/) |

Explore all kits, expansion PCBs, and accessories in the **[Hardware Catalog ➔](../../README.md)**.
