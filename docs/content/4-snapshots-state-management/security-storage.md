# Storage Security & Data Protection Specification

[cite_start]The USBridge storage security architecture is predicated on three core engineering pillars: strict hardware data isolation, immutable Btrfs snapshots, and adherence to open file-system standards[cite: 63, 64].

---

## 1. Supported Storage Media & Hardware Requirements

[cite_start]Because the underlying snapshot architecture utilizes Copy-on-Write (CoW) file-system layers[cite: 63], the choice of storage media directly impacts long-term reliability and physical cell endurance:

* [cite_start]**Primary MicroSD Interface:** Requires high-endurance, industrial-grade, or surveillance-grade MicroSD cards (pSLC or advanced high-TBW MLC media are strongly recommended)[cite: 58]. These classes of media are specifically engineered to handle continuous block-level delta operations without premature controller failure.
* [cite_start]**External USB-C Storage:** The architecture features native support for external USB flash drives and high-speed Solid-State Drives (SSDs) routed through the dedicated USB-C host interface layer. This allows for larger mass storage mapping during heavy OS provisioning sequences.

---

## 2. Security Vector & Storage Format Semantics

[cite_start]The appliance combines strict hardware-level domain isolation with open-source file-system layers to guarantee data integrity against logical or network-based target compromises[cite: 31, 32].

| Security Vector | Architectural Implementation & Enforcement |
| :--- | :--- |
| **Offline Execution Loop** | The snapshot orchestration engine operates completely offline. [cite_start]Block creation, cryptographic integrity audits, and volume management are executed locally via the KVM hardware, removing network-based attack vectors from the target host side[cite: 31]. |
| **Ransomware Overwrite Resistance** | [cite_start]Completed snapshots are structurally locked as read-only Btrfs subvolumes[cite: 30]. [cite_start]Malicious encryption subroutines or mass deletion payloads executing on a compromised target host merely generate a new write delta state [cite: 30][cite_start], leaving all historical block matrices completely untouched and verifiable[cite: 31]. |
| **Open Standards (Zero Vendor Lock-in)** | [cite_start]All data structures are written using standard Btrfs layout semantics without proprietary hardware encryption wrappers[cite: 32]. [cite_start]In an emergency, the storage medium can be physically pulled from the KVM and natively mounted on any standard Linux workstation for immediate data recovery[cite: 32]. |

---

## 3. Fail-Safe Capacity Management Policy

To guarantee the structural integrity of historical archives, the USBridge firmware enforces a strict, deterministic capacity boundary policy:

> [!WARNING]
> **No Automated Block Deletion**
> The architecture intentionally omits automated block rotation, background deletion, or garbage-collection aging algorithms. This prevents the system from ever executing an accidental or automated purge of critical historical recovery states.

### Exhaustion Behavior
When the physical storage capacity of the MicroSD card or attached SSD is completely exhausted, the system automatically executes the following fail-safe routine:
1. Natively halts the generation of all new event-driven snapshots.
2. Transitions the active storage volume layout into a permanent, protected **Read-Only Archive Mode**.
3. Keeps all existing historical snapshots intact, uncorrupted, and fully readable.

### Capacity Reclamation Workflow
[cite_start]To safely reclaim block space on a full medium, administrators must physically detach the storage card or drive and manually prune or manage the Btrfs subvolumes on an external administrative Linux workstation outside of the active USBridge operational environment[cite: 32].
