# Frequently Asked Questions

---

## Core Platform & Capabilities

#### Does BIOS-to-Text support modern graphical UEFI interfaces?
The system is optimized for classic, text-oriented BIOS and UEFI environments. Full-screen graphical interfaces with rich, mouse-driven UX are not officially supported as a deterministic automation target, as highly stylized or dynamic elements are difficult to parse reliably.

#### What hardware and software platform does USBridge utilize?
The appliance is built on the Rockchip RK3566 SoC featuring a Quad-Core ARM Cortex-A55 architecture. It operates on a hardened Linux foundation, with the core software stack and internal system routing logic implemented entirely in Go.

#### Is USBridge an open-source project?
Partially, today. The **client and the [software Agent](https://github.com/USBridge-Technologies/USBridge-Remote/blob/main/agent/docs/README.md)** — desktop/mobile/web, same repo — are public under GPLv3: [github.com/USBridge-Technologies/USBridge-Remote](https://github.com/USBridge-Technologies/USBridge-Remote). The mechanical/PCB assets are public too: [github.com/USBridge-Technologies/Hardware](https://github.com/USBridge-Technologies/Hardware). Two things stay closed source: the on-device firmware/service on the hardware KVM — including the BIOS-to-Text deterministic conversion engine — and, on the Agent side, the optional **RustShine** streaming backend (a Patreon-gated alternative to the bundled, GPLv3 [Sunshine](https://github.com/LizardByte/Sunshine) engine, adding WebRTC support for the web client among other things). The Agent works fully on the free, open-source Sunshine backend without it.

#### How does USBridge differ from traditional PiKVM solutions?
Both are small ARM single-board KVMs, but the emphasis is different. USBridge is built around [BIOS-in-Terminal](../3-bios-in-terminal/technology-overview.md) — turning the pre-OS screen into real OCR'd text instead of just video — plus [Starlark/MCP automation](../3-bios-in-terminal/mcp-ai-agents.md) and [immutable Btrfs snapshots](../4-snapshots-state-management/snapshots-overview.md), none of which a video-only KVM solution has an equivalent for.

Video quality is a real, not incidental, difference too. Browser-based KVMs are built on MJPEG or plain WebRTC video with no [forward error correction](../2-kvm-vkm/video-streaming-quality.md#6-streaming-settings) — the picture stutters and drops frames the moment the network isn't perfect. USBridge streams over the **NVIDIA GameStream protocol** (Moonlight-compatible) with tunable FEC — the actual protocol NVIDIA built for game streaming: smooth enough to comfortably play a game over it, not just smooth enough to click through a BIOS menu. No browser-only KVM gets there — it's a transport-level ceiling, not a tuning problem.

---

## Storage & Media Lifecycle

#### Can standard consumer SD cards be used for snapshot storage?
Low-cost consumer SD cards are strongly discouraged. Snapshot storage utilizes Btrfs with Copy-on-Write (CoW), creating sustained write pressure that causes premature failure in cards lacking advanced wear-leveling. External SSDs or industrial-grade surveillance SD cards are required for continuous workloads.

#### Are snapshots stored on the built-in eMMC, and does this cause wear?
No. Snapshots go on the removable MicroSD card (or NVMe, on board revisions that have the slot) — the onboard eMMC only holds the OS and the bridge software itself, so it never sees the sustained write pressure of Btrfs Copy-on-Write snapshotting. That also means your snapshot history can be pulled out and read on any Linux machine without touching the appliance's own storage.

---

## Security & Immutability Models

> [!NOTE]
> This section covers data/snapshot immutability. For how pairing, API access, and streaming sessions are authenticated and encrypted, see [Security & Authentication Model](../10-developer-api/security-model.md).

#### What differentiates the USBridge backup model from a standard NAS?
There's no SMB, NFS, or any other network file-sharing protocol exposed to the target at all — the appliance shows up as a USB storage device, nothing more. A compromised target OS, even with full root, has no network path or credential that reaches the snapshot data to delete or overwrite it; the only thing it can do is write new data, which becomes tomorrow's snapshot rather than an overwrite of today's.

#### How is data immutability achieved using a standard Btrfs file system?
It's simpler than it sounds: sealed snapshots are read-only Btrfs subvolumes, and nothing in the running system ever writes to one again once it's sealed — there's no special "protection mode" layered on top, the guarantee just falls out of never having deletion code in the first place. See [Storage Security & Immutability](../4-snapshots-state-management/security-storage.md) for the full breakdown, including what happens when the card fills up (short version: new snapshots stop, existing ones are untouched — not some read-only archive mode the appliance switches into).

#### Does USBridge operate as a physical data diode?
No — KVM traffic is bidirectional, you're actively controlling the target. What's one-directional is the backup history: nothing on the target side, however compromised, has a way to roll back or delete an existing snapshot. That's an access-control guarantee, not a one-way wire.

#### Why hardened Linux instead of proprietary firmware?
Because it doesn't need to reinvent anything: the appliance never exposes destructive commands on the USB-facing side in the first place, so there's nothing for a compromised target to send even if it tried. Standard Linux hardening covers the rest — it's attack-surface reduction, not a custom crypto stack to trust.

---

## Licensing & Trial

#### Can I try USBridge before committing to it?
Yes. Every device ships with a **24-hour, fully-featured trial** that starts the moment it's powered on — no network connection or account sign-in required to begin. Streaming, BIOS-in-Terminal, virtual media, and every other licensed capability work exactly as they would on a fully licensed unit for the full trial window, with no artificial feature restrictions or watermarks.

#### How does the trial become a permanent license?
Once you're ready to keep the device, it's confirmed (**Accept**) on the vendor's device console — after that, the license is permanent and no longer depends on network connectivity or the trial timer. See [Firmware Update Guide](../9-updates-changelog/firmware-update-guide.md) for how the appliance's device-management connection also delivers OTA updates.

#### Does resetting the device reset my trial or license?
Depends on which kind of reset:
- **Factory Reset** (Settings → Factory Reset) — No. It's specifically designed to preserve trial/license state; see [Factory Reset](./factory-reset.md#whats-deliberately-preserved).
- **A full reflash** (writing a fresh image to the device's storage from scratch, e.g. for the DIY route on your own SBC) — Yes. That wipes the device's persistent storage entirely, trial state included, so the device comes back up on a brand-new 24-hour trial. This is inherent to reflashing being a genuine clean slate, not a workaround to route around.

---

## Additional Support

For unresolved architectural inquiries, assistance with SSH automation scripts, or advanced deployment discussions, the following community resources are available.

### Community Channels

* **Discord:** [Join the Discord](https://discord.com/invite/xqQ6ybkfWS) — Engage with the engineering community, discuss bare-metal automation workflows, and access direct technical support.
* **GitHub Issues:** [USBridge-KVM-2.0 Issues](https://github.com/USBridge-Technologies/USBridge-KVM-2.0/issues) — Report documentation/hardware issues; [USBridge-Remote Issues](https://github.com/USBridge-Technologies/USBridge-Remote/issues) for the client apps.
