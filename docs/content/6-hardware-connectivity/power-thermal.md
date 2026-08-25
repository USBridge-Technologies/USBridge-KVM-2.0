# Power & Thermal Specifications

USBridge is built for stable 24/7 operation, not intermittent desk use — worth knowing the power and thermal envelope before you rack-mount it.

---

## 1. Specifications

| Parameter | Value |
| :--- | :--- |
| **Power Input** | USB-C (OTG / Power) |
| **Input Voltage** | 5V DC (±5%) |
| **Recommended Current** | 3A — needed for stable [storage caching](../5-remote-disk-image-mounting/mounting-iso-images.md#2-ram-cache-on-streamed-sources) and peak I/O |
| **Cooling** | Active fan + aluminum heatsink |
| **Ambient Operating Temperature** | 0°C to 50°C |
| **Maximum Safe SoC Temperature** | Up to 80°C |

---

## 2. Thermal Behavior

* **Active cooling is built in.** A dedicated fan sits directly on the aluminum heatsink block, sized for continuous real-time video encoding and OCR load — not just brief bursts.
* **A warm case is normal.** The enclosure is designed to actively shed heat outward; under sustained load it'll feel warm to the touch. That's the cooling working as intended, not a fault.
* **Watchdog protection.** If temperatures push past safe limits, the hardware watchdog steps in with defensive throttling or an emergency shutdown, before anything gets damaged.

> [!IMPORTANT]
> Mounting inside a dense rack or an enclosed telecom cabinet? Leave clearance around the fan vents — restricting airflow is the one thing that can push this outside its designed operating envelope.

See [Ports & Connectors Reference](./ports-connectors-reference.md) for the physical I/O, and [Power Management Module Control](./power-management-module-control.md) for controlling the *target's* power, not the appliance's own.
