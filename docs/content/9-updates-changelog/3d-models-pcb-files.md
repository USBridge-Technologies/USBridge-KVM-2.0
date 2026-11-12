# 3D Models & PCB Files

The mechanical 3D models and PCB source files for USBridge KVM are organized inside this repository under the [`Hardware/`](../../../Hardware/) directory:

* **Hardware Kits & Enclosures:** [`Hardware/Kits/`](../../../Hardware/Kits/) — complete STEP models and manufacturing guidelines for USBridge Nano, Low, Standard, and Full kits.
* **Modular Accessories & PCBs:** [`Hardware/Accessories/`](../../../Hardware/Accessories/) — Gerber manufacturing packages and wiring guides for the 1.3" Screen Module, ATX Power Control Board, and HDMI Capture Dongle.

These assets let infrastructure engineers independently manufacture enclosure components, fabricate auxiliary hardware modules, or integrate the bridge into custom server chassis environments.

---

## 3D Enclosure & Thermal Models

CAD models (`STEP` format) are optimized for **Resin 3D printing (SLA / MSLA / DLP)** with Tough/ABS-like resin for production-grade finish, as well as **SLS (Selective Laser Sintering, PA12 Nylon)** and FDM (PETG/ABS):

* **[USBridge Nano Case](../../../Hardware/Kits/USBridge-Nano/)** (`USBridge_Nano_Case.step`)
* **[USBridge KVM 2.0 Case & Buttons](../../../Hardware/Kits/USBridge-KVM-2.0-Standard/)** (`USBridge_KVM_2.0_Case_V6.step`, `Key_Single.step`, `Joystick_Cap.step`)
* **[Extruded Aluminum Heatsinks](../../../Hardware/Kits/USBridge-KVM-2.0-Low/)** (`Radiator_V6_Transverse_Ribs.step`, `Radiator_V5.step`)

---

## PCB Gerber Files

Production-ready Gerber archives (`ZIP` format) ready for upload to PCB manufacturers (JLCPCB, PCBWay, etc.):

* **[1.3" IPS LCD Flip-HAT Module](../../../Hardware/Accessories/Screen-Module/)** (`display_plus_gerber.zip`) — Mirrored 40-pin header keeping SBC SoC exposed for massive heatsink cooling.
* **[ATX Power Control Board](../../../Hardware/Accessories/ATX-Board/)** (`ATX_gerber.zip`) — Galvanically isolated front-panel interface for Power, Reset, and LED status lines.
