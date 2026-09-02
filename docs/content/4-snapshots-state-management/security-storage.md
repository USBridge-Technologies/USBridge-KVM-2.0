# Storage Security & Immutability

---

## 1. Supported Storage Media

**MicroSD** is the baseline medium, supported on every unit. Because snapshots ride on Btrfs Copy-on-Write, use a high-endurance card — industrial/surveillance-grade cards are built for exactly this kind of sustained, small-block write pattern; cheap consumer cards wear out faster under it.

> [!NOTE]
> **Formatting a card uses its full capacity immediately — no separate resize step.** **Settings → SD Card → Format SD Card** partitions and formats the entire card as one Btrfs volume sized to its real capacity at format time (not a fixed size copied from a smaller reference card), so there's no `growpart`/manual-resize step needed afterward, and no unallocated space left over regardless of how large the card is.

**NVMe** is supported on board revisions with an NVMe slot, for higher capacity and endurance than a MicroSD card.

> [!NOTE]
> NVMe firmware support is still pending — the hardware capability is there on NVMe-equipped boards, but the firmware release that enables it hasn't shipped yet.

> [!NOTE]
> External USB flash drives and SSDs as *snapshotted storage* are in active development — not available yet. You can physically connect one today (through an external hub, alongside the [capture dongle](../2-kvm-vkm/video-streaming-quality.md#1-hardware-pipeline--signal-routing) if needed — the appliance's own USB-C Host port doesn't have a second one free), the appliance just doesn't yet treat it as backup media the way it does the MicroSD/NVMe slot. The intent is for USBridge to sit inline as a protected storage controller: the external drive plugs into the appliance rather than directly into the target, so the same write-isolation and immutable-snapshot model in this document applies to it too.

### Real-World Endurance: Why This Workload Is Easy on the Card

Constant in-place rewrites of the same blocks — a database, a journaling filesystem, a VM disk — are what burn through flash endurance fastest, because the same physical cells get hit over and over. Snapshotting doesn't have that problem: once a snapshot is sealed, its blocks are never rewritten (see [§3](#3-no-automated-deletion-and-no-remote-way-to-erase-snapshots)), so each backed-up byte is physically written to the card essentially once, not repeatedly.

That means a card's rated endurance converts almost directly into total lifetime archival capacity, instead of being eaten down by rewrite amplification. A typical industrial/surveillance-grade microSD card — the same class used in dashcams and security DVRs — is commonly rated in the tens of terabytes written (TBW) by its manufacturer; for a write-once workload like this, that's close to the actual total volume of unique backup data you could accumulate over the card's life, not a number a rewrite-heavy workload would divide down fast.

The one exception is the live **Backup Flash** volume itself, before it's captured into its next snapshot: if you repeatedly rewrite the same file within a single quiet period, that region does see genuine repeated physical writes. Once it's sealed into a snapshot, though, it's never touched again — which is exactly why this storage layer isn't meant for a high-frequency transactional workload (see [Scope & Limitations](./snapshots-overview.md#3-scope--limitations)) — that pattern would defeat the write-once advantage entirely.

---

## 2. What Actually Protects the Data

* **It's entirely on-device.** Snapshot creation and volume management run locally on the appliance — the target host has no network path into any of it. Nothing about snapshotting depends on or is reachable from the machine being managed.
* **Snapshots are read-only Btrfs subvolumes.** Once sealed, a snapshot is never written to again. A compromised target — even with full root — can only generate new writes on top of the current state; it has no way to reach back and alter or delete a snapshot that already exists.
* **Standard Btrfs, no proprietary format.** No vendor lock-in: pull the card and mount it on any Linux machine to read your data directly, no USBridge software required.

For what specifically can't touch a snapshot (including a compromised API credential) and why, see [§3 below](#3-no-automated-deletion-and-no-remote-way-to-erase-snapshots).

---

## 3. No Automated Deletion, and No Remote Way to Erase Snapshots

> [!WARNING]
> **No Automated Block Deletion**
> There is no background rotation, aging, or garbage-collection logic anywhere in the snapshot pipeline — nothing on the appliance ever deletes or overwrites a completed snapshot on its own. Existing snapshots are read-only Btrfs subvolumes; nothing in the running system writes to them again after they're sealed.

### What Happens When the Card Fills Up
There's no special "archive mode" the appliance switches into — it's simpler than that, and follows directly from the point above: since nothing ever deletes an existing snapshot, a full card just means new snapshot creation starts failing (logged, not silent) once there's no space left for the next one. Every snapshot already on the card remains exactly as readable and intact as it always was, because nothing about how it's stored changes when the disk fills up — there's no deletion logic to disable, no mode to fall back from.

### There Is No API or Screen Path to Delete a Snapshot
This isn't just policy — it's an absence: no REST/MCP endpoint, and no front-panel screen, ever deletes or formats existing snapshot data. **[Formatting the storage volume is a physical, front-panel-only action](../8-maintenance-support/factory-reset.md)** with its own on-device confirmation step, or otherwise requires physically removing the card and reformatting it on another machine. This means [pairing credential compromise](../10-developer-api/security-model.md#1-physical-pairing--the-root-of-trust-for-the-api) — even full API access from a stolen master secret — cannot be used to erase your snapshot history; that requires physical access to the device or the card itself.

### Reclaiming Space
To free up space on a full card, physically detach it and manage the Btrfs subvolumes directly from an external Linux workstation — there's no in-appliance way to selectively delete old snapshots while keeping others.

---

## 4. Onboard Storage (`/mnt/emmc`) & Automatic Capacity Growth

Separately from the removable MicroSD card above, the appliance's own boot storage — its onboard eMMC, or the boot SD card itself on boards that [run from an SD slot instead](../9-updates-changelog/recovery-flashing-guide.md#6-writing-to-an-sd-card-instead) — carries an extra data partition of its own, mounted at `/mnt/emmc`. It's used the same way as the MicroSD slot for ISO images and automation scripts, and is present regardless of whether a MicroSD card is inserted at all.

The firmware image is built with a fixed minimum size for this partition, so the exact same image works on any eMMC/SD card at or above that baseline. **On first boot, a one-shot service automatically expands `/mnt/emmc` to consume whatever capacity exists beyond that baseline on the real card/eMMC** — no `growpart`/`resize2fs`-equivalent step is needed by hand, and this happens whether the underlying medium is the onboard eMMC or a boot SD card. A much larger eMMC or SD card than the build baseline doesn't leave the difference unallocated; it becomes usable `/mnt/emmc` space automatically within the first boot.

> [!NOTE]
> This is separate from, and unrelated to, the removable MicroSD/snapshot volume in [§1](#1-supported-storage-media) — that one is sized to full capacity at format time instead (see the note there), so it doesn't need this kind of post-boot growth at all.
