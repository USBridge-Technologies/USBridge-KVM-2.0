# 3D Models & PCB Files

This repository provides open access to the mechanical and printed circuit board (PCB) source files for the USBridge hardware appliance.

These assets are supplied to enable infrastructure engineers to independently manufacture enclosure components, fabricate auxiliary hardware modules, or integrate the bridge into custom server chassis environments.

---

## 3D Enclosure Model (v1.0)

### Mechanical Assets

The designated archive contains the complete `STL` and `STEP` package required for additive manufacturing (3D printing) of the appliance enclosure, including the physical tactile buttons and joystick components.

> **Mechanical Note:** Please note that the published 3D models are subject to iterative mechanical revisions and may exhibit minor dimensional variances from finalized injection-molded production samples.

* **Current Hardware Revision:** `v1.0.step`
* **Download:** [3D Models.7z](./3D%20Models.7z) *(Замените путь на фактический при наличии файла)*

---

## Display Module PCB

### Display Board Schematics

The integrated display module drives the local 240x240 resolution IPS telemetry panel. The provided package includes comprehensive Gerber files and circuit schematics.

These resources are engineered for hardware specialists executing module repairs, physical modifications, or the development of custom local-indication display solutions.

* **Download:** [display_plus_gerber.zip](./display_plus_gerber.zip)

---

## Power Management Module Power Control PCB

### Hardware Reset Schematics

Manufacturing files for the optional Power Management Module Control module are provided to facilitate independent fabrication.

This specific module enables out-of-band hardware control of the target motherboard's Power and Reset pins via precision GPIO signaling. It is highly recommended for bare-metal deployments lacking external Power Distribution Unit (PDU) infrastructure.

* **Download:** [front_panel_adapter_gerber.zip](./front_panel_adapter_gerber.zip)
