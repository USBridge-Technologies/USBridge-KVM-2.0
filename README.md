# USBridge-KVM 2.0

> **Ultra-Low Latency IP-KVM with AI-Ready BIOS-in-Terminal, Drive Emulation, and Immutable Snapshots.**

[![Crowdsupply](https://img.shields.io/badge/USBridge-CROWDSUPPLY-blue)](https://www.crowdsupply.com/usbridge-technologies/usbridge-kvm-2-0)
[![Roadmap](https://img.shields.io/badge/USBridge-ROADMAP-green)](https://github.com/orgs/USBridge-Technologies/projects/1)
[![WEebsite](https://img.shields.io/badge/USBridge-WEBSITE-black)](https://www.usbridge.io/)

**USBridge-KVM 2.0** is a compact, professional-grade stack for system debugging and direct infrastructure control at the most fundamental level (Layer 0). It gives administrators absolute control over the hardware, bypassing the operating system while ensuring strict hardware isolation. The device provides instant, out-of-the-box server access with ultra-low latency streaming and the ability to deploy scripts or AI agents to automate routine, low-level tasks.

![USBridge Banner](Front_panel.png) 

---

## Ultra-Low Latency Streaming: Powered by Moonlight

Forget about "jelly" cursors, video stutters, and input desync. USBridge-KVM 2.0 is the first hardware KVM-over-IP featuring native, on-board integration of the **Moonlight protocol**.

The hardware video capture and transmission pipeline is optimized to reduce latency to an imperceptible level[cite: 1]. You get the absolute responsiveness of a direct connection: crystal-smooth mouse movement and instantaneous text input response. The latency is so low that the bandwidth and reaction speed are enough even for comfortable gameplay in dynamic platformers — let alone flawless server administration[cite: 1].

https://github.com/user-attachments/assets/d3a0cbbd-419b-434d-9d0d-b19d049d3041

---

## BIOS-in-Terminal: Offline OCR & Hardware-Level AI Automation

USBridge-KVM 2.0 doesn't just stream video — it understands it[cite: 1]. Our unique BIOS-in-Terminal technology intercepts the raw video signal at the hardware level, using an onboard chip with real-time offline OCR to convert BIOS interfaces and pre-boot environments (Pre-OS) into an interactive, selectable text stream.

*   **Interactive Text-Based BIOS via SSH:** Connect to the KVM using a standard SSH session to view and configure the BIOS directly inside your favorite terminal. Because the information is displayed as pure text, you can easily select and copy error codes, BIOS versions, or serial numbers straight from the console.
*   **In-Client Scripting Without "Pixel-Hunting":** Write, edit, and run robust Starlark (Python syntax) scripts directly from the app interface. The automation manager operates on recognized text: the script reliably waits for the string `"Aptio Setup Utility"` to appear, and then sends the exact scan-code (e.g., Escape) to navigate the menu.
*   **AI Agent Integration (MCP Protocol):** Through the Model Context Protocol (MCP), you can connect AI agents (like Claude) directly to the KVM. The neural network can independently "read" the terminal screen, navigate through tabs, perform system audits, and detect hardware faults (for instance, identifying a dead CMOS battery by analyzing the reset system date).

https://github.com/user-attachments/assets/2e276809-1e02-40ef-9bf8-3731e67ff98a

---

## Drive Emulation & Immutable Snapshots

### Virtual Media: Replacing Bootable Flash Drives
Universal hardware emulation allows you to mount virtual images directly from your workstation — whether it is a standard installation disc (ISO) or an entire, fully configured OS environment (VDI, VMDK). The target server sees it instantly as a standard, physically connected hard drive. The high-speed LPDDR4X cache fully compensates for network latency, while the Read-Write Overlay mode redirects all new writes to a separate layer, keeping your source Golden Image completely untouched.

### Hardware Ransomware Protection & Snapshots
During any modification, the system never overwrites the source files; instead, it saves only the "delta" of changes, instantly freezing the new copy in a read-only state. Thanks to strict hardware isolation, even if ransomware or an attacker gains full root privileges on the compromised server, they have no physical path to reach the KVM storage. All data is stored using the standard Btrfs file system.

<img width="763" height="382" alt="Storage_preview_mobil" src="https://github.com/user-attachments/assets/2704487d-ac1e-4c66-a061-8bd23642512f" />

---

## Solution Comparison

| Feature | Embedded BMC (iDRAC / iLO) | Traditional IP-KVM | USBridge 2.0 (Our Solution) |
| :--- | :--- | :--- | :--- |
| **Hardware Independence** | No (Vendor lock-in) | Yes | **Yes (Any hardware)** |
| **Screen OCR & SSH Terminal** | No | No | **Yes (On-device offline OCR)** |
| **AI Agents & Starlark Scripts**| No | No | **Yes (Built-in engine)** |
| **Immutable Snapshots** | No | No | **Yes (Btrfs, isolated)** |
| **Video Latency** | High (Web GUI) | Medium (WebRTC / MJPEG) | **Ultra-Low (Moonlight)** |
| **Power Management** | Yes | No (Requires external PDU)| **Yes (Module included)** |
| **Virtual Media** | Yes (Often requires license)| Model dependent | **Yes (Out-of-the-box + Cache)** |


---

## Unified Ecosystem: USBridge-Remote

Control your entire infrastructure from a single point using **USBridge-Remote** — a cross-platform agent application that provides a hybrid access approach within a single interface[cite: 1]:

*   **Hardware Level (Layer 0):** Add USBridge-KVM devices for direct BIOS access, media mounting, and bare-metal recovery of "dead" machines.
*   **Software Level (OS-level):** Add lightweight software agents for quick desktop management inside an already booted operating system.

<img width="1992" height="1385" alt="Remote" src="https://github.com/user-attachments/assets/f9075029-e597-46c8-a532-a89395e351b6" />


The application will be released under an Open Source license as soon as the final code polishing is finished on [GitHub](https://github.com/USBridge-Technologies/USBridge-Remote).

---

## Technical Specifications

### Hardware Architecture
*   **SoC:** Radxa Zero 3W (Rockchip RK3566, Quad-Core Cortex-A55).
*   **Memory (RAM):** 2 GB LPDDR4X (partially allocated for high-speed Virtual Media caching).
*   **Cooling:** Custom CNC-milled aluminum heatsinks with an active cooling fan to prevent thermal throttling.
*   **Display:** Integrated IPS screen (240x240) for instant POST status monitoring via the built-in display mode.
*   **Power Management:** Dedicated **Power Management Module** board for hardware-level server power control.
*   **Enclosure:** Premium 3D-printed SLS Nylon PA12 case.

### Interfaces & Ports
*   **Video Capture:** Hardware-level UVC capture supporting 1080p@45fps / 720p@60fps via an external USB dongle, natively integrated with Moonlight.
*   **USB Type-C (2 ports):**
    *   *Port 1 (OTG):* Keyboard/mouse emulation, image mounting (Mass Storage), and power delivery input.
    *   *Port 2 (Host):* Dedicated port for connecting the external USB video capture dongle.
*   **Server Power Control (ATX):** 8-pin GPIO interface with external Power/Reset adapter board.
*   **Network:** Built-in Wi-Fi 6 module.
*   **Snapshots:** Dedicated MicroSD card slot.
*   **HDMI Passthrough:** Micro HDMI port for local video output at the server rack.

---

*Control. Protect. Recover.*
