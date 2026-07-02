# Supported BIOS/UEFI Types & Compatibility Matrix

The **BIOS-in-Terminal** engine is explicitly architected and optimized for parsing text-based pre-OS interfaces, standard console bootloaders, and text-driven operating system installers. This document defines the exact compatibility boundaries of the optical character recognition (OCR) pipeline, outlining supported environments and current hardware-level limitations regarding graphical user interfaces.

---

## 1. Supported Pre-OS Environments

The on-device optical processing engine reliably intercepts, reconstructs, and streams the following text-based interfaces directly into your standard SSH terminal session:

* **Legacy BIOS & Text-Mode UEFI:** Standard blue, gray, or black text-grid configuration utilities from major Independent BIOS Vendors (IBVs), including American Megatrends (AMI / Aptio), Award Software, Phoenix Technologies, and InsydeH2O.
* **Bootloaders & Recovery Shells:** Initial boot selection menus (such as GRUB, rEFInd, LILO, and Syslinux), as well as interactive text-based rescue shells and low-level system maintenance consoles.
* **Console OS Installers:** Bare-metal operating system setup wizards lacking a graphical display server, including the Debian text installer, Ubuntu Server installation framework (Subiquity), and Arch Linux installation environments.
* **Hardware POST Telemetry & Alerts:** Initial Power-On Self-Test (POST) readout text, hardware checksum errors, storage controller initialization sequences, RAID degradation warnings, and critical blocking prompts (e.g., `"CMOS Date/Time Not Set — Press F1 to Run Setup"`).

---

## 2. Architectural Limitations & Unsupported Layouts

When the target host's display engine transitions out of text-mode configurations, the limitations of the text-parsing architecture must be taken into account.

### Graphical Installers & Desktop Environments
If a bootable installation media or live environment initializes a full graphical user interface (GUI) driven by an X11, Wayland, or direct frame-buffer display server (featuring pixel-based mouse cursors, windows, and high-resolution icons), the BIOS-to-Text engine **will pause processing**. 
* *Solution:* For these environments, you must switch to the standard low-latency **UVC graphical video stream** via the native desktop or mobile client.

### Complex UEFI Graphical Shells
Modern high-definition UEFI interfaces incorporating vendor-branded graphical dashboards, heavy 3D asset rendering, animations, and exclusive pointer-driven navigation configurations fall completely outside the operational scope of the OCR text engine. 

### Character Recognition & Glyph Boundaries
The optical character recognition algorithm guarantees deterministic parsing **strictly for Latin alphanumeric character sets and standard ASCII terminal glyphs**. 
* Non-Latin alphabets (Cyrillic, Asian ideograms, etc.) and complex graphical borders or custom vendor logos will either be ignored or may render as transient character artifacts within the terminal buffer.

---

## 3. Compatibility Summary Table

| Pre-OS Interface Type | BIOS-in-Terminal Support | Recommended Management Protocol |
| :--- | :---: | :--- |
| **Legacy Text BIOS (AMI, Phoenix)** | **Full Support** | SSH Terminal Session (ANSI/VT100) |
| **Text-Mode UEFI Utilities** | **Full Support** | SSH Terminal Session (ANSI/VT100) |
| **GRUB / Bootloaders** | **Full Support** | SSH Terminal Session (ANSI/VT100) |
| **Text OS Installers (Ubuntu Server)** | **Full Support** | SSH Terminal Session (ANSI/VT100) |
| **Graphical UEFI Shells (ASUS ROG, etc.)**| *Unsupported* | Native Client App (Moonlight Video Stream) |
| **Graphical OS Installers / Live GUI** | *Unsupported* | Native Client App (Moonlight Video Stream) |
