# Mounting Local Drives & Partitions

The **Local Drive Mounting** feature is engineered to completely bypass the need for complex, heavy PXE server infrastructures. It allows administrators to attach physical disks, individual partitions, or virtual machine images from a local workstation directly to the target server out-of-band. Through hardware-level network encapsulation, the remote motherboard detects these resources instantly as standard, physically connected USB mass storage devices.

---

## 1. Architectural Pipeline & How It Works

The workflow relies on the transparent network encapsulation of storage I/O routing directly to the KVM's emulation layer:

1. **Network Forwarding:** The administrator selects any local disk, partition, or virtual drive on their workstation via the native USBridge Client application interface.
2. **Hardware Emulation:** The USBridge appliance intercepts and relays block-level read/write commands directly to the target host over the physical USB OTG line.
3. **OS Transparency:** The remote server's operating system, bootloader, and BIOS/UEFI interact with the media exactly as if it were a local, bare-metal flash drive or external hard disk.

---

## 2. Target Use Cases: The True PXE Alternative

This block-level encapsulation architecture fundamentally accelerates deployment, troubleshooting, and bare-metal recovery scenarios:

* **Diskless Bare-Metal Booting:** Attach a local workstation partition containing a pre-configured operating system image and boot a completely diskless remote server instantly for emergency triage.
* **Live Diagnostic Environments:** Expose heavy forensic, rescue, or custom live installer environments directly from your administration laptop without wasting time flashing physical USB thumb drives.
* **Zero-Infrastructure OS Deployment:** Install an operating system on the remote machine using a local disk asset as the primary distribution repository, eliminating the need to configure network-boot (PXE) servers, DHCP helpers, or TFTP daemons.

---

## 3. Performance Characteristics & Caching Matrix

The current transport architecture utilizes a highly stable USB 2.0-compatible Hi-Speed physical path, heavily buffered by onboard memory caches.

| Feature / Metric | Technical Specification & Behavior |
| :--- | :--- |
| **Transport Protocol** | USB 2.0-compatible Hi-Speed emulation layer |
| **Theoretical Throughput** | Roughly `35–40 MB/s` sustained block delivery |
| **Internal Network Latency** | Approximately `80–150 ms` (when operating over a wired LAN connection) |
| **Effective User Experience** | Performance is comparable to a high-end physical HDD or an entry-level SATA SSD |

### Latency Mitigation
[cite_start]To smooth out network propagation latency and accelerate repeated read operations during OS installations, an internal **LPDDR4X RAM cache** is dynamically integrated between the physical USB interface and the network transport layer. 

*Note: A future hardware revision upgrading the transport interface to USB 3.0/3.1, combined with this active caching model, will bring the effective remote throughput much closer to native local NVMe/SSD speeds.*

---

## 4. Virtual Machines & Read-Write Overlay Modes

To provide a comprehensive out-of-the-box staging solution, support extends beyond standard `.iso` containers to include ready-to-use virtual machine environments and non-destructive write modes:

* [cite_start]**Native Format Support:** Mount `.vdi` (VirtualBox), `.vmdk` (VMware), and other standard virtual-disk formats directly from the client application without any mandatory pre-conversion or staging delays[cite: 25].
* [cite_start]**Read-Write Overlay Mode (Non-Destructive):** When the target server boots and writes data to the mounted image, all write operations are safely redirected and stored in a separate overlay file on the local workstation[cite: 27]. [cite_start]The original source baseline image remains completely unmodified and pristine, enabling infinite reuse of the baseline "Golden Image" environment while retaining individual session results[cite: 27].
