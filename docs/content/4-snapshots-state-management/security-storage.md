# Storage Security & Data Protection Specification

The USBridge storage security architecture is predicated on three core engineering pillars: strict hardware data isolation, immutable Btrfs snapshots, and adherence to open file-system standards.

---

## 1. Supported Storage Media & Requirements

Because the underlying snapshot architecture utilizes Copy-on-Write (CoW) file-system layers, the choice of storage media directly impacts long-term reliability and physical cell endurance:

* **Primary MicroSD Interface:** Requires high-endurance, industrial-grade, or surveillance-grade MicroSD cards. These classes of media are specifically engineered to handle continuous block-level delta operations without premature flash controller failure.

> [!NOTE]
> I am currently testing and developing native support for external USB-C flash drives and high-speed Solid-State Drives (SSDs). This capability will be released in a future firmware update to allow larger mass storage mapping during heavy OS provisioning sequences.

---

## 2. Security Vector & Storage Format Semantics

The appliance combines strict hardware-level domain isolation with open-source file-system layers to guarantee data integrity against logical or network-based target compromises.

| Security Vector | Architectural Implementation & Enforcement |
| :--- | :--- |
| **Offline Execution Loop** | The snapshot orchestration engine operates completely offline. Block creation and volume management are executed locally via the KVM hardware, removing network-based attack vectors from the target host side. |
| **Ransomware Overwrite Resistance** | Completed snapshots are structurally locked as read-only Btrfs subvolumes. Malicious encryption subroutines or mass deletion payloads executing on a compromised target host merely generate a new write delta state, leaving all historical block matrices completely untouched and verifiable. |
| **Open Standards (Zero Vendor Lock-in)** | All data structures are written using standard Btrfs layout semantics without proprietary hardware encryption wrappers. In an emergency, the storage medium can be physically pulled from the KVM and natively mounted on any standard Linux workstation for immediate data recovery. |

---

## 3. Fail-Safe Capacity Management Policy

To guarantee the structural integrity of historical archives, the USBridge firmware enforces a strict, deterministic capacity boundary policy:

> [!WARNING]
> **No Automated Block Deletion**
> The architecture intentionally omits automated block rotation, background deletion, or garbage-collection aging algorithms. This prevents the system from ever executing an accidental or automated purge of critical historical recovery states.

### Exhaustion Behavior
When the physical storage capacity of the MicroSD card is completely exhausted, the system automatically executes the following fail-safe routine:
1. Natively halts the generation of all new event-driven snapshots.
2. Transitions the active storage volume layout into a permanent, protected **Read-Only Archive Mode**.
3. Keeps all existing historical snapshots intact, uncorrupted, and fully readable.

### Capacity Reclamation Workflow
To safely reclaim block space on a full medium, administrators must physically detach the MicroSD card and manually prune or manage the Btrfs subvolumes on an external administrative Linux workstation outside of the active USBridge operational environment.
