# Creating & Managing Snapshots

The USBridge-KVM 2.0 snapshot workflow is architected to capture, seal, and preserve historical data states on external, hardware-isolated storage media. For optimal reliability during bare-metal deployment and staging, follow this standardized provisioning and management procedure.

---

## 1. Media Preparation & Hardware Initialization

Before initiating block-level data operations, you must prepare the physical storage layer and establish the hardware link:

* [cite_start]**Media Installation:** Insert a high-endurance, write-intensive MicroSD card (industrial-grade pSLC media is strongly recommended) into the dedicated on-board slot[cite: 58]. *Alternative:* Connect an external enterprise SSD to the appliance via the primary USB-C expansion port.
* [cite_start]**Host Interconnect:** Connect the USBridge appliance to the target machine using the primary USB-C control line[cite: 55].
* **Initialization & Health Verification:** Power on the appliance. [cite_start]Navigate to **Settings** -> **SD Card** via the built-in LCD screen and rotary encoder to verify media mounting status, file-system health, and available block capacity[cite: 51, 52].

---

## 2. Volume Mounting & Host Access Provisioning

[cite_start]Storage provisioning and virtual block exposure are executed out-of-band through the native USBridge Client application[cite: 60]:

1. Launch the **USBridge Client** and navigate to the **Storage Module** panel.
2. Select **Mount Drive** to expose the storage block allocation.
3. Choose the appropriate hardware emulation protocol:
   * **Mass Storage Device Mode (Default):** Exposes the volume as a standard raw block device (USB Hard Drive/Flash). [cite_start]Ideal for direct OS provisioning and raw partitions[cite: 25, 26, 55].
   * **MTP Mode:** Emulates the Media Transfer Protocol for high cross-platform file compatibility without locking the block layer.
4. [cite_start]Once activated, the isolated storage volume mounts directly within the target host's operating system as a native local drive, requiring zero custom host drivers[cite: 25, 26].

---

## 3. Automated Snapshot Generation Pipeline

Data state capture is an autonomous, event-driven background process that eliminates the need for manual command execution:

```text
[Target Host Write Activity] ──> [USBridge Storage Layer]
                                           │
                                           ▼ (inotify / Write Completion)
[Read-Only Btrfs Subvolume] <─── [Automated Snapshot Trigger]
```
### 3. Automated Snapshot Generation Pipeline

Data state capture is an autonomous, event-driven background process that eliminates the need for manual command execution:

* **Data Staging:** Transfer your critical files, deployment images, or configuration backups onto the mounted USBridge drive layer.
* **Automated Trigger:** The internal KVM engine monitors file-system actions using kernel-level `inotify` routines. Upon detecting write completions followed by a programmable quiet period, the system autonomously triggers a block-level snapshot.
* **Immutability Enforcement:** The newly generated state is instantaneously registered in the client database and locked as a strictly read-only Btrfs subvolume.
* **Hierarchy Audit:** Administrators can traverse the directory tree via the client registry at any time to inspect historical states and extract pristine data sets for clean bare-metal recoveries.

---

### 4. Delta Change Analysis & Auditing

Beyond static storage archival, the subsystem provides granular tracking of data modifications between captured states:

* **Telemetry Access:** Within the client interface, every snapshot entry features a detailed information toggle `(i)`. Clicking this element requests the underlying Btrfs engine to compute block differences.
* **Modification Inspection:** The interface renders a comprehensive structural diff log, explicitly listing all file additions, modifications, and deletions encompassed within that specific snapshot delta. This allows for instant auditing of what exactly changed on the drive during staging.

---

### 5. Security & Access Governance

All recorded state changes are secured via strict hardware and file-system level isolation protocols:

* **Hardware-Enforced Write Protection:** Once a state is committed to a snapshot, the subvolume is structurally restricted to Read-Only access at the kernel layer of the KVM.
* **Total Host Isolation:** The target server's operating system completely lacks the bus routing, permissions, or drivers required to modify, overwrite, or purge the snapshot repository. This establishes a reliable, non-volatile recovery vector even following catastrophic operating system failures or deep ransomware encryption events on the host machine.
