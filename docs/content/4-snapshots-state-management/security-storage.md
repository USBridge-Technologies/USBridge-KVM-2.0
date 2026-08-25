# Storage Security & Immutability

---

## 1. Supported Storage Media

**MicroSD** is the baseline medium, supported on every unit. Because snapshots ride on Btrfs Copy-on-Write, use a high-endurance card — industrial/surveillance-grade cards are built for exactly this kind of sustained, small-block write pattern; cheap consumer cards wear out faster under it.

**Board revisions with an NVMe slot** can use an NVMe drive instead, for higher capacity and endurance than a MicroSD card.

> [!NOTE]
> External USB flash drives and SSDs as storage media are in active development — not available yet. The intent is for USBridge to sit inline as a protected storage controller: the external drive plugs into the appliance rather than directly into the target, so the same write-isolation and immutable-snapshot model in this document applies to it too.

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
