# USBridge KVM 2.0 Low Kit (Minimalist Board Edition)

<div align="center">
<img src="specs-low.webp" width="700" alt="USBridge KVM 2.0 Low Hardware Overview">
</div>

The minimalist bare-board KVM kit engineered for custom rack integration, homelabs, and dense server deployments where custom mounting and compact footprint are required.

* 👉 [Buy USBridge KVM 2.0 Low on usbridge.io ($99)](https://www.usbridge.io/hardware-agent/#buy-usbridge-kvm-2-0-low)

---

## Technical Specifications

| Specification | Details |
| :--- | :--- |
| **Base Board** | Radxa Zero 3W |
| **Processor** | Rockchip RK3566 (Quad-Core Cortex-A55 up to 1.6 GHz) |
| **Memory** | 1 GB LPDDR4 |
| **Video Capture** | External USB 3.0 UVC Capture Card (1080p @ 60 FPS) |
| **Stream Latency** | ~45 ms (Moonlight streaming pipeline) |
| **Network Interfaces** | Onboard Wi-Fi 6 & Bluetooth; Ethernet via USB hub |
| **Status Screen** | None (Headless operation via web panel, mobile app, and SSH) |
| **Cooling** | Passive solid aluminum heatsink |
| **Ports** | USB-C 2.0 (OTG to computer), USB-C 3.0 (Host for capture card), Micro HDMI |
| **Operating System** | USBridge KVM OS with Btrfs immutable snapshots & OTA updates |

---

## In the Box (Package Contents)
1. **Radxa Zero 3W Board**: Pre-configured single-board computer with USBridge firmware.
2. **Aluminum Cooling Heatsink**: Custom passive cooling block.
3. **USB 3.0 HDMI Video Capture Dongle**: High-throughput 1080p 60 FPS UVC capture stick.
4. **USB-C Interconnect Cable**: Linking the KVM Host port to the capture dongle.
5. *Optional*: Pre-flashed MicroSD card with USBridge KVM OS (+$5).

---

## 3-Step Hardware Setup

<div align="center">
<img src="setup-low.png" width="900" alt="USBridge KVM 2.0 Low 3-Step Setup Diagram">
</div>

1. **HDMI**: Connect an HDMI cable from the computer's GPU / motherboard to the included video capture dongle on the KVM.
2. **USB-C (OTG Port)**: Connect a USB-C cable from Port 1 to the target computer for power delivery and peripheral emulation.
3. **Network**: Connect via onboard Wi-Fi 6 or pair automatically over USB gadget mode (`10.55.0.1`) using the desktop USBridge Client.

---

## CNC Aluminum Heatsinks (CAD Files)

<div align="center">
<img src="kvm20-heatsink.png" width="700" alt="Aluminum Heatsink 3D Render">
</div>

* 📦 [**Radiator_V5.step**](./Radiator_V5.step) — Longitudinal fin profile.
* 📦 [**Radiator_V6_Transverse_Ribs.step**](./Radiator_V6_Transverse_Ribs.step) — Transverse cross-cut ribs for maximum passive surface area.
* **Material**: Aluminum Alloy (6061-T6 / 6063).
