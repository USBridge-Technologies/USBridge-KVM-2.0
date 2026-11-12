# USBridge Hardware & Manufacturing Repository

Welcome to the hardware engineering and manufacturing repository for the **USBridge KVM 2.0** and **USBridge Nano** ecosystem. 

All assets are organized into **Kits** (complete appliance specifications, 3D enclosures, and bill of materials) and **Accessories** (modular PCB Gerber files, status display Flip-HAT, ATX power control, and capture cards).

---

## 📦 Kits (`Hardware/Kits/`)

Detailed documentation, setup guides, CAD enclosure files (.step), and bill of materials for each device:

| Kit | Form Factor | Enclosure & CAD | Guide & Specs |
| :--- | :--- | :--- | :--- |
| [**USBridge Nano**](./Kits/USBridge-Nano/) | Pocket KVM on Sipeed SG2002 RISC-V | [Nano Case STEP](./Kits/USBridge-Nano/USBridge_Nano_Case.step) | [Nano Kit Guide](./Kits/USBridge-Nano/README.md) |
| [**USBridge KVM 2.0 Low**](./Kits/USBridge-KVM-2.0-Low/) | Minimalist bare board with heatsink for racks | [Heatsink STEPs](./Kits/USBridge-KVM-2.0-Low/) | [Low Kit Guide](./Kits/USBridge-KVM-2.0-Low/README.md) |
| [**USBridge KVM 2.0 Standard**](./Kits/USBridge-KVM-2.0-Standard/) | Ready desktop unit with 1.3" IPS screen | [Case V6 STEP](./Kits/USBridge-KVM-2.0-Standard/USBridge_KVM_2.0_Case_V6.step) | [Standard Kit Guide](./Kits/USBridge-KVM-2.0-Standard/README.md) |
| [**USBridge KVM 2.0 Full**](./Kits/USBridge-KVM-2.0-Full/) | Flagship kit + ATX Power Board + heatsinks | [Case & Parts STEPs](./Kits/USBridge-KVM-2.0-Full/) | [Full Kit Guide](./Kits/USBridge-KVM-2.0-Full/README.md) |

---

## 🛠️ Accessories & Modular PCBs (`Hardware/Accessories/`)

Schematics, Gerber fabrication files, and pinout references for expansion modules:

| Accessory | Description | Manufacturing Files |
| :--- | :--- | :--- |
| [**Screen Module (Flip-HAT 1.3" LCD)**](./Accessories/Screen-Module/) | 240×240 IPS LCD + 5-way joystick + 3 buttons. Mirrored rear-mount keeping SBC SoC unobstructed for heatsinks. | [Gerber Archive](./Accessories/Screen-Module/Gerber/display_plus_gerber.zip) · [Guide](./Accessories/Screen-Module/README.md) |
| [**ATX Power Control Board**](./Accessories/ATX-Board/) | Motherboard Front Panel adapter board with optocoupler galvanic isolation up to 3.75 kV. | [Gerber Archive](./Accessories/ATX-Board/Gerber/ATX_gerber.zip) · [Guide](./Accessories/ATX-Board/README.md) |
| [**HDMI Video Capture Dongle**](./Accessories/Capture-Dongle/) | High-performance 1080p @ 60 FPS UVC video capture adapter (`[5G]` vs `[480M]` mode). | [Capture Card Guide](./Accessories/Capture-Dongle/README.md) |

---

## 3D Printing & Manufacturing Recommendations

* **Enclosures & Buttons**: Optimized for **High-Precision Resin (SLA / MSLA / DLP)** with engineering resins (Tough / ABS-like) or **SLS Nylon PA12**. FDM is supported with PETG (0.16–0.2 mm layer height, 40%+ infill).
* **Cooling Heatsinks**: CNC machined from Aluminum 6061-T6 or 6063.
* **PCBs**: Standard 2-layer fabrication, 1.6 mm thickness, 1 oz copper weight, HASL or ENIG finish.
