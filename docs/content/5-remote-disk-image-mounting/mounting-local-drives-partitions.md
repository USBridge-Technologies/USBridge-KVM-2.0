# Virtual Media: Mounting ISO Images

[cite_start]The **Virtual Media** subsystem enables the remote, out-of-band attachment of standard optical disc images (`.iso`) directly to the target server[cite: 25]. [cite_start]By emulating a physical USB CD/DVD-ROM drive at the hardware level [cite: 25, 26][cite_start], this architecture provides seamless pre-OS media access without requiring a complex, dependency-heavy PXE network boot infrastructure[cite: 24].

---

## 1. Core Capabilities & Workflows

The system supports streamlined media workflows specifically engineered for bare-metal operating system installations, automated staging, and remote disaster recovery scenarios:

* [cite_start]**Bare-Metal ISO Mounting:** Attach bootable installer disk images directly to execute zero-touch operating system installations or deploy low-level, isolated diagnostic utilities[cite: 25].
* **Flexible Source Selection:** Provision image files directly from the appliance's local storage repository (MicroSD card) or stream them dynamically from a remote administrative workstation via the native client application.
* [cite_start]**Universal Hardware Emulation:** The target host's USB controller recognizes the attached virtual media as a standard, physically connected USB optical drive[cite: 25, 26]. [cite_start]This ensures universal plug-and-play compatibility across both legacy text-based BIOS and modern UEFI environments without requiring any custom host-level drivers[cite: 26].

---

## 2. Media Provisioning & Staging Workflow

[cite_start]From the perspective of the target server, the virtual mounting process is completely transparent and perfectly mimics the physical insertion of an external optical drive[cite: 26]. 

To mount an ISO image, execute the following three-step workflow:

1. **Image Staging:** Transfer your required `.iso` file onto the isolated USBridge local storage or select it directly via the client application stream.
2. **Media Activation:** Mount the staged image utilizing the native **USBridge Client** application interface (under the *Devices* or *Virtual Media* controls) or trigger the mount directly through the appliance's front panel LCD and rotary encoder.
3. [cite_start]**Host Optimization:** The target server's hardware subsystem immediately enumerates a new USB optical device line[cite: 26]. [cite_start]This makes the bootable media instantly available within the native BIOS/UEFI Boot Menu for direct OS deployment[cite: 26].

---

> [!TIP]
> If you need to boot a server directly from a pre-configured Virtual Machine image (`.vdi`/`.vmdk`) or local partition instead of an installation disc, please see our guide on [Bare-Metal OS Booting: Local Drives & VM Emulation](./local-drives-vm-emulation.md).
