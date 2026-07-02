# Temporary Network Bridge (USB-LAN) Specification

The USBridge appliance can be provisioned to operate as a plug-and-play **USB-to-LAN network adapter** for the managed host. Through this architecture, the KVM can forward its own active uplink connectivity (received via Wi-Fi 6 or an external USB-Ethernet interface) directly into the target server through the primary USB control line.

---

## 1. Core Out-of-Band Use Cases

The temporary network bridge is engineered strictly for out-of-band commissioning, automated staging, and disaster recovery workflows where the host's primary network interfaces are unconfigured, isolated, or physically compromised.

* **Bare-Metal OS Deployment:** When a modern or legacy OS installer lacks native driver support for the server's onboard high-speed network interface cards (NICs), USBridge exposes a highly compatible USB-Ethernet link to fetch deployment packages, mirror repositories, and critical netboot configurations.
* **Emergency Rescue Shells:** Provides immediate outbound network access to remote administrative tools, hardware diagnostic packages, and backup recovery images in environments where host-level production networks are malfunctioning.
* **Pre-OS Automation Pipelines:** Establishes a dedicated, isolated data channel for low-level BIOS validation, firmware flashing scripts, and bootloader automation sequences before the primary operating system initializes.

---

## 2. Technical Characteristics & Protocol Support

The USBridge hardware emulation layer presents itself to the target host's USB controller as a standard, compliant network interface, ensuring zero-agent execution with no proprietary software dependencies.

| Feature / Metric | Technical Specification |
| :--- | :--- |
| **Emulated Device Type** | Standard USB Ethernet Interface (Supports **CDC-ECM** for Linux/macOS and **RNDIS** for Windows out-of-the-box) |
| **Driver Dependency** | **None** (Utilizes native, pre-installed OS and advanced UEFI network stack drivers) |
| **Bridging Latency (Wired Uplink)** | Approximately `80–150 ms` under standard operational load |
| **Bridging Latency (Wi-Fi Uplink)** | Approximately `120–250 ms` (Dependent on local RF environment metrics) |

---

## 3. Architectural Constraints & Resource Allocation

> [!WARNING]
> **Production Traffic Restrictions** > This bridging capability is architected **exclusively as a temporary diagnostic pipe** for system initialization and emergency triage. It is not designed to function as a permanent gateway or production router for heavy server traffic.

Because the underlying Rockchip RK3566 SoC shares computational lanes between active network packet routing and the real-time UVC video encoding engine, executing sustained high-bandwidth data transfers across the emulated USB network bridge will hit hardware limits. This resource contention may introduce noticeable frame drops or transient latency spikes in your remote desktop video stream.
