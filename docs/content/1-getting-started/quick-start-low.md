# Quick Start Guide: USBridge KVM 2.0 Low

> [!NOTE]
> This guide covers the headless **USBridge KVM 2.0 Low** appliance.  
> * Using **USBridge KVM 2.0 Standard or Full** (with interactive screen & buttons)? See the [Standard & Full Quick Start Guide](./quick-start.md).  
> * Using **USBridge Nano** or **Sipeed NanoKVM**? See the [Nano Quick Start Guide](./quick-start-nano.md).  
> * Using bare DIY boards (**Radxa Zero 3W / Cubie A7Z**)? See the [Radxa DIY Quick Start Guide](./quick-start-radxa.md).

The **USBridge KVM 2.0 Low** provides full 1080p @ 60 FPS remote management in a minimalist, headless form factor. Because it does not feature an onboard display or physical buttons, initial setup and network configuration are performed over a direct USB connection or via a provisioning file.

---

## 1. Physical Connections

1. **Video Capture Dongle**: Plug the USB 3.0 HDMI capture dongle into the USB 3.0 host port (ensure `[5G]` SuperSpeed orientation). Connect the HDMI input cable to the target server's GPU or display output.
2. **KVM Host Port**: Connect the board's USB-C Host port to an available USB port on the target server (for keyboard, mouse, and virtual drive emulation).
3. **Power**: Connect a dedicated 5V / 2A+ power supply to the Power USB-C port.
4. **Network**: The unit connects via onboard Wi-Fi 6. If wired networking is required, attach an external USB-to-Ethernet adapter to the host port.

---

## 2. Initial Setup & Network Connection

Because the Low kit operates headlessly, choose one of two methods for initial pairing and network configuration:

### Method A: Over USB (`10.55.0.1` Web Console)
1. Connect the KVM's USB-C Host port directly to your laptop or workstation.
2. The KVM automatically exposes a virtual network adapter with the static IP **`10.55.0.1`**.
3. Open **`http://10.55.0.1`** in any web browser to access the device setup dashboard.
4. View your Master Key, scan the pairing QR code, or configure your local Wi-Fi network credentials.
5. In the [Desktop Client App](../7-software-access/desktop-app.md), click **`+` ➔ Over USB** to pair automatically.

### Method B: Headless Provisioning (`usbridge_provision.json`)
For automated deployments or pre-configuring Wi-Fi before first boot:
1. Insert the MicroSD card into your computer's card reader.
2. Open the **`BOOT`** partition (readable by Windows, macOS, and Linux).
3. Create a configuration file named **`usbridge_provision.json`** containing your Wi-Fi SSID and password (see [Headless Provisioning Guide](./headless-provisioning.md)).
4. Eject the card, insert it into the KVM 2.0 Low, and power on. The device will automatically connect to your Wi-Fi network on first boot.

---

## 3. Upgrading Your Unit

The Low edition is fully modular:
* **Add Screen & Joystick**: Plug the **[USBridge Screen Module](../../../Hardware/Accessories/Screen-Module/)** onto the 40-pin GPIO header at any time to upgrade your unit to a Standard edition with on-device telemetry and physical buttons.
* **Add Hardware Power Control**: Connect the **[ATX Power Control Board](../../../Hardware/Accessories/ATX-Board/)** to the Screen Module for remote server power, reset, and LED telemetry.

* 👉 For full hardware specs and 3D printable CAD models, see the **[USBridge KVM 2.0 Low Hardware Guide](../../../Hardware/Kits/USBridge-KVM-2.0-Low/)**.
