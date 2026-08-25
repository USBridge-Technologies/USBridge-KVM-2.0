# Storage & Media Snapshots: Overview

USBridge protects the files you copy onto its **Backup Flash** volume — independently of the host you're managing. That storage lives on the appliance's own hardware-isolated media, and every change to it is captured as an immutable, read-only Btrfs snapshot: every checkpoint stays fully accessible, and none can ever be altered or deleted.

![USBridge snapshots](https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/snapshots.png)

---

## 1. What It Protects Against

| Threat | Risk to Traditional Storage | What USBridge Does |
| :--- | :--- | :--- |
| **Ransomware / malware on the target** | Bulk encryption or deletion across network shares. | The target has no bus-level path to the appliance's storage at all — it can't reach it to encrypt or delete anything, regardless of privilege level. |
| **Root compromise on the target** | An attacker with full root wipes or overwrites your golden images. | New writes never overwrite existing data — they land in a fresh layer, and every sealed snapshot is frozen read-only. See [Storage Security & Immutability](./security-storage.md) for exactly what can and can't touch a snapshot. |
| **Human error** | An admin accidentally deletes an important file from Backup Flash. | Every snapshot is a point-in-time copy — pull the file back out of whichever snapshot last had it. |
| **Appliance failure / vendor lock-in** | Data unreadable without proprietary recovery software. | Standard Btrfs, nothing proprietary. Pull the card and mount it on any Linux box. |

---

## 2. How It Works

* **Copy-on-Write:** Snapshots share unmodified blocks with each other via standard Btrfs CoW — only the actual delta between snapshots costs space, not a full duplicate of every virtual image each time.
* **Zero host dependency:** No driver, agent, or background install on the target — it doesn't even know snapshotting is happening.
* **Access without going near the target:** Manage and audit snapshots from the client app, the front panel, or [scripted via `list_backups()`](../3-bios-in-terminal/scripting-automation.md#3-built-in-functions) — see [Creating & Managing Snapshots](./creating-managing-snapshots.md) for the actual workflow.

---

## 3. Scope & Limitations

* **File-system state only.** This captures directory trees, files, and metadata on the storage volume — not target-side RAM, running processes, or anything else that isn't on disk.
* **Not a database or a boot disk.** It's built for point-in-time recovery of virtual media and deployment files, not as a high-frequency transactional volume or a primary production OS disk.
* **Recovery is extraction, not in-place rollback.** Snapshots are read-only by design, so there's no "revert to this snapshot" button — you mount the snapshot you want and pull the files out. See [Creating & Managing Snapshots](./creating-managing-snapshots.md).
* **No automatic deletion, ever.** Nothing rotates or ages snapshots out — see [Storage Security & Immutability §3](./security-storage.md#3-no-automated-deletion-and-no-remote-way-to-erase-snapshots) for exactly what happens once the card fills up (it's simpler than you'd expect: new snapshots just stop, existing ones are completely unaffected).

---

> [!TIP]
> **Next Steps:**
> To create and manage your first snapshots, see [Creating & Managing Snapshots](./creating-managing-snapshots.md). For the security model behind all of this, see [Storage Security & Immutability](./security-storage.md).
