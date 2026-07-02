# Quick Start Guide

This guide covers the physical connections, initial network setup, onboard interface navigation, and client authorization required to establish your first out-of-band remote session.

---

## 1. Physical Connections & Ports

The side panels of the USBridge device provide the physical interfaces required for power, data transfer, and peripheral emulation.

* **USB-C (Power & Emulation):** Powers the device and provides hardware-level keyboard and mouse HID emulation for the target host.
* **USB-C (HDMI Connectivity):** Connects to the target HDMI video source via a compatible capture dongle.
* **8-pin Connector:** Reserved for specialized functionality, including external **Power Management Module** control.
* **Micro HDMI:** Unused during standard operation. Reserved exclusively for direct low-level diagnostics of the USBridge hardware.
* **SD Card Slot:** Hosts the MicroSD card required for storing immutable data snapshots and local system data.

---

## 2. Installation & First Launch

To get your out-of-band session up and running, follow these four basic deployment steps:

1. **USB-C: Power & HID:** Connect the primary USB-C port to the target computer to enable immediate power delivery and peripheral emulation.
2. **Video Capture:** Establish the video signal path: `Target HDMI Output` -> `HDMI Cable` -> `Capture Dongle` -> `USBridge Host USB Port`.
3. **Network Setup:** Access the onboard interface, navigate to **Settings** -> **Internet**, select your network, and enter the password. Once connected, the device will display its assigned IP address on the screen.
4. **Client Authorization:** Open the **USBridge App** to start the session. You can sync credentials instantly by scanning the QR code via the app, or manually enter the IP address and Access Token.

---

## 3. Onboard Interface Navigation

The main screen provides quick access to the device's core functions. Use the local display or web interface to browse the sections below:

| Menu Section | Functional Purpose |
| :--- | :--- |
| **Drives** | Your library for ISO images where you can browse, select, and mount virtual images directly to your target system. |
| **Snapshots** | The list of your data snapshots, allowing you to manage, view, or restore previously captured states. |
| **Event Log** | A complete history of system logs to track device activity, verify successful operations, or audit recent sequences. |
| **Settings** | The central hub for device configuration, including Wi-Fi/Internet connectivity, System Info, Auth Token management, SD Card Settings, Display adjustments, and Language selection. |
| **Monitor** | A dedicated diagnostic mode used to observe the real-time behavior of the target host and perform quick troubleshooting. |

