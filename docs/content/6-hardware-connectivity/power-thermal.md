# Power & Thermal Specifications

The USBridge-KVM 2.0 appliance is designed for stable 24/7 continuous operation under intense out-of-band workloads. To ensure hardware stability, the device must operate within specified power and temperature thresholds.

---

## 1. Technical Specification Matrix

| Parameter | Operational Threshold / Requirement |
| :--- | :--- |
| **Power Input Interface** | USB-C (OTG / Power) |
| **Input Voltage** | 5V DC ($\pm$ 5%) |
| **Recommended Current** | **3A** (Required for stable storage caching and peak I/O loads) |
| **Cooling Type** | Active cooling fan + Aluminum heatsink |
| **Ambient Operating Temperature** | 0°C to 50°C |
| **Maximum Safe SoC Temperature** | Up to 80°C |

---

## 2. Thermal Management & Safety Features

The hardware relies on a high-performance, compact ARM core module. To guarantee peak performance without thermal throttling during real-time video encoding or script execution, the cooling pipeline has been explicitly optimized.

* **Active Fan Integration:** The updated chassis revision incorporates a dedicated active cooling fan embedded directly into the aluminum cooling block to handle continuous high-load scenarios.
* **Warm Enclosure Behavior:** The external case is designed to actively transfer internal heat away from the processor. During heavy workloads, the enclosure will feel warm to the touch—this is normal, intended hardware behavior.
* **Hardware Watchdog Protection:** In extreme thermal conditions exceeding safe environmental limits, the internal hardware watchdog timer automatically triggers defensive scaling routines or an emergency safety shutdown to protect the components and flash memory from degradation.

---

> [!IMPORTANT]
> When mounting the appliance inside dense server racks or enclosed telecom cabinets, ensure there is sufficient spatial clearance around the active fan vents to allow proper airflow and heat dissipation].
