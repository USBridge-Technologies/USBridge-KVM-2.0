# Frequently Asked Questions

This section provides strict technical clarification regarding USBridge operational capabilities, architectural limitations, and hardware-level security models.

---

## Core Platform & Capabilities

#### Does BIOS-to-Text support modern graphical UEFI interfaces?
The system is optimized for classic, text-oriented BIOS and UEFI environments. Full-screen graphical interfaces with rich, mouse-driven UX are not officially supported as a deterministic automation target, as highly stylized or dynamic elements are difficult to parse reliably.

#### What hardware and software platform does USBridge utilize?
The appliance is built on the Rockchip RK3566 SoC featuring a Quad-Core ARM Cortex-A55 architecture. It operates on a hardened Linux foundation, with the core software stack and internal system routing logic implemented entirely in Go.

#### Is USBridge an open-source project?
Partially, today. The client — **USBridge-Remote** (desktop/mobile/web) — is already public under GPLv3: [github.com/USBridge-Technologies/USBridge-Remote](https://github.com/USBridge-Technologies/USBridge-Remote). The mechanical/PCB assets are public too: [github.com/USBridge-Technologies/Hardware](https://github.com/USBridge-Technologies/Hardware). The on-device firmware/service — including the BIOS-to-Text deterministic conversion engine — remains closed source.

#### How does USBridge differ from traditional PiKVM solutions?
While sharing a similar single-board hardware class, USBridge utilizes an RK3566 ARM64 platform for additional compute overhead. Unlike traditional video-oriented solutions, USBridge emphasizes deterministic text interaction (BIOS-to-Text), deep infrastructure automation, and immutable hardware-isolated Btrfs snapshot workflows.

---

## Storage & Media Lifecycle

#### Can standard consumer SD cards be used for snapshot storage?
Low-cost consumer SD cards are strongly discouraged. Snapshot storage utilizes Btrfs with Copy-on-Write (CoW), creating sustained write pressure that causes premature failure in cards lacking advanced wear-leveling. External SSDs or industrial-grade surveillance SD cards are required for continuous workloads.

#### Are snapshots stored on the built-in eMMC, and does this cause wear?
No. Data snapshots and file archives are strictly written to removable external media. The onboard eMMC is exclusively reserved for the Linux operating system and the bridge software stack, protecting the soldered memory from intense Btrfs journaling workloads and ensuring data portability.

---

## Security & Immutability Models

#### What differentiates the USBridge backup model from a standard NAS?
The appliance intentionally omits standard network file-sharing protocols (such as SMB or NFS) to ensure strict lifecycle isolation. A compromised target operating system lacks the network path or permissions to delete or overwrite historical snapshots, providing absolute resilience during severe ransomware incidents.

#### How is data immutability achieved using a standard Btrfs file system?
Immutability is achieved through strict architectural isolation rather than proprietary file-system modifications. The target server perceives the appliance as generic block storage with no host-side management interfaces. When physical capacity is exhausted, new writes are halted, effectively transforming the medium into a read-only archive.

#### Does USBridge operate as a physical data diode?
No. KVM operations are inherently bidirectional. Instead of physical one-way transport, the appliance enforces logical immutability of the backup history. Normal KVM traffic continues unimpeded, while the target host is denied any mechanism to roll back or administratively purge preserved snapshots.

#### Why utilize hardened Linux instead of proprietary cryptographic firmware?
The security model relies on attack-surface reduction and threat-boundary separation. By blocking destructive commands on the USB-facing path and leveraging established Linux hardening practices, the architecture ensures that malware on the connected server cannot rewrite protected historical snapshots without direct out-of-band physical access.

---

## Licensing & Trial

#### Can I try USBridge before committing to it?
Yes. Every device ships with a **24-hour, fully-featured trial** that starts the moment it's powered on — no network connection or account sign-in required to begin. Streaming, BIOS-in-Terminal, virtual media, and every other licensed capability work exactly as they would on a fully licensed unit for the full trial window, with no artificial feature restrictions or watermarks.

#### How does the trial become a permanent license?
Once you're ready to keep the device, it's confirmed (**Accept**) on the vendor's device console — after that, the license is permanent and no longer depends on network connectivity or the trial timer. See [Firmware Update Guide](../9-updates-changelog/firmware-update-guide.md) for how the appliance's device-management connection also delivers OTA updates.

#### Does resetting the device reset my trial or license?
Depends on which kind of reset:
- **Factory Reset** (Settings → Factory Reset) — No. It's specifically designed to preserve trial/license state; see [Factory Reset](./factory-reset.md#what's-deliberately-preserved).
- **A full reflash** (writing a fresh image to the device's storage from scratch, e.g. for the DIY route on your own SBC) — Yes. That wipes the device's persistent storage entirely, trial state included, so the device comes back up on a brand-new 24-hour trial. This is inherent to reflashing being a genuine clean slate, not a workaround to route around.

---

## Additional Support

For unresolved architectural inquiries, assistance with SSH automation scripts, or advanced deployment discussions, the following community resources are available.

### Community Channels

* **Discord:** [Join the Discord](https://discord.com/invite/xqQ6ybkfWS) — Engage with the engineering community, discuss bare-metal automation workflows, and access direct technical support.
* **GitHub Issues:** [USBridge-KVM-2.0 Issues](https://github.com/USBridge-Technologies/USBridge-KVM-2.0/issues) — Report documentation/hardware issues; [USBridge-Remote Issues](https://github.com/USBridge-Technologies/USBridge-Remote/issues) for the client apps.
