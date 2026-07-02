# Factory Reset

The Factory Reset procedure is engineered to rapidly restore the USBridge appliance to a known baseline state.

This hardware-level workflow is critical for recovering administrative control following severe credential loss or when securely decommissioning the hardware for redeployment to a new target node.

## Hardware-Level Initialization

The autonomous hardware reset functionality is currently undergoing final validation for an upcoming firmware release. The mechanism is architected to operate entirely independent of network connectivity, SSH daemons, or client application access.

Initialization is executed strictly via the appliance's local physical interface. To prevent accidental triggering within dense rack environments, the execution flow mandates explicit physical confirmation, such as a prolonged multi-button tactile sequence, directly on the device enclosure.

---

## Configuration Purge Scope

When the Factory Reset sequence is authorized via the local menu, the internal controller executes a destructive purge of all volatile and non-volatile configuration states.

| System Component | Post-Reset State |
| :--- | :--- |
| **Network Configuration** | Complete purge of static IP assignments, routing tables, and cached Wi-Fi credentials. The primary interface reverts to default DHCP discovery. |
| **Authentication Material** | Cryptographic erasure of all access tokens, including QUIC session keys, custom SSH host keys, and local administrative passwords. |
| **Device Preferences** | Restores all local LCD menu settings, display parameters, and HID emulation toggles to absolute factory defaults. |

---

## Data Retention Boundaries

A fundamental architectural principle of the appliance is the strict separation of control-plane configuration from data-plane storage.

> **Important Note on Storage Preservation:**  
> Because all hardware snapshots and file archives are committed to external, isolated storage media (SD card, SSD, or HDD), executing a Factory Reset on the core appliance **does not format, mutate, or expose** the attached storage volume. All historical read-only Btrfs subvolumes remain fully preserved and structurally intact following the reset sequence.
