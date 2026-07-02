# Desktop Client (Win/Mac/Linux)

The USBridge desktop application serves as the primary administrative interface for out-of-band KVM control, virtual media provisioning, and hardware-level snapshot management.

## Client Downloads

Native binaries for Windows, macOS, and Linux architectures are currently undergoing final validation and will be published to this repository shortly.

### Planned Releases

* **Windows:** Download `.exe` *(Coming soon)*
* **macOS:** Download `.dmg` *(Coming soon)*
* **Linux:** Download package *(Coming soon)*

---

## Connection Initialization

To initiate a remote session, input the appliance's assigned IP address into the client's connection manager (e.g., `192.168.1.110`).

Upon successful authentication, the interface provisions access to three primary operational modules: **Device**, **Control**, and **Snapshots**.

### 1. Device Module (Hardware Passthrough)

The Device tab governs the configuration of virtual peripherals and the mounting of remote storage media to the target host.

* **Input Emulation:** Configures composite USB HID injection for keyboard and pointer control, heavily optimized for deterministic behavior within BIOS and text-based UEFI environments.
* **Virtual Media Staging:** Facilitates the remote attachment of bootable `.iso` images or virtual drives over the network, entirely bypassing the need for physical media during bare-metal OS provisioning.

### 2. Control Module (Live KVM)

The Control tab functions as the primary interactive workspace for remote administrative operations.

It renders the real-time UVC video stream captured from the target host and bi-directionally routes local keyboard and pointer inputs back to the server. This module is utilized extensively for direct BIOS interaction, pre-OS navigation, and bare-metal recovery sequences.

### 3. Snapshots Module

The Snapshots tab provides centralized telemetry for the appliance's physically attached storage media (SD card, external SSD, or HDD). It surfaces current storage utilization metrics and exposes a chronological registry of all captured file-system states, complete with exact timestamp metadata.

| Storage Mechanic | Technical Implementation |
| :--- | :--- |
| **Data Persistence** | Block-level data retention is governed by the native Btrfs Copy-on-Write (CoW) algorithm, ensuring highly efficient delta storage. |
| **WORM Protection** | All snapshots surfaced in the client are structurally locked as immutable, read-only subvolumes. This guarantees absolute resilience against target-host ransomware encryption or accidental deletion. |
| **Cross-Platform Access** | The appliance exports the storage repository via standard Media Transfer Protocol (MTP) or as a generic block device. Administrators can parse snapshot files natively in Windows Explorer or macOS Finder without requiring third-party Btrfs drivers. |
