# USBridge-KVM 2.0 Technical Documentation

Welcome to the official documentation repository. Use the categorized hub below to step through our core technical specs, deployment guides, and hardware blueprints.

---

<table width="100%" style="width: 100%; display: table; table-layout: fixed; border-collapse: collapse;">
<tbody>
<tr>
<td valign="top" width="50%">
<div align="center"><img src="https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/path_to_getting_started_icon.png" width="80" height="80" style="background: transparent !important; border: none !important;" /><br><strong>Getting Started</strong></div><br>
Unbox, wire up, and initialize your physical KVM appliance.
<ul>
<li><a href="./content/1-getting-started/quick-start.md">Quick Start Guide</a></li>
<li><a href="./content/1-getting-started/whats-in-the-box.md">What’s in the Box</a></li>
<li><a href="./content/1-getting-started/initial-setup.md">Initial Client Setup</a></li>
<li><a href="./content/1-getting-started/device-status-menu.md">Onboard Status & Menu Layout</a></li>
</ul>
</td>
<td valign="top" width="50%">
<div align="center"><img src="https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/path_to_kvm_icon.png" width="80" height="80" style="background: transparent !important; border: none !important;" /><br><strong>KVM Engine</strong></div><br>
Configure streaming parameters, peripheral overlays, and inputs.
<ul>
<li><a href="./content/2-kvm-vkm/video-streaming-quality.md">Video Streaming & Quality (Moonlight)</a></li>
<li><a href="./content/2-kvm-vkm/audio-redirection.md">Audio Redirection Specification</a></li>
<li><a href="./content/2-kvm-vkm/gamepad.md">Gamepad Emulation (HID)</a></li>
<li><a href="./content/2-kvm-vkm/network.md">Network Routing Environments</a></li>
</ul>
</td>
</tr>
<tr>
<td valign="top">
<div align="center"><img src="https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/path_to_bios_icon.png" width="80" height="80" style="background: transparent !important; border: none !important;" /><br><strong>BIOS-in-Terminal</strong></div><br>
Low-level raw terminal redirection and headless control text streams.
<ul>
<li><a href="./content/3-bios-in-terminal/technology-overview.md">Technology Overview</a></li>
<li><a href="./content/3-bios-in-terminal/supported-bios-uefi-types.md">Supported BIOS/UEFI Types</a></li>
<li><a href="./content/3-bios-in-terminal/logging-automation.md">Logging & Boot Automation</a></li>
</ul>
</td>
<td valign="top">
<div align="center"><img src="https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/path_to_snapshots_icon.png" width="80" height="80" style="background: transparent !important; border: none !important;" /><br><strong>Snapshots & States</strong></div><br>
Btrfs-driven immutable file storage and read-only data snapshots.
<ul>
<li><a href="./content/4-snapshots-state-management/snapshots-overview.md">Snapshots Architecture Overview</a></li>
<li><a href="./content/4-snapshots-state-management/creating-managing-snapshots.md">Creating & Managing State Files</a></li>
<li><a href="./content/4-snapshots-state-management/security-storage.md">Security & Immutable Storage Rules</a></li>
</ul>
</td>
</tr>
<tr>
<td valign="top">
<div align="center"><img src="https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/path_to_media_icon.png" width="80" height="80" style="background: transparent !important; border: none !important;" /><br><strong>Virtual Media & Drive Emulation</strong></div><br>
High-speed bare-metal OS provisioning and diskless booting via virtual block devices.
<ul>
<li><a href="./content/5-remote-disk-image-mounting/mounting-iso-images.md">Mounting ISO Images</a></li>
<li><a href="./content/5-remote-disk-image-mounting/booting-from-virtual-disks.md">Booting Server from Workstation Drives & VMs</a></li>
</ul>
</td>
<td valign="top">
<div align="center"><img src="https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/path_to_hardware_icon.png" width="80" height="80" style="background: transparent !important; border: none !important;" /><br><strong>Hardware & Power</strong></div><br>
Physical pinouts, schematic internals, power logic, and cooling.
<ul>
<li><a href="./content/6-hardware-connectivity/ports-connectors-reference.md">Ports & Connectors Reference</a></li>
<li><a href="./content/6-hardware-connectivity/power-thermal.md">Power Limits & Thermal Behavior</a></li>
<li><a href="./content/6-hardware-connectivity/architecture.md">SoC Platform Architecture</a></li>
<li><a href="./content/6-hardware-connectivity/power-management-module-control.md">PMM Relay Controlling</a></li>
</ul>
</td>
</tr>
<tr>
<td valign="top">
<div align="center"><img src="https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/path_to_software_icon.png" width="80" height="80" style="background: transparent !important; border: none !important;" /><br><strong>Software Apps</strong></div><br>
Cross-platform management clients and mobile application runtimes.
<ul>
<li><a href="./content/7-software-access/desktop-app.md">Desktop Client (Win / Mac / Linux)</a></li>
<li><a href="./content/7-software-access/mobile-app.md">Mobile Companion App</a></li>
</ul>
</td>
<td valign="top">
<div align="center"><img src="https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/path_to_support_icon.png" width="80" height="80" style="background: transparent !important; border: none !important;" /><br><strong>Maintenance</strong></div><br>
General troubleshooting routines and emergency system recoveries.
<ul>
<li><a href="./content/8-maintenance-support/faq.md">Frequently Asked Questions</a></li>
<li><a href="./content/8-maintenance-support/factory-reset.md">Factory Reset Protocol</a></li>
</ul>
</td>
</tr>
</tbody>
</table>

---

### 🔄 Updates, Blueprints & Changelogs
* 📦 [Firmware Update Guide](./content/9-updates-changelog/firmware-update-guide.md) — Step-by-step flashing procedures and OTA requirements.
* 💻 [Desktop App Updates](./content/9-updates-changelog/desktop-app-updates.md) — Client software revision tracking.
* 📝 [Version History](./content/9-updates-changelog/version-history.md) — Comprehensive technical system changelogs.
* 📐 [3D Models & PCB Files](./content/9-updates-changelog/3d-models-pcb-files.md) — CAD drawings, casing files, and schematic print layouts.
