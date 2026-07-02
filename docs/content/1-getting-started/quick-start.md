# Quick Start Guide

This guide covers the physical connections, initial network setup, onboard interface navigation, and client authorization required to establish your first out-of-band remote session.

---

## 1. Physical Connections & Ports

The side panels of the USBridge device provide the physical interfaces required for power, data transfer, and peripheral emulation.

![USBridge Physical Ports Reference](https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/Ports.png)

* **USB-C (Power & Emulation):** Powers the device and provides hardware-level keyboard and mouse HID emulation for the target host.
* **USB-C (HDMI Connectivity):** Connects to the target HDMI video source via a compatible capture dongle.
* **8-pin Connector:** Reserved for specialized functionality, including external **Power Management Module** control.
* **Micro HDMI (Video Passthrough):** Functions as a local video output to mirror the target server's display. This allows you to connect a physical monitor directly at the rack when the host's primary video port is occupied by the KVM capture hardware.
* **SD Card Slot:** Hosts the MicroSD card required for storing immutable data snapshots and local system data.

---

## 2. Onboard Interface Navigation

![USBridge Front panel](https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/Front_panel.png)

The main screen provides quick access to the device's core functions. Use the local display or web interface to browse the sections below:

| Menu Section | Functional Purpose |
| :--- | :--- |
| **Drives** | Your library for ISO images where you can browse, select, and mount virtual images directly to your target system. |
| **Snapshots** | The list of your data snapshots, allowing you to manage, view, or restore previously captured states. |
| **Event Log** | A complete history of system logs to track device activity, verify successful operations, or audit recent sequences. |
| **Settings** | The central hub for device configuration, including Wi-Fi/Internet connectivity, System Info, Auth Token management, SD Card Settings, Display adjustments, and Language selection. |
| **Monitor** | A dedicated diagnostic mode used to observe the real-time behavior of the target host and perform quick troubleshooting. |
| **Scripts** | A repository of available automation scripts, enabling the direct execution of predefined provisioning or recovery workflows straight from the KVM appliance. |

---

## 3. Installation & First Launch

To get your out-of-band session up and running, follow these four basic deployment steps:

1. **USB-C: Power & HID:** Connect the primary USB-C port to the target computer to enable immediate power delivery and peripheral emulation.
2. **Video Capture:** Establish the video signal path: `Target HDMI Output` -> `HDMI Cable` -> `Capture Dongle` -> `USBridge Host USB Port`.
3. **Network Setup:** Access the onboard interface, navigate to **Settings** -> **Internet**, select your network, and enter the password. Once connected, the device will display its assigned IP address on the screen.
4. **Establish Connection:** With the hardware and network fully initialized, you are ready to launch your remote session. Open the cross-platform client application and enter the displayed IP address along with the Access Token (or sync instantly by scanning the onscreen QR code). For a step-by-step walkthrough of the software connection process, proceed to the [Initial Setup & Client Pairing](https://github.com/USBridge-Technologies/USBridge-KVM-2.0/blob/main/docs/content/1-getting-started/initial-setup.md).


