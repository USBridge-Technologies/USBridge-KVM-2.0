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
        <li><b>Capabilities:</b> Provides local access to your stored library of ISO installation discs and raw virtual bootable images (<code>.vdi</code>, <code>.vmdk</code>). Administrators can browse, select, and mount virtual storage media directly to the target host for bare-metal OS provisioning and automated infrastructure deployment — see <a href="../5-remote-disk-image-mounting/mounting-iso-images.md">Mounting ISO Images</a> and <a href="../5-remote-disk-image-mounting/booting-from-virtual-disks.md">Booting from Virtual Disks</a> for the full workflow.</li>
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

### Event Log

<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="35%" valign="top" style="border: none;">
      <img src="https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/Log.png" alt="USBridge Event Log" width="100%"/>
    </td>
    <td width="65%" valign="top" style="border: none; padding-left: 20px;">
      <ul>
        <li><b>Functional Purpose:</b> Real-time chronological system telemetry.</li>
        <li><b>Capabilities:</b> Outputs a raw text stream of device activities, authentication sequences, and system errors. Essential for local diagnostic auditing, verifying successful network handshakes, or tracking connected client logins directly from the hardware.</li>
        <li><b>Supported Operations:</b>
          <ul>
            <li><b>Details:</b> Opens an expanded, detailed view for the currently selected log entry to inspect deep metadata or error stacks.</li>
            <li><b>Filter:</b> Toggles log filters to quickly sort events by severity level or operational category (e.g., Disk, Video, System).</li>
          </ul>
        </li>
      </ul>
    </td>
  </tr>
</table>

### Settings

<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="35%" valign="top" style="border: none;">
      <img src="https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/Settings.png" alt="USBridge Settings" width="100%"/>
    </td>
    <td width="65%" valign="top" style="border: none; padding-left: 20px;">
      <ul>
        <li><b>Functional Purpose:</b> Global hardware, network, and protocol tuning.</li>
        <li><b>Capabilities:</b> The primary engine for adjusting system parameters and device states. Includes:
          <ul>
            <li><b>Network:</b> Lists every interface the appliance currently sees — Wi-Fi networks to join, or a wired connection (plug in a USB-Ethernet adapter and it appears here as <b>Ethernet: &lt;interface&gt;</b>) — select one to view or configure its IP settings.</li>
            <li><b>System Info:</b> Read-time telemetry dashboard showing core operating temperatures, firmware versions, and system resource load metrics.</li>
            <li><b>Authentication:</b> Central key authority managing the Master Key, Tailscale routing, Moonlight streaming configs, KVM SSH access, the <a href="../3-bios-in-terminal/mcp-ai-agents.md">MCP</a> AI-agent toggle, and <b>WebRTC</b> — on by default, and required for the <a href="../7-software-access/web-client.md">Web Client</a> to connect; turn it off here if you never use the browser client and want to reduce the streaming surface. The <b>Tailscale</b> submenu also carries <b>Tailscale-Only Access</b> — one switch that, once the appliance is registered on your tailnet, tears down every LAN-facing listener for <i>both</i> the REST/MCP API and the KVM SSH console, leaving only <code>127.0.0.1</code> and the tailnet IP reachable. Flip it on before you've registered and LAN stays open just long enough to complete registration, then locks itself down automatically the moment the tailnet handshake finishes — no separate step, no risk of locking yourself out mid-setup. See <a href="../10-developer-api/security-model.md#5-tailscale--an-additional-layer-but-not-for-every-path">Security &amp; Authentication Model §5</a> for the full behavior, including <b>Paranoia Mode</b>. Also home to <b>Users Control</b> — lists the appliance's real login accounts and lets you create one on the spot: pick a username, and the device generates a random password and displays both once. This is the account you SSH into for <a href="../3-bios-in-terminal/technology-overview.md">BIOS-in-Terminal</a> — there's no default account out of the box.</li>
            <li><b>SD Card:</b> Storage maintenance console containing SD card formatting tools and specific Snapshot settings.</li>
            <li><b>Display:</b> Controls panel brightness parameters, HDMI Passthrough toggles, and HDMI Vsync synchronization options.</li>
            <li><b>Language:</b> System-level UI localization adjustments.</li>
            <li><b>Updates:</b> Displays the current firmware version, with a manual Check-for-updates action and a Commit step to finalize an applied update — see <a href="../9-updates-changelog/firmware-update-guide.md">Firmware Update Guide</a> for the full A/B update flow.</li>
            <li><b>Factory Reset:</b> Erases all user environments and restores the appliance to its original factory defaults.</li>
            <li><b>Poweroff:</b> Orchestrates a safe software shutdown sequence before disconnecting physical power.</li>
          </ul>
        </li>
        <li><b>Supported Operations:</b>
          <ul>
            <li><b>Button 1 (Enter):</b> Opens the selected configuration submenu or confirms the parameter adjustment.</li>
            <li><b>Joystick Left (Back):</b> Exits the current settings tier and returns to the primary menu.</li>
          </ul>
        </li>
      </ul>
    </td>
  </tr>
</table>

### Monitor

<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="35%" valign="top" style="border: none;">
      <img src="https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/Monitor.png" alt="USBridge Monitor" width="100%"/>
    </td>
    <td width="65%" valign="top" style="border: none; padding-left: 20px;">
      <ul>
        <li><b>Functional Purpose:</b> Raw out-of-band video mirror for rapid on-site troubleshooting.</li>
        <li><b>Capabilities:</b> Bypasses all system menus to provide immediate local diagnostics directly at the server rack without requiring a dedicated crash cart or remote client connection. It streams the target host's raw video output in real time—including low-level BIOS configurations, initialization stages, boot sequences, and active operating system environments.</li>
          </ul>
        </li>
      </ul>
    </td>
  </tr>
</table>

### Scripts

<table border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="35%" valign="top" style="border: none;">
      <img src="https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/Scripts.png" alt="USBridge Scripts" width="100%"/>
    </td>
    <td width="65%" valign="top" style="border: none; padding-left: 20px;">
      <ul>
        <li><b>Functional Purpose:</b> Local hardware-level execution engine for automation tasks.</li>
        <li><b>Capabilities:</b> Displays the library of pre-loaded automation macros and Starlark routines (e.g., automated <code>Enter BIOS</code> macros, <code>Boot Selection</code> keys, or custom <code>.star</code> scripts). This allows administrators to deploy provisioning operations or recovery workflows straight from the KVM appliance without accessing a web console or client interface.</li>
        <li><b>Supported Operations:</b>
          <ul>
            <li><b>Run:</b> Instantly executes the selected automation script or macro on the connected target host.</li>
          </ul>
        </li>
      </ul>
    </td>
  </tr>
</table>
