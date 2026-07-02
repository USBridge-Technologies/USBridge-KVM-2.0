# Snapshots & State Management: Overview

[cite_start]The snapshot mechanism in the USBridge-KVM 2.0 appliance is engineered to preserve critical data states independently of the target server[cite: 1, 28]. [cite_start]This subsystem complements standard out-of-band KVM access by enabling deterministic, block-level data operations that remain entirely isolated from the host operating system[cite: 2, 28, 31].

---

## 1. Autonomy & Hardware-Level Isolation

[cite_start]A fundamental engineering property of the USBridge storage architecture is its absolute independence from the target server's resources and state variables[cite: 3, 28].

| Architectural Property | Technical Execution |
| :--- | :--- |
| **Zero Host Dependency** | [cite_start]Snapshot generation requires no drivers, kernel agents, or background software installation on the managed target machine[cite: 28]. |
| **Hardware-Level Isolation** | [cite_start]The target host has zero permission, physical routing, or bus-level access to create, modify, or delete stored snapshots[cite: 31]. [cite_start]This ensures total resilience against compromised OS environments or ransomware payloads[cite: 31]. |
| **Event-Driven Triggers** | Data block captures are initiated autonomously by the appliance based on file-system events (`inotify`) or programmatically enforced quiet periods following write operations. |
| **Out-of-Band Control** | Operators can manually trigger block captures or audit historical snapshot states directly via the physical hardware controls and the built-in LCD screen. |

---

## 2. Core Storage & File-System Principles

The storage architecture enforces strict, transparent principles to guarantee predictable recovery behavior during critical infrastructure failures:

* [cite_start]**Copy-on-Write (CoW) Semantics:** Utilizing standard Btrfs filesystem mechanics, snapshots share unmodified data blocks[cite: 29, 32]. [cite_start]Delta changes are written exclusively to free blocks without overwriting the previous historical state, ensuring highly efficient storage retention[cite: 29, 30].
* [cite_start]**Absolute Immutability:** Immediately upon creation, the system seals each snapshot as a strictly read-only Btrfs subvolume[cite: 30].
* [cite_start]**Standardized Format (No Vendor Lock-in):** By avoiding proprietary encryption wrappers or closed storage formats, the raw Btrfs filesystem can be pulled, mounted, and read natively on any standard Linux workstation during emergency recovery scenarios[cite: 32].
* **Crash Consistency:** Snapshots capture a transaction-accurate state equivalent to an instant power-loss event, strictly preserving metadata integrity.

---

## 3. System Boundaries & Limitations

To maintain maximum operational reliability at Layer 0, this subsystem operates within explicit engineering and workload boundaries.

### Scope & Workload Profile
* [cite_start]**Target Boundaries:** The capture scope is strictly limited to the storage file-system state (directory trees, blocks, metadata, and static file content)[cite: 63]. Volatile state data, such as system RAM contents, CPU registries, active kernel drivers, or in-flight network processes, is intentionally excluded.
* **Intended Use Case:** Consequently, this hardware subsystem is **not** engineered to act as a primary OS boot disk, a high-frequency database transaction volume, or a target for continuous high-ingestion server log streams.

### Recovery Model & Capacity Behavior
* **Extraction Over In-Place Rollback:** Because the architecture enforces read-only Btrfs subvolumes, in-place destructive rollback operations are structurally prohibited by design. To execute a recovery, administrators mount the desired snapshot and safely extract the required data layers to a secondary physical medium.
* **Fail-Safe Capacity Policy:** Automatic block rotation or automated aging/deletion logic is deliberately omitted. When physical storage capacity on the MicroSD medium is completely exhausted, the appliance safely blocks new write operations and transitions the storage stack into a permanent archive mode. This guarantees that all existing historical snapshots remain intact, unaltered, and readable.
