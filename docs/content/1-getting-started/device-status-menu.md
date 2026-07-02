# Onboard Device Status & Menu Navigation

The USBridge appliance features an integrated front-panel IPS display and a physical rotary encoder, allowing administrators to perform immediate, on-site diagnostics and local configuration without requiring active network access or an external workstation.

---

## 1. Front Panel Hardware Interface

The physical interface on the front of the unit is engineered for rapid interaction directly at the server rack or your desk:

* **IPS Display (240x240):** Provides a high-contrast, real-time readout of critical system metrics, system initialization states, and direct video monitoring.
* **Rotary Encoder (With Click/Push Button):** Your primary input control. 
  * *Rotate:* Scroll through menu items, adjust parameters, or move cursors.
  * *Single Click/Press:* Confirm selection, enter submenus, or toggle states.
  * *Long Press (2 seconds):* Return to the previous menu or cancel the current operation.

---

## 2. Main Menu Reference Specification

When you press the rotary encoder from the main status screen, the appliance unlocks the local management engine. The interface is divided into five core functional submenus:

### 💿 Drives (Virtual Media Manager)
* **Functional Purpose:** High-speed storage mapping interface.
* **Capabilities:** Provides local access to your stored library of ISO installation discs and raw virtual bootable images (`.vdi`, `.vmdk`). Administrators can browse, select, and mount virtual storage media directly to the target host for bare-metal OS provisioning and automated infrastructure deployment.

### 💾 Snapshots (State Registry)
* **Functional Purpose:** Btrfs-driven immutable data protection console.
* **Capabilities:** Displays a structured chronological list of your data snapshots. Allows you to review block-level deltas, trigger manual captures, or restore previously saved states. This creates an isolated, hardware-level immutable defense line against accidental deletion or ransomware payloads on the target machine.

### 📑 Event Log (Diagnostic Audit)
* **Functional Purpose:** Real-time chronological system telemetry.
* **Capabilities:** Outputs a raw text stream of device activities, authentication sequences, and system errors. Essential for local diagnostic auditing, verifying successful network handshakes, or tracking connected client logins directly from the hardware.

### ⚙️ Settings (Central Configuration Hub)
* **Functional Purpose:** Global hardware and protocol tuning.
* **Capabilities:** The primary engine for adjusting system parameters. Includes:
  * **Wi-Fi / Internet:** Local network provisioning and Tailscale connectivity status.
  * **Auth Tokens:** Generation and display of client pairing keys and QR codes.
  * **Hardware Control:** Display brightness calibration, fan curve tuning, and storage maintenance.
  * **Localization:** System language selection.

### 📺 Monitor (Direct Video Diagnostic)
* **Functional Purpose:** Raw out-of-band video mirror.
* **Capabilities:** Bypasses all menu layers to engage a direct diagnostic loop. This streams the target host's raw GPU output (including low-level BIOS screens and boot sequences) directly onto the built-in LCD screen, making local crash troubleshooting instant.
