# Factory Reset

Factory Reset restores the USBridge appliance's *configuration* to a known baseline state — useful for recovering administrative control after credential loss, or for securely decommissioning a unit before redeploying it to a new target.

## Triggering It

From the front panel: **Settings → Factory Reset**. A confirmation dialog appears first — you must explicitly confirm before anything is touched. Once confirmed, the appliance wipes its configuration and powers itself off; power it back on to boot into a clean state.

---

## Configuration Purge Scope

| System Component | Post-Reset State |
| :--- | :--- |
| **Network Configuration** | Wi-Fi credentials, Tailscale registration state cleared. |
| **Authentication Material** | Master API secret, SSH host keys, and every SSH login account created via **Users Control** are wiped — you'll need to [create a fresh one](../3-bios-in-terminal/technology-overview.md) to SSH in again. |
| **Moonlight/Sunshine Pairing** | Streaming pairing configuration is cleared. |
| **Starlark Scripts** | Any custom `.star` scripts are removed; the built-in default scripts are restored. |
| **Device Preferences** | Local LCD menu settings and display parameters revert to factory defaults. |

---

## What's Deliberately Preserved

> [!IMPORTANT]
> **Your trial/license state survives a Factory Reset — this is by design, not an oversight.** The device backs up its license state before wiping configuration and restores it afterward, specifically so an administrative reset can never be used to "refresh" a trial or undo a device's licensed status. See the [FAQ](./faq.md) for how licensing works.

> [!NOTE]
> **Storage Preservation.** Because all hardware snapshots and file archives are committed to external, isolated storage media (SD card, SSD, or HDD), a Factory Reset **does not format, mutate, or expose** the attached storage volume. All historical read-only Btrfs subvolumes remain fully preserved and structurally intact.
