# Power & Thermal Specifications

For stable, continuous 24/7 operation—particularly under intensive workloads such as 1080p UVC video capture, high-fidelity audio redirection, or active USB-LAN network bridging—the USBridge appliance must operate strictly within the defined electrical and thermal thresholds.

---

## 1. Power Input Specifications

The appliance draws its primary operating power through the dual-function **USB-C (OTG)** interface. To prevent unexpected voltage drops, brownouts, or kernel panics during peak I/O loads and storage caching cycles, a high-quality, regulated power supply is mandatory.

| Electrical Parameter | Technical Specification |
| :--- | :--- |
| **Primary Power Interface** | USB-C (OTG / Power & HID Emulation) |
| **Input Voltage Range** | 5V DC ($\pm$ 5%) |
| **Minimum Current Draw** | 2A |
| **Recommended Current** | **3A** (Required for absolute stability under high workload spikes) |

---

## 2. Thermal Management Architecture

The hardware architecture utilizes the Rockchip RK3566 SoC mounted on a Radxa Zero 3W core module. While this ARM platform is highly power-efficient, it necessitates proper thermal dissipation paths during sustained utilization.

### Passive & Active Cooling Dynamics
The appliance employs a specialized hybrid thermal management design:
* **CNC-Milled Aluminum Heatsink:** A custom-engineered, internal mass aluminum block directly contacts the SoC die to maximize heat absorption and dissipation.
* **Active Thermal Control:** To prevent core thermal throttling under heavy loads (such as continuous high-frequency background SD-card operations or Moonlight video encoding), a dedicated active cooling fan is integrated into the premium SLS Nylon enclosure.

### Thermal Boundaries & Operational Limits
* **Ambient Air Operating Range:** 0°C to 50°C.
* **Maximum Safe Silicon Die Limit:** At the silicon level, a sustained SoC die temperature of up to 80°C is within safe operational engineering tolerances for this computing platform.
* **Enclosure Behavior:** During intensive deployment automation, the external case will naturally become warm. This is expected hardware behavior indicating successful thermal energy transfer from the internal components to the surrounding environment.

---

## 3. Environmental Constraints & Fail-Safe Protection

When deploying the USBridge device within enclosed server racks, standard datacenter crash carts, or high-density telecom cabinets, adequate spatial clearance must be maintained around the chassis to facilitate proper convection.

### Hardware Watchdog & Safety Throttling
In extreme thermal conditions exceeding the design baseline, the built-in hardware thermal manager and integrated **watchdog timer** will automatically trigger immediate protection routines:
1. **Dynamic Frequency Scaling (DFS):** Automatically drops the CPU clock speeds (thermal throttling) to decrease heat generation.
2. **Emergency Shutdown Execution:** If temperatures continue to cross critical safety thresholds, the watchdog forces a safe power-down state to protect the SoC and flash memory components from physical degradation.
