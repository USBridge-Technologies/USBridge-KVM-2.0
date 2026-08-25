# Mobile App

The USBridge mobile application provides full out-of-band KVM access and storage workflow management from mobile devices, maintaining feature parity with the desktop client architecture. It's the same open-source **USBridge-Remote** codebase as the [desktop client](./desktop-app.md): [github.com/USBridge-Technologies/USBridge-Remote](https://github.com/USBridge-Technologies/USBridge-Remote).

## Client Downloads

* **iOS:** [App Store](https://apps.apple.com/us/app/usbridge-client/id6787665935)
* **Android:** APK direct from the [latest release](https://github.com/USBridge-Technologies/USBridge-Remote/releases/latest) (a self-updating ARM64 build is also published there — no Play Store account or F-Droid required).

No mobile client on hand? The [Web Client](./web-client.md) also runs in a mobile browser, no install required.

---

## Connection Initialization

As with the desktop architecture, session initialization requires inputting the target appliance's assigned IP address, or scanning the pairing QR code from the front panel.

Upon successful authentication, the mobile interface provisions access to three primary operational modules: **Device**, **Control**, and **Snapshots**.

### 1. Device Module (Hardware Passthrough)

The Device tab governs the configuration of virtual peripherals and external media exposed to the target host.

* **Input Emulation:** Configures composite USB HID injection for baseline keyboard and pointer emulation, retaining hardware-level compatibility for BIOS, text-based UEFI, and pre-OS environments.
* **Virtual Media Staging:** Facilitates the remote mounting of `.iso` images or virtual drives directly from the cross-platform client, enabling bare-metal OS installation without physical media presence.

### 2. Control Module (Live KVM)

The Control tab functions as a mobile KVM console for live monitoring and direct terminal interaction with the remote server.

* **Video Ingestion Path:** Host video is routed through the standard USB Video Class (UVC) pipeline. The mobile client rendering engine is optimized for the stable capture of text-heavy pre-OS screens and terminal interfaces.

### 3. Snapshots Module

The Snapshots tab provides centralized telemetry for the appliance's attached storage media (SD card, external SSD, or HDD) and manages hardware-level backup artifacts.

| Storage Mechanic | Technical Implementation |
| :--- | :--- |
| **Data Persistence** | Block-level data retention is governed by the native Btrfs Copy-on-Write (CoW) algorithm, ensuring highly efficient delta storage. |
| **WORM Protection** | All snapshots are structurally locked as immutable, read-only Btrfs subvolumes. This guarantees absolute resilience against target-host ransomware encryption or intentional deletion attempts. |
| **Cross-Platform Access** | The appliance exports the storage repository via standard Media Transfer Protocol (MTP) or as a generic USB block device. Snapshot files are natively readable on client machines without requiring proprietary formats or third-party drivers. |
