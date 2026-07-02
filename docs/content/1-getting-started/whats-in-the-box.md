# What's in the Box 

Every USBridge-KVM 2.0 kit is shipped with a complete set of hardware, interface modules, and interconnect cables required for an immediate out-of-the-box deployment.

---

## Hardware Kit Breakdown

![USBridge Box](https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/Box.png)


1. **USBridge-KVM 2.0 Base Unit**
   * High-performance IP-KVM enclosed in a durable, premium 3D-printed SLS Nylon PA12 case. 
   * Features an integrated on-board IPS status display (240x240) for direct POST monitoring.
2. **HDMI Video Capture Dongle**
   * External hardware-level UVC capture stick capable of handling up to 1080p@30fps / 720p@60fps video processing.
3. **USB Type-C to Type-C Cable**
   * Specialized high-speed data interconnect cable used to link the KVM host port with the UVC capture dongle.
4. **Power Management Module Board**
   * An expansion adapter PCB designed for physical server power rail control (handles Power/Reset triggers and hardware LED lines). Comes with a pre-soldered ribbon cable interface.
5. **Female-to-Female Dupont Jumper Wires**
   * An 8-pin colorful jumper cable bundle to bridge the Power Management board directly to the target motherboard's front panel pin headers.

---

## What You Need to Provide

To complete the setup, ensuring zero external dependencies, you only need to supply one standard item:

* **HDMI Cable:** A standard HDMI male-to-male cable to route the display output from your server's GPU/motherboard directly into the included input capture dongle.

> [!NOTE]
> **Storage Information:** The high-speed MicroSD card required for the Btrfs **Hardware Snapshots** data layer is already pre-installed inside the dedicated SD slot on the base unit. You do not need to purchase additional external storage media.
