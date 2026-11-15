# Quick Start Guide: USBridge Nano & Sipeed NanoKVM

> [!NOTE]
> This guide covers the ultra-compact **USBridge Nano** and reflashed **Sipeed NanoKVM** (SG2002).  
> * Using **USBridge KVM 2.0** (Low / Standard / Full)? See the [KVM 2.0 Quick Start Guide](./quick-start.md).  
> * Using DIY single-board computers (**Radxa Zero 3W / Cubie A7Z**)? See the [Radxa DIY Quick Start Guide](./quick-start-radxa.md).

Get started with your **USBridge Nano** or reflash an off-the-shelf **Sipeed NanoKVM** with USBridge OS.

---

## 1. Physical Connections & Setup

* **HDMI IN**: Connect to the HDMI output of the target server or host machine.
* **USB-C (Power / Auxiliary)**: Connect to a 5V/2A power supply or secondary USB port.
* **USB-C (Host HID)**: Connect to a USB port on the target server for keyboard, mouse, and virtual media block emulation.
* **Ethernet (RJ45)**: Connect to your local network router or switch (DHCP enabled).
* **OLED Screen**: Displays real-time device IP, streaming FPS/state, and SSH authorization codes.

---

## 2. Firmware Flashing (If using Sipeed NanoKVM)

If you purchased an off-the-shelf Sipeed NanoKVM, install **USBridge OS** onto a MicroSD card:

1. Download the latest USBridge Nano OS image from the [Firmware Hub](https://usbridge.io/firmware).
2. Flash the image using [BalenaEtcher](https://etcher.balena.io/) or our [USB Recovery Flashing Guide](../9-updates-changelog/recovery-flashing-guide.md).
3. Insert the MicroSD card into the Nano slot and power on the unit.
4. The onboard OLED screen will initialize and display the assigned DHCP IP address within seconds.

---

## 3. Initial Client Pairing

1. Open the [Desktop Client App](../7-software-access/desktop-app.md) or [Web Client](https://web.usbridge.io).
2. Discover the Nano device automatically on your local network or enter the IP displayed on the OLED screen.
3. Verify your secure session using the physical presence code shown on the OLED display.

* 👉 For full hardware details, enclosure CAD, and specs, see the **[USBridge Nano Hardware Guide](../../Hardware/Kits/USBridge-Nano/)**.
