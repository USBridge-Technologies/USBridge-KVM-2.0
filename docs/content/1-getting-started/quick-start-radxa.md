# Quick Start Guide: Radxa Boards (DIY IP-KVM)

> [!NOTE]
> This guide covers DIY IP-KVM deployments on **Radxa Zero 3W / 3E** and **Radxa Cubie A7Z** boards.  
> * Using **USBridge KVM 2.0** (Low / Standard / Full)? See the [KVM 2.0 Quick Start Guide](./quick-start.md).  
> * Using **USBridge Nano** or **Sipeed NanoKVM**? See the [Nano Quick Start Guide](./quick-start-nano.md).

Turn standard off-the-shelf single-board computers (SBCs) into an enterprise-grade out-of-band management appliance with USBridge OS.

---

## 1. Hardware Requirements

* **Supported SBC**: Radxa Zero 3W, Radxa Zero 3E, or Radxa Cubie A7Z.
* **USB 3.0 Video Capture Dongle**: 1080p @ 60 FPS UVC capture card (e.g., [USBridge Capture Dongle](../../Hardware/Accessories/Capture-Dongle/)).
* **MicroSD Card**: High-speed MicroSD card (Class 10 / U3, 16 GB or larger).
* **Power Supply**: 5V / 2A+ USB-C power source.
* **Optional Add-ons**:
  * [USBridge Screen Module](../../Hardware/Accessories/Screen-Module/) (1.3" IPS LCD + joystick + buttons).
  * [USBridge ATX Power Control Board](../../Hardware/Accessories/ATX-Board/) (galvanically isolated power & reset control).

---

## 2. Firmware Flashing

1. Download the USBridge OS firmware for your board model from the [Firmware Hub](https://usbridge.io/firmware).
2. Flash the image to your MicroSD card using [BalenaEtcher](https://etcher.balena.io/) or our [USB Recovery Flashing Guide](../9-updates-changelog/recovery-flashing-guide.md).
3. Insert the card into your Radxa board.

---

## 3. Physical Connections

1. **Video Capture Dongle**: Plug the USB 3.0 capture dongle into the board's USB 3.0 host port (ensure `[5G]` mode orientation). Connect the HDMI input to the target server's GPU or display output.
2. **KVM Host Port**: Connect the board's OTG / Host USB-C port to an available USB port on the target server (for keyboard, mouse, and virtual drive emulation).
3. **Power**: Plug a dedicated 5V power cable into the Power USB-C port.

---

## 4. Initial Network Access & Provisioning

* **Default USB Gadget IP**: Connect the board directly to your workstation via USB. Open `http://10.55.0.1` in your browser for initial setup and Wi-Fi configuration.
* **Headless Provisioning**: You can pre-configure Wi-Fi by placing a `usbridge_provision.json` file in the boot partition of the MicroSD card (see [Headless Provisioning](./headless-provisioning.md)).
* **Front-Panel Screen** (if Screen Module installed): Configure Wi-Fi directly on the device using the 3 hardware buttons.

* 👉 For full hardware details and custom 3D printed cases, see the **[USBridge KVM 2.0 Low Hardware Guide](../../Hardware/Kits/USBridge-KVM-2.0-Low/)**.
