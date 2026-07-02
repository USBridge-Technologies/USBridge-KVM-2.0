# Mobile App

The USBridge mobile application provides full out-of-band KVM access and storage workflow management from mobile devices, maintaining feature parity with the desktop client architecture.

## Client Downloads

Native mobile binaries for iOS and Android platforms are currently undergoing validation and will be published shortly.

### Planned Releases

* **iOS:** App Store link *(Coming soon)*
* **Android:** Google Play link *(Coming soon)*

---

## Connection Initialization

As with the desktop architecture, session initialization requires inputting the target appliance's assigned IP address.

Upon successful authentication, the mobile interface provisions access to three primary operational modules: **Device**, **Control**, and **Snapshots**.

### 1. Device Module (Hardware Passthrough)

The Device tab governs the configuration of virtual peripherals and external media exposed to the target host.

* **Input Emulation:** Configures composite USB HID injection for baseline keyboard and pointer emulation, retaining hardware-level compatibility for BIOS, text-based UEFI, and pre-OS environments.
* **Virtual Media Staging:** Facilitates the remote mounting of `.iso` images or virtual drives directly from the cross-platform client, enabling bare-metal OS installation without physical media presence.

### 2. Control Module (Live KVM)

The Control tab functions as a mobile KVM console for live monitoring and direct terminal interaction with the remote server.

* **Video Ingestion Path:** Host video is routed through the standard USB Video Class (UVC) pipeline. The mobile client rendering engine is optimized for the stable capture of text-heavy pre-OS screens and terminal interfaces.
* **Latency Profile:** Typical glass-to-glass latency operates between 80–150 ms over a local area network (LAN). When accessing the mobile client via a standard Wi-Fi network, expected latency typically scales to 120–250 ms.

### 3. Snapshots Module

The Snapshots tab provides centralized telemetry for the appliance's attached storage media (SD card, external SSD, or HDD) and manages hardware-level backup artifacts.

| Storage Mechanic | Technical Implementation |
| :--- | :--- |
| **Data Persistence** | Block-level data retention is governed by the native Btrfs Copy-on-Write (CoW) algorithm, ensuring highly efficient delta storage. |
| **WORM Protection** | All snapshots are structurally locked as immutable, read-only Btrfs subvolumes. This guarantees absolute resilience against target-host ransomware encryption or intentional deletion attempts. |
| **Cross-Platform Access** | The appliance exports the storage repository via standard Media Transfer Protocol (MTP) or as a generic USB block device. Snapshot files are natively readable on client machines without requiring proprietary formats or third-party drivers. |
