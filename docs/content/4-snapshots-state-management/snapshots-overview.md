# Storage & Media Snapshots: Overview

The **Storage & Media Snapshots** subsystem in the USBridge-KVM 2.0 appliance is engineered to safeguard your virtual media, ISO images, and user files independently of the managed host. By utilizing immutable file-system layers, this architecture ensures that your source data remains unencrypted, undeleted, and fully recoverable even during catastrophic infrastructure-level compromises.

![USBridge snapshots](https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/docs/assets/snapshots.png)

---

## 1. Value & Security Matrix: What It Protects Against

To help you immediately understand the operational advantages of the USBridge storage layer, the table below maps potential threat vectors against our hardware-enforced protection mechanisms:

| Threat Vector / Scenario | Risk to Traditional Storage | USBridge Protection Mechanism |
| :--- | :--- | :--- |
| **Ransomware / Malware Payload** | Bulk file encryption or destructive data deletion across network shares. | **Absolute Protection:** Strict hardware isolation. The compromised server has no physical bus-level path to access or modify KVM storage. |
| **Root Account Compromise** | An attacker with full `root` privileges wipes or overwrites local golden images. | **Immutable Layers:** New modifications never overwrite source files; the system redirects writes to a separate layer and freezes snapshots in a read-only state. |
| **Human Error (Accidental Deletion)** | An administrator accidentally deletes an important ISO, configuration image, or deployment script. | **Point-in-Time Recovery:** Since snapshots are instantly frozen in a read-only state, you can always access and extract the exact version of the file from a previous snapshot. |
| **Hardware / Appliance Failure** | "Vendor Lock-in" where data is unreadable without specific proprietary software. | **Open Standard Archive:** All data is stored using the standard Btrfs file system. Files can be pulled, mounted, and read natively on any Linux machine without USBridge software. |

---

## 2. Core Technology Principles

The underlying storage architecture relies on transparent, low-level file-system mechanics to guarantee predictable data states:

* **Copy-on-Write (CoW) Semantics & Delta Tracking:** Unmodified data blocks are shared safely between snapshots using standard Btrfs mechanics. Instead of duplicating entire large virtual images, the system saves only the "delta" of changes, ensuring highly efficient storage retention.
* **Zero Host Dependency:** Snapshot routines require no drivers, host-level kernel agents, or background software installation on the managed target machine.
* **Out-of-Band Auditing:** Operators can manage media snapshots, monitor storage capacity, or view allocation metrics directly via the native client application or physical on-device controls.

---

## 3. System Boundaries & Workload Limitations

To maintain maximum reliability at Layer 0, the storage subsystem operates within explicit engineering boundaries.

### Scope & Workload Profile
* **File-System Boundary Only:** The capture scope is strictly limited to the storage file-system state (directory trees, blocks, metadata, and static file content). Volatile state data, such as system RAM contents, CPU registries, or active kernel processes, is entirely excluded.
* **Intended Use Case:** This storage layer is **not** engineered to act as a high-frequency database transaction volume, a primary OS boot disk for heavy production environments, or a target for continuous high-ingestion server log streams.

### Recovery Model & Capacity Behavior
* **Extraction Over In-Place Rollback:** Because the architecture enforces read-only Btrfs subvolumes to maintain data integrity, in-place destructive rollback operations are prohibited by design. To execute a recovery, administrators mount the desired snapshot and safely extract the required files to a secondary physical medium.
* **Fail-Safe Capacity Policy:** Automatic block rotation or automated aging/deletion logic is deliberately omitted. When physical storage capacity on the MicroSD medium is completely exhausted, the appliance safely blocks new write operations and transitions the storage stack into a permanent archive mode. This guarantees that all existing historical snapshots remain unaltered, readable, and safe from accidental overwrite.

---

> [!TIP]
> **Next Steps:**
> To learn how to initialize your first media snapshot or configure write-isolation layers for your ISO images, proceed to [Creating & Managing Media Snapshots](./creating-managing-snapshots.md).
