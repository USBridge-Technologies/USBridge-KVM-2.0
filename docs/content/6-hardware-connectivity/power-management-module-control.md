# Power Management Module Control

Remote power and reset control extension for desktop motherboards and cold-boot recovery operations.

## Overview

The Power Management Module is a dedicated hardware extension designed for out-of-band power management. It bridges the gap between the USBridge controller and the physical motherboard interface, enabling reliable Remote Power and Reset operations for headless servers and workstations.

* **Galvanic Isolation:** Features high-quality dual optocouplers to ensure complete electrical isolation. This protects your infrastructure from ground loops, voltage spikes, and electromagnetic interference.
* **Cold-Boot Recovery:** Provides a robust path for hard-reset and cold-boot scenarios when the host operating system is completely unresponsive or frozen.
* **Full Signal Monitoring:** Supports standard motherboard headers including Power SW, Reset SW, Power LED, and HDD LED, allowing for both control and real-time status feedback.
* **Plug-and-Play Integration:** Designed for seamless 1-to-1 connection with the USBridge 8-pin GPIO interface, requiring no complex wiring or external power sources.

## Technical Specifications

The following table outlines the electrical and physical specifications of the control module.

| Parameter | Specification |
| :--- | :--- |
| **Output Type** | Dual-Channel Optoisolated (MOSFET/SSR) |
| **Signal Lines** | Power SW, Reset SW, Power LED, HDD LED |
| **Interface** | 8-pin 2.54mm GPIO Header (Ribbon cable included) |
| **Protection** | Galvanic Isolation (up to 3.75kV) |
| **Mounting** | Direct-to-Case or PCB Standalone |

## Accessories & Support

*Information regarding specific accessories, mounting options, and dedicated troubleshooting steps will be available in upcoming documentation releases.*
