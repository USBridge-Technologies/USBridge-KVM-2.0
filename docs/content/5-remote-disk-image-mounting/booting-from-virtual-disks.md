# Booting Server from Workstation Drives & VMs

The **Local Drive & VM Mounting** subsystem allows administrators to bypass traditional, complex network-boot (PXE) architectures entirely[cite: 1, 2]. Through hardware-level emulation over the physical USB OTG line, you can map individual partitions, raw physical disks, or fully configured Virtual Machine images (`.vdi`, `.vmdk`) directly from your local workstation to the target server[cite: 1, 2]. 

The remote motherboard's BIOS/UEFI detects these virtual assets instantly as standard, physically connected local storage drives, enabling a completely diskless server boot over the network[cite: 1, 2].

---

## 1. High-Performance Caching & Transport Topology

To deliver a responsive user experience when booting an entire operating system over different network topologies, the subsystem utilizes an optimized hardware data path:

* **USB Hi-Speed Emulation:** The transport layer uses a hardware-emulated, high-stability USB connection[cite: 1, 2], delivering roughly `35–40 MB/s` of sustained block-level throughput.
* **LPDDR4X RAM Cache Engine:** Running an OS generates heavy random read/write patterns. The appliance dynamically allocates its internal LPDDR4X RAM to cache frequently accessed blocks[cite: 1, 2]. This architecture completely neutralizes network propagation latency, making remote boot speeds comparable to a high-end physical HDD or entry-level SATA SSD[cite: 1, 2].

---

## 2. Infrastructure Testing & Non-Destructive Workflows

This architecture introduces native support for **Read-Write Overlay Mode**, turning the USBridge-KVM into a powerful sandbox for hardware validation and automated deployments[cite: 1, 2]:

* **The Golden Image Principle:** When the target server boots from your virtual drive and attempts to write data, the KVM intercepts the I/O operations[cite: 1, 2]. All new blocks, temporary files, and logs are safely redirected to an isolated overlay file on your workstation[cite: 1, 2].
* **Infinite Baseline Reuse:** The source baseline image or VM file remains completely pristine and unmodified[cite: 1, 2]. This allows you to reuse the exact same system image across multiple bare-metal nodes simultaneously without any session cross-contamination[cite: 1, 2].

### Core Target Use Cases

* **Safe OS and Kernel Validation:** Test how a specific operating system, beta kernel, or low-level hypervisor interacts with new bare-metal server hardware. If the system crashes or corrupts the filesystem, simply unmount the drive—the source image remains perfectly healthy[cite: 1, 2].
* **AI Infrastructure Staging:** Spin up specialized Linux environments pre-configured with heavy AI frameworks, CUDA compilation stacks, or neural network training models directly on physical GPU-nodes. You can safely build and benchmark the infrastructure layout without writing anything to the server's permanent internal disks.
* **Rapid Hardware Diagnostics:** Boot a "dead" or diskless server into a fully-featured desktop forensic environment pre-loaded with diagnostic suites directly from your administrative laptop, avoiding time-consuming flashing processes[cite: 1, 2].

---

## 3. Supported File & Disk Formats

The built-in storage engine processes standard industry containers out-of-the-box, eliminating mandatory staging conversions or pre-flashing delays:

* **Virtual Machine Images:** Direct mapping of Oracle VirtualBox (`.vdi`) and VMware (`.vmdk`) disk files[cite: 1, 2].
* **Raw Storage Blocks:** Direct physical mapping of raw drive images (`.img`, `.raw`), local workstation hard drives, or individual storage partitions selected via the native client application interface.
