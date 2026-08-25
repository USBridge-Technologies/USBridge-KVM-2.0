# Storage Security & Data Protection Specification

The USBridge storage security architecture is predicated on three core engineering pillars: strict hardware data isolation, immutable Btrfs snapshots, and adherence to open file-system standards.

---

## 1. Supported Storage Media & Requirements

Because the underlying snapshot architecture utilizes Copy-on-Write (CoW) file-system layers, the choice of storage media directly impacts long-term reliability and physical cell endurance:

* **Primary MicroSD Interface:** Requires high-endurance, industrial-grade, or surveillance-grade MicroSD cards. These classes of media are specifically engineered to handle continuous block-level delta operations without premature flash controller failure.

> [!NOTE]
> Native support for external USB-C flash drives and high-speed Solid-State Drives (SSDs) is under active development. This capability will be released in a future firmware update to allow larger mass storage mapping during heavy OS provisioning sequences.

---

## 2. Security Vector & Storage Format Semantics

The appliance combines strict hardware-level domain isolation with open-source file-system layers to guarantee data integrity against logical or network-based target compromises.

| Security Vector | Architectural Implementation & Enforcement |
| :--- | :--- |
| **Offline Execution Loop** | The snapshot orchestration engine operates completely offline. Block creation and volume management are executed locally via the KVM hardware, removing network-based attack vectors from the target host side. |
| **Ransomware Overwrite Resistance** | Completed snapshots are structurally locked as read-only Btrfs subvolumes. Malicious encryption subroutines or mass deletion payloads executing on a compromised target host merely generate a new write delta state, leaving all historical block matrices completely untouched and verifiable. |
| **Open Standards (Zero Vendor Lock-in)** | All data structures are written using standard Btrfs layout semantics without proprietary hardware encryption wrappers. In an emergency, the storage medium can be physically pulled from the KVM and natively mounted on any standard Linux workstation for immediate data recovery. |

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
