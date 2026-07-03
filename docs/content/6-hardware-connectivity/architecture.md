# Core Hardware Architecture

The USBridge appliance is engineered as a modular hardware platform, balancing high compute performance with a highly compact physical form factor. The architecture operates as a dedicated out-of-band management node, ensuring absolute isolation between the host server and the KVM system logic.

---

## 1. Core Processing Module (Radxa Zero 3W)

The primary compute engine driving the appliance is based on the Radxa Zero 3W single-board computer platform[cite: 1]:

| System Component | Technical Specification & Implementation |
| :--- | :--- |
| **System-on-Chip (SoC)** | Rockchip RK3566 (Quad-Core ARM Cortex-A55)[cite: 1] |
| **Base Board Module** | Radxa Zero 3W variant[cite: 1] |
| **System Memory (RAM)** | 1–2 GB LPDDR4X (Partially allocated for high-speed Virtual Media caching)[cite: 1] |
