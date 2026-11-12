# USBridge PCBs & Gerber Files

Production manufacturing files (Gerber RS-274X, drill files, and pick-and-place assets) for the modular expansion boards of the USBridge ecosystem.

---

## 1. ATX Control Module (`ATX_Control/`)
Galvanically isolated power management board connecting the KVM to the motherboard Front Panel headers.

* **Archive**: [**ATX_gerber.zip**](./ATX_Control/ATX_gerber.zip)
* **Functionality**:
  * `PWR_SW`: Remote power toggle & graceful shutdown.
  * `RESET`: Hardware hard reset.
  * `P_LED`: Optocoupler-isolated system power state telemetry.
  * `H_LED`: Real-time storage drive activity sensing.
* **Galvanic Isolation**: Rated up to 3.75 kV via onboard optocouplers to prevent ground loops and motherboard surge propagation.
* **Guide & Wiring**: [ATX Power Management Guide](../../docs/content/6-hardware-connectivity/power-management-module-control.md).

---

## 2. Display Status Module (`Display_Module/`)
Hardware display daughterboard for real-time status monitoring, network IP inspection, and on-device menu navigation.

* **Archive**: [**display_gerber.zip**](./Display_Module/display_gerber.zip)
* **Components**:
  * 1.3" IPS LCD panel (240×240 ST7789 via SPI).
  * 3 tactile user buttons (KEY1, KEY2, KEY3).
  * 5-way navigation directional joystick.
* **Architecture**: Direct pin-compatible header designed for the Radxa Zero factor.
* **Full Project Specs**: [USBridge-Flip-HAT-1.3-LCD](../../USBridge-Flip-HAT-1.3-LCD/).

---

## PCB Manufacturing Recommendations (JLCPCB / PCBWay)
* **Layers**: 2 Layers.
* **PCB Thickness**: 1.6 mm.
* **Copper Weight**: 1 oz.
* **Surface Finish**: HASL with lead or ENIG (recommended for precision pin headers).
* **Solder Mask**: Matte Black or Green.
