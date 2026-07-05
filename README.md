# USBridge-KVM 2.0

> **Ultra-Low Latency IP-KVM with AI-Ready BIOS-in-Terminal, Drive Emulation, and Immutable Snapshots.**

[![Crowdsupply](https://img.shields.io/badge/USBridge-CROWDSUPPLY-blue)](https://www.crowdsupply.com/usbridge-technologies/usbridge-kvm-2-0)
[![Roadmap](https://img.shields.io/badge/USBridge-ROADMAP-green)](https://github.com/orgs/USBridge-Technologies/projects/1)
[![WEebsite](https://img.shields.io/badge/USBridge-WEBSITE-black)](https://www.usbridge.io/)

**USBridge-KVM 2.0** is a compact, professional-grade stack for system debugging and direct infrastructure control at the most fundamental level (Layer 0). It gives administrators absolute control over the hardware, bypassing the operating system while ensuring strict hardware isolation. The device provides instant, out-of-the-box server access with ultra-low latency streaming and the ability to deploy scripts or AI agents to automate routine, low-level tasks.

<img width="1600" height="791" alt="Front_panel4" src="https://github.com/user-attachments/assets/4647b9a7-83b7-49ab-a51d-4b8f76e8eeca" />

---

## Ultra-Low Latency Streaming: Powered by Moonlight

Forget about "jelly" cursors, video stutters, and input desync. USBridge-KVM 2.0 is the first hardware KVM-over-IP featuring native, on-board integration of the **Moonlight protocol**.

The hardware video capture and transmission pipeline is optimized to reduce latency to an imperceptible level. You get the absolute responsiveness of a direct connection: crystal-smooth mouse movement and instantaneous text input response. The latency is so low that the bandwidth and reaction speed are enough even for comfortable gameplay in dynamic platformers — let alone flawless server administration.

https://github.com/user-attachments/assets/d3a0cbbd-419b-434d-9d0d-b19d049d3041

---

## BIOS-in-Terminal: Offline OCR & Hardware-Level AI Automation

USBridge-KVM 2.0 doesn't just stream video — it understands it. Our unique BIOS-in-Terminal technology intercepts the raw video signal at the hardware level, using an onboard chip with real-time offline OCR to convert BIOS interfaces and pre-boot environments (Pre-OS) into an interactive, selectable text stream.

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

<img width="1200" height="324" alt="Immutable_Snapshots2" src="https://github.com/user-attachments/assets/a501cb97-93e6-4c02-a29a-9e3fb8f58d0a" />

---

## Solution Comparison

| Feature | USBridge 2.0 (Our Solution) | Embedded BMC (iDRAC / iLO) | Traditional IP-KVM |
| :--- | :--- | :--- | :--- |
| **Hardware Independence** | **Yes (Any hardware)** | No (Vendor lock-in) | Yes |
| **Screen OCR & SSH Terminal** | **Yes (On-device offline OCR)** | No | No |
| **AI Agents & Starlark Scripts**| **Yes (Built-in engine)** | No | No |
| **Immutable Snapshots** | **Yes (Btrfs, isolated)** | No | No |
| **Video Latency** | **Ultra-Low (Moonlight)** | High (Web GUI) | Medium (WebRTC / MJPEG) |
| **Power Management** | **Yes (Module included)** | Yes | No (Requires external PDU) |
| **Virtual Media** | **Yes (Out-of-the-box + Cache)** | Yes (Often requires license) | Model dependent |


---

## Client Download Matrix

<img width="6272" height="2588" alt="USBridge_ap4p" src="https://github.com/user-attachments/assets/7d377a53-9e13-41fb-b31d-bc1f94378126" />

The Client is the control interface installed on your workstation, laptop, or mobile device. It manages active hardware connections, live remote desktop streaming, virtual device passthrough, and your snapshot registry.

| Architecture | Windows | macOS | Linux | Android | iOS (iPhone) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **x86_64** | [Download](https://github.com/USBridge-Technologies/USBridge-Remote/releases/download/v2.0.1/USBridge_client_windows_amd64-2.0.1.zip) | — | [Download](https://github.com/USBridge-Technologies/USBridge-Remote/releases/download/v2.0.1/USBridge_client_linux_amd64-2.0.1.tar.gz) | — | — |
| **ARM64** | — | [Download](https://github.com/USBridge-Technologies/USBridge-Remote/releases/download/v2.0.1/USBridge_client_macOS_arm64-2.0.1.zip) | — | [Download](https://github.com/USBridge-Technologies/USBridge-Remote/releases/download/v2.0.1/USBridge_client_android_arm64-2.0.1.apk) | In progress |

---

## Unified Ecosystem: [USBridge-Remote](https://github.com/USBridge-Technologies/USBridge-Remote)

<details>
<summary>📸 Click to preview USBridge-Remote Agent Interface</summary>
<br>

<img width="4960" height="1644" alt="Screenshot 2026-05-03 20112н0" src="https://github.com/user-attachments/assets/9f72f6fa-aad0-4d09-b886-22a4d9ba1538" />

</details>

Control your entire infrastructure from a single point using **[USBridge-Remote](https://github.com/USBridge-Technologies/USBridge-Remote)** — our dedicated cross-platform agent application. It enables a hybrid access approach within a single interface, combining hardware and software-level management:

* **Hardware Level (Layer 0):** Add USBridge-KVM devices for direct BIOS access, media mounting, and bare-metal recovery of "dead" machines.
* **Software Level (OS-level):** Deploy this lightweight software agent inside an already booted operating system for instant desktop management without KVM hardware dependency.

### Agent Download Matrix

The agent runs as a background service on your target OS (servers, remote workstations, or headless nodes) to stream the desktop and execute system-level commands.

| Architecture | Windows | macOS | Linux |
| :--- | :---: | :---: | :---: |
| **x86_64** | [Download](https://github.com/USBridge-Technologies/USBridge-Remote/releases/download/v2.0.2/USBridge_agent_windows_amd64-2.0.2.zip) | — | [Download](https://github.com/USBridge-Technologies/USBridge-Remote/releases/download/v2.0.2/USBridge_agent-linux-x86_64-2.0.2.AppImage) |
| **ARM64** | — | [Download](https://github.com/USBridge-Technologies/USBridge-Remote/releases/download/v2.0.1/USBridge_agent_macOS_amd64-2.0.1.zip) | — |

> [!TIP]
> **Open Source Roadmap:** The USBridge-Remote agent application is slated to be fully Open Source. I am currently polishing the codebase and refactoring the core logic. Pre-compiled binaries and the official source code repository will be published incrementally in the near future. Stay tuned for updates!

---

## Technical Specifications

<img width="1497" height="741" alt="6" src="https://github.com/user-attachments/assets/47bfbbcd-cda0-4b17-b3a1-a7ab7ad03fd9" />

### Hardware Architecture
*   **SoC:** Radxa Zero 3W (Rockchip RK3566, Quad-Core Cortex-A55).
*   **Cooling:** Custom CNC-milled aluminum heatsinks with an active cooling fan to prevent thermal throttling.
*   **Display:** Integrated IPS screen (240x240) for instant POST status monitoring via the built-in display mode.
*   **Power Management:** Dedicated **Power Management Module** board for hardware-level server power control.
*   **Enclosure:** Premium 3D-printed SLS Nylon PA12 case.

### Interfaces & Ports
*   **Video Capture:** Hardware-level UVC capture supporting 1080p@30fps / 720p@60fps via an external USB dongle, natively integrated with Moonlight.
*   **USB Type-C (2 ports):**
    *   *Port 1 (OTG):* Keyboard/mouse emulation, image mounting (Mass Storage), and power delivery input.
    *   *Port 2 (Host):* Dedicated port for connecting the external USB video capture dongle.
*   **Power Management Module:** 8-pin GPIO interface with external Power/Reset adapter board.
*   **Network:** Built-in Wi-Fi 6 module.
*   **Snapshots:** Dedicated MicroSD card slot.
*   **HDMI Passthrough:** Micro HDMI port for local video output at the server rack.

---

# Quick Start Guide

## 1. Hardware Connection & Cables

<img width="2553" height="690" alt="Ports2" src="https://github.com/user-attachments/assets/761ffe47-70c7-44d6-9d2f-a1aba24df787" />

* **Port 1 (OTG):** Connect this port to the target server/PC. It delivers power to the KVM, emulates the mouse/keyboard, and handles virtual media mounting.
* **Port 2 (Host):** Connect the external video capture dongle here. Link the dongle to your server's video output using an HDMI cable.

> [!IMPORTANT]
> **Critical: Video Capture Dongle Modes**
> The USB Type-C capture dongle operates in two different modes depending on its orientation when plugged into the port. Please verify its status in the app:
> * **`[5G]` Mode (USB 3.0):** Standard high-performance mode. It provides maximum bandwidth (5 Gbps), rich image quality, and ultra-low input lag. **This is your target mode.**
> * **`[480M]` Mode (USB 2.0):** Slow compatibility mode (480 Mbps). The video stream may suffer from compression artifacts or noticeable latency.
> 
> **The Fix:** If you see the `[480M]` status, simply unplug the Type-C cable from the KVM, flip it 180°, and plug it back in to lock onto the `[5G]` mode.

---

## 2. Network & Application Setup

1. **Network Configuration:** The device comes with built-in Wi-Fi 6 and native Tailscale integration for instant remote access without messy router/firewall configurations. For initial Wi-Fi setup, use the integrated on-board IPS display or the local web panel.
2. **Firmware Update:** Once connected to the internet, navigate to the settings and update the device to the latest firmware version. Please allow a couple of minutes for the initial server synchronization.
3. **Launch:** Open the **USBridge-Client** application, add your new device using its IP address, and you are ready to go.
4. **Snapshot Setup (Data Protection):** Insert a MicroSD card into the KVM slot, open the device settings in the client app, and format the card. Once formatted, a backup drive will appear under the "Snapshots" tab, running a Btrfs-based Read-Write Overlay mode to protect your data.

### Connecting to BIOS-in-Terminal via SSH:
1. In the app interface, go to **Settings** -> **Authentication** -> **User Control** -> **Create User**.
2. Set up a username and password for authorization.
3. Open your favorite terminal emulator and run:
   ```bash
   ssh user@<kvm_ip_address> 
4. When prompted, enter the password you created in Step 2.

**Ready for Action!**
Once authorized, your terminal will instantly clear and start rendering the BIOS/Pre-OS video signal directly into your console as a live, interactive text stream. You can now select error codes, copy serial numbers, or pass automated Starlark scripts straight through the terminal session.

> [!WARNING]
> At this stage, the BIOS-in-Terminal feature exclusively supports text-based BIOS screens. Graphical UEFI interfaces are not yet recognized. You may notice minor character artifacts due to the OCR engine—the processing logic is being actively optimized, and accuracy will be perfected by the final release.

---

## 3. Power Management Module

To enable direct hardware-level power management (power on, power off, hard reset), use the included expansion board:

<img width="2553" height="690" alt="Power Management Module" src="https://github.com/user-attachments/assets/640567b0-d75c-4a44-93db-6e8fdcb19661" />


* **Input:** A pre-wired ribbon cable is already connected to the expansion module. Plug its other end into the **8-pin GPIO header** on the USBridge-KVM chassis.
* **Output (to the server's motherboard):** Connect the individual pins on the opposite side of the module to the **Front Panel** headers of your motherboard. Follow the white silk-screen labels on the PCB:

| Expansion Board Pin | Target Motherboard Header | Description |
| :--- | :--- | :--- |
| **`\|PWR\|`** | **Power Switch** (PWR_SW / PW_SW) | Powers the server on or off |
| **`\|RST\|`** | **Reset Switch** (RESET / RST) | Triggers a hard hardware reset |
| **`\|LED1\|`** | **Power LED** (P_LED) | Reports the server's power status to the client, even if there is no video signal |
| **`\|LED2\|`** | **HDD LED** (H_LED) | Displays storage drive activity inside the client UI |

---

## What's in the Box (Package Contents)

<img width="1800" height="964" alt="3" src="https://github.com/user-attachments/assets/db8e946e-7e39-486a-8058-10f6d511dedd" />

Every USBridge-KVM 2.0 kit comes with all the essential hardware and cables required for an out-of-the-box deployment:

1. **Premium SLS Case:** The main USBridge-KVM 2.0 unit enclosed in a durable, 3D-printed SLS Nylon PA12 housing with an integrated post-status IPS display.
2. **HDMI Video Capture Dongle:** High-performance external hardware-level UVC capture stick (supporting 1080p@30fps / 720p@60fps).
3. **USB Type-C to Type-C Cable:** High-speed data cable used to interconnect the host port of the KVM and the capture dongle.
4. **Power Management Module Board:** Dedicated adapter PCB for hardware-level server power control (Power/Reset/LEDs), complete with a pre-wired ribbon cable.
5. **Female-to-Female Dupont Jumper Wires:** Colorful 8-pin jumper wire set to easily bridge the Power Module board directly to your server's motherboard front panel headers.

> [!NOTE]
> **What else you might need:** To connect the setup to your server, you will only need a standard HDMI cable to link your server's GPU output directly to the included video capture dongle. Everything else is already in the box!

*Control. Protect. Recover.*
