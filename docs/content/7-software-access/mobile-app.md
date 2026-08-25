# Mobile App

The USBridge mobile application provides full out-of-band KVM access and storage workflow management from mobile devices, maintaining feature parity with the desktop client architecture. It's the same open-source **USBridge-Remote** codebase as the [desktop client](./desktop-app.md): [github.com/USBridge-Technologies/USBridge-Remote](https://github.com/USBridge-Technologies/USBridge-Remote).

## Client Downloads

* **iOS:** [App Store](https://apps.apple.com/us/app/usbridge-client/id6787665935)
* **Android:** [Google Play](https://play.google.com/store/apps/details?id=io.usbridge.client) — a self-updating APK is also published on the [latest release](https://github.com/USBridge-Technologies/USBridge-Remote/releases/latest) if you'd rather install without a Play Store account.

No mobile client on hand? The [Web Client](./web-client.md) also runs in a mobile browser, no install required.

---

## Connection Initialization

As with the desktop architecture, session initialization requires inputting the target appliance's assigned IP address, or scanning the pairing QR code from the front panel.

Upon successful authentication, the mobile interface provisions access to the same four tabs as desktop — see [Desktop Client](./desktop-app.md#connection-initialization) for the full breakdown of **Control**, **Devices**, **Snapshots**, and **Scripts**; the mobile-specific notes are below.

### 1. Devices Tab (Hardware Passthrough)

Governs the configuration of virtual peripherals and external media exposed to the target host.

* **Input Emulation:** Configures composite USB HID injection for baseline keyboard and pointer emulation, retaining hardware-level compatibility for BIOS, text-based UEFI, and pre-OS environments.
* **Virtual Media Staging:** Facilitates the remote mounting of `.iso` images or virtual drives directly from the cross-platform client, enabling bare-metal OS installation without physical media presence.

### 2. Control Tab (Live KVM)

A mobile KVM console for live monitoring and direct terminal interaction with the remote server.

* **Video Ingestion Path:** Host video is routed through the standard USB Video Class (UVC) pipeline. The mobile client rendering engine is optimized for the stable capture of text-heavy pre-OS screens and terminal interfaces.

### 3. Snapshots Tab

Centralized telemetry for the appliance's storage — see [Creating & Managing Snapshots](../4-snapshots-state-management/creating-managing-snapshots.md) for the mount/recover workflow.

| Storage Mechanic | Technical Implementation |
| :--- | :--- |
| **Data Persistence** | Block-level data retention is governed by the native Btrfs Copy-on-Write (CoW) algorithm, ensuring highly efficient delta storage. |
| **WORM Protection** | All snapshots are structurally locked as immutable, read-only Btrfs subvolumes. This guarantees absolute resilience against target-host ransomware encryption or intentional deletion attempts. |
| **Cross-Platform Access** | The appliance exports the storage repository via standard Media Transfer Protocol (MTP) or as a generic USB block device. Snapshot files are natively readable on client machines without requiring proprietary formats or third-party drivers. |

### 4. Scripts Tab

Same [Starlark script](../3-bios-in-terminal/scripting-automation.md) management as desktop — create, edit, run, and delete scripts, plus the [MCP proxy toggle](../3-bios-in-terminal/mcp-ai-agents.md#option-a-the-client-apps-mcp-proxy) — directly from your phone.
