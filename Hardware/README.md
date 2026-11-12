# USBridge Hardware & Manufacturing Assets

Welcome to the hardware engineering and manufacturing repository for the **USBridge KVM 2.0** and **USBridge Nano** ecosystem. This directory contains production-ready 3D CAD models, CNC heatsink drawings, and PCB manufacturing Gerber files.

---

## Directory Navigation

| Subdirectory | Contents | Format |
| :--- | :--- | :--- |
| [**3D_Models/**](./3D_Models/) | Production enclosure models, buttons, and CNC radiator blocks | STEP (.step), 3D Renders |
| [**PCBs/**](./PCBs/) | Manufacturing packages for ATX power control and LCD display modules | Gerber RS-274X (.zip) |
| [**USBridge-Flip-HAT-1.3-LCD/**](../USBridge-Flip-HAT-1.3-LCD/) | Complete standalone repository for the 1.3" IPS LCD Flip-HAT | Schematics, Gerbers, Images |

---

## Key Hardware Modules

### 1. 3D Printable Enclosures & Heatsinks
* **USBridge KVM 2.0 Enclosure (V6)**: Custom SLS PA12-optimized housing for Radxa Zero 3W with interactive screen and joystick cutouts.
* **USBridge Nano Enclosure**: Pocket enclosure for Sipeed NanoKVM (SG2002) with integrated HDMI and Ethernet port access.
* **Aluminum Heatsinks (V5 / V6)**: CNC milled cooling radiators ensuring continuous 1080p 60 FPS operation without thermal throttling.
* 👉 **Explore CAD models:** [3D Models Directory](./3D_Models/)

### 2. Printed Circuit Boards (PCBs)
* **ATX Power Control Module**: Optocoupler-isolated (up to 3.75 kV) board for remote hardware power switching and LED telemetry.
* **1.3" IPS LCD Status Display Module**: 240×240 color display board with a 5-way joystick and 3 control buttons.
* 👉 **Download Gerber archives:** [PCBs Directory](./PCBs/)

---

## Technical Documentation & Guides
* [System Hardware Architecture](../docs/content/6-hardware-connectivity/architecture.md)
* [Board Comparison Matrix (Radxa vs NanoKVM)](../docs/content/6-hardware-connectivity/board-comparison.md)
* [Power & Thermal Management Guidelines](../docs/content/6-hardware-connectivity/power-thermal.md)
* [ATX Power Wiring Reference](../docs/content/6-hardware-connectivity/power-management-module-control.md)
