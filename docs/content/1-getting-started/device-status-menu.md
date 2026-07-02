# Onboard Device Status & Menu Navigation

The USBridge appliance features an integrated front-panel IPS display and a physical 5-way directional joystick, allowing administrators to perform immediate, on-site diagnostics and local configuration without requiring active network access or an external workstation.

---

## 1. Front Panel Hardware Interface

The physical interface on the front of the unit is engineered for rapid interaction directly at the server rack or your desk:

![USBridge Front Panel Interface](https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/Front_Panel_Interface.png)

* **[1] Button 1:** Configurable context action / Primary confirmation button (e.g., used to switch views or display plaintext credentials).
* **[2] Button 2:** Dedicated context button for secondary actions or quick system shortcuts.
* **[3] Button 3:** Dedicated context button for system-level functions or navigation adjustments.
* **[4] 5-Way Directional Joystick:** Your primary navigation control (non-rotating). 
  * *Up / Down / Left / Right:* Moves the selection cursor, navigates menus, or adjusts numerical values.
  * *Center Click / Press:* Confirms the active selection, enters submenus, or toggles selected states.
* **[5] IPS Display (240x240):** Provides a high-contrast, real-time readout of critical system metrics, system initialization states, active network profiles, and local interface menus.

---

## 2. Main Menu Reference Specification

The interface is divided into six core functional submenus:

###  Drives 

<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="35%" valign="top" style="border: none;">
      <img src="https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/Drives.png" alt="USBridge Drives" width="100%"/>
    </td>
    <td width="65%" valign="top" style="border: none; padding-left: 20px;">
      <ul>
        <li><b>Functional Purpose:</b> High-speed storage mapping interface.</li>
        <li><b>Capabilities:</b> Provides local access to your stored library of ISO installation discs and raw virtual bootable images (<code>.vdi</code>, <code>.vmdk</code>). Administrators can browse, select, and mount virtual storage media directly to the target host for bare-metal OS provisioning and automated infrastructure deployment.</li>
        <li><b>Supported Operations:</b>
          <ul>
            <li><b>Mount:</b> Instantly maps the selected image file to the target host as a virtual drive.</li>
            <li><b>Unmount:</b> Safely disconnects the currently mounted image from the system.</li>
            <li><b>Refresh:</b> Rescans the underlying storage directory to update the available files list.</li>
          </ul>
        </li>
      </ul>
    </td>
  </tr>
</table>

### Snapshots 

<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="35%" valign="top" style="border: none;">
      <img src="https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/Snapshot.png" alt="USBridge Snapshots" width="100%"/>
    </td>
    <td width="65%" valign="top" style="border: none; padding-left: 20px;">
      <ul>
        <li><b>Functional Purpose:</b> Btrfs-driven immutable data protection console.</li>
        <li><b>Capabilities:</b> Displays a structured chronological list of your data snapshots. Allows you to review block-level deltas, trigger manual captures, or restore previously saved states. This creates an isolated, hardware-level immutable defense line against accidental deletion or ransomware payloads on the target machine.</li>
        <li><b>Supported Operations:</b>
          <ul>
            <li><b>Mount:</b> Mounts the selected snapshot directly to the host machine, making it appear instantly as a standard USB flash drive for data recovery.</li>
            <li><b>(Unmount:</b> Safely disconnects the mounted snapshot drive from the host system.</li>
            <li><b>(Refresh:</b> Re-indexes the storage directory to update the list of available snapshots.</li>
          </ul>
        </li>
      </ul>
    </td>
  </tr>
</table>
</table>

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
