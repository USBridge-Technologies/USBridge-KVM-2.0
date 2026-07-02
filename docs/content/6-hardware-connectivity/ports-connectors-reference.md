# Ports & Connectors Reference

[cite_start]The USBridge appliance features a robust array of physical interfaces engineered for out-of-band power delivery, data transport, and hardware-level peripheral emulation[cite: 48]. [cite_start]These connections operate entirely independently of the target server's operating system and do not require host-side agents or software layers[cite: 48].

---

## 1. Hardware Interface Specifications

The following reference matrix details the primary control, peripheral, and diagnostic connections available on the USBridge hardware layer:

| Interface Port | Signal Type | Primary Functional Engineering Purpose |
| :--- | :--- | :--- |
| **USB-C (OTG / Power)** | Input / Output | [cite_start]Dual-function line providing core appliance power input (5V/3A) [cite: 55] [cite_start]and composite USB-HID emulation (keyboard/mouse tracking) [cite: 55][cite_start], alongside virtual mass storage drive mapping to the target host[cite: 55]. *Note: Requires a Y-splitter or active power injector for simultaneous external PSU delivery and server connectivity.* |
| **USB-C (Host)** | Input | [cite_start]Dedicated high-speed peripheral bridging interface[cite: 56]. [cite_start]Primarily utilized for attaching the external HDMI-to-USB UVC video capture dongle [cite: 54, 56] or USB-LAN adapters. [cite_start]Fully supports external active USB hubs to multiplex multiple client devices[cite: 54]. |
| **8-pin GPIO Interface** | Control Layer | [cite_start]Dedicated hardware interface routing directly to the external **Power Management Module** adapter board[cite: 57]. [cite_start]Connects to the target server's motherboard headers for remote, out-of-band Power and Reset state manipulation[cite: 52, 57]. |
| **MicroSD Slot** | Storage Layer | [cite_start]Non-volatile storage lane hosting high-endurance memory media[cite: 58]. [cite_start]Required for local Btrfs immutable file-system snapshots [cite: 58, 63] and appliance telemetry data retention. |
| **Micro HDMI Port** | Diagnostic Out | [cite_start]Reserved exclusively for low-level appliance firmware diagnostics and direct hardware debugging[cite: 59]. [cite_start]This interface is completely inactive during standard daily KVM workflows[cite: 59]. |

---

## 2. Telemetry, Status Indicators & On-Site Monitoring

[cite_start]To facilitate rapid rack-side diagnostics and immediate troubleshooting without requiring administrative client application access, the appliance integrates local visual telemetry loops[cite: 51]:

* [cite_start]**Integrated IPS Panel (240x240):** The high-contrast front-panel display provides a real-time hardware readout of active system metrics, assigned IP addresses, network state variables, and access to core local configuration menus[cite: 51].
* **Physical Status Indicators:** Onboard LEDs offer instantaneous, binary confirmation of active power rail states, system initialization steps, and the overall operational health of the appliance hardware.
