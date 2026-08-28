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
> **Your trial/license state survives a Factory Reset — this is by design, not an oversight.** The device backs up its license state before wiping configuration and restores it afterward, specifically so an administrative reset can never be used to "refresh" a trial or undo a device's licensed status. See the [FAQ](./faq.md) for how licensing works, and see below for the separate, explicit **Reset License** action.

---

## Reset License (Separate From Factory Reset)

**Settings → Reset License** is a distinct menu action that *does* clear trial/license state and reboots the appliance into a fresh 24-hour trial. It exists precisely because Factory Reset deliberately does not touch licensing (above) — this is the one explicit path meant to undo that. Everything else — network configuration, authentication material, Moonlight/Sunshine pairing, Starlark scripts, device preferences — is **left untouched**; it is the mirror image of Factory Reset, which wipes everything *except* license state.

> [!NOTE]
> This is a local, physical-menu-only action, gated behind the same confirmation dialog as Factory Reset — it is not exposed over the network API, SSH, or any remote management surface, so it can't be triggered by a script running against the device from off-box. It does not add a new way to bypass licensing beyond what already existed: anyone with physical/root access to the appliance could already reach the same "fresh trial" state by removing the on-disk license file directly — resetting the same self-heal path (see `docs/LICENSING.md` in the `usbridge` repo) — this menu item just gives that the same supported, confirmed UI treatment as every other reset action instead of leaving it as an undocumented workaround.

> [!NOTE]
> **Storage Preservation.** Because all hardware snapshots and file archives are committed to external, isolated storage media (SD card, SSD, or HDD), a Factory Reset **does not format, mutate, or expose** the attached storage volume. All historical read-only Btrfs subvolumes remain fully preserved and structurally intact.
