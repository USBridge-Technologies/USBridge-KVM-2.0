# 3D Models & PCB Files

The mechanical and PCB source files for the USBridge appliance are maintained in their own dedicated repository, kept in sync independently of this documentation:

**[github.com/USBridge-Technologies/Hardware](https://github.com/USBridge-Technologies/Hardware)**

These assets let infrastructure engineers independently manufacture enclosure components, fabricate auxiliary hardware modules, or integrate the bridge into custom server chassis environments.

---

## 3D Enclosure Model

**[`3D_Models/`](https://github.com/USBridge-Technologies/Hardware/tree/main/3D_Models)** — the complete `STL`/`STEP` package for additive manufacturing (3D printing) of the appliance enclosure, including the physical tactile buttons and joystick components, optimized for SLS (Selective Laser Sintering).

> [!NOTE]
> Published 3D models are subject to iterative mechanical revisions and may exhibit minor dimensional variances from finalized injection-molded production samples.

---

## PCB Gerber Files

**[`PCBs/`](https://github.com/USBridge-Technologies/Hardware/tree/main/PCBs)** — Gerber files and schematics for the appliance's own boards, including the Display module (drives the front-panel 240×240 IPS panel) and the Power Management Module (out-of-band Power/Reset control via GPIO signaling — see [Power Management Module Control](../6-hardware-connectivity/power-management-module-control.md)).

These resources are intended for hardware specialists executing module repairs, physical modifications, or developing custom local-indication display solutions.
