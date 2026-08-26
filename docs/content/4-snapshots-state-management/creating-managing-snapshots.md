# Creating & Managing Snapshots

---

## 1. First-Time Media Setup

1. Insert a MicroSD card into the appliance's card slot (power the appliance off first — don't hot-swap the card while it's actively mounted).
2. Power on, then on the front panel go to **Settings → SD Card → Format SD** — this lays down the required Btrfs layout on the card. It's a destructive operation with its own on-device confirmation step.
3. Once formatted, the **Settings → SD Card** screen header shows **READY** in green alongside filesystem type and free space (**OFFLINE** in red if the card isn't mounted — that's your at-a-glance status check).
4. Optionally, **Settings → SD Card → Snapshot Settings** lets you adjust the quiet-period interval described below.

---

## 2. Getting Data Onto the Appliance

Mount the **Backup Flash** entry — either from the client app's **Snapshots** tab, or from the front panel's own **Backup Mount** screen (device-status-menu **Snapshots** menu) — and it exposes itself to your workstation as a standard **MTP** device (labeled **Main storage**), no custom drivers needed. This is the live, current-state volume, mounted **read-write**: copy files in with your OS's normal file manager, and they land directly on the storage the snapshot daemon is watching.

Every *sealed* historical snapshot, by contrast, mounts strictly **read-only** — only the live volume accepts new writes; see [§3](#3-auditing--recovering-from-a-snapshot) below.

### Automatic Snapshot Generation
The snapshot daemon watches the storage volume for file-system activity and freezes a new read-only snapshot after a **quiet period** — 30 seconds with no further writes by default (**Settings → SD Card → Snapshot Settings**). If you're writing continuously (a large, ongoing copy that never lets the quiet period elapse), it won't wait forever: a snapshot is forced at least every 30 minutes, so you're never left with an unbounded gap between snapshots.

---

## 3. Auditing & Recovering From a Snapshot

### Client App
1. **Snapshots** tab → select a snapshot entry → **Info** icon. This shows its date, size, and a **changelog**: the actual file-level operations captured in it (creation, rename, truncation, timestamp updates, and more) — not just a generic "something changed" summary.
2. To recover data, click that snapshot's connect icon — unlike the live **Backup Flash** volume, a historical snapshot always mounts **read-only** via MTP. Browse it with your file manager and copy out whatever you need; there's no risk of altering the historical state while you're in there, because the mount itself won't accept writes.
3. The appliance exposes only **one** MTP storage slot at a time, so mounting a snapshot swaps out whatever was previously mounted there — the live **Backup Flash** or a different snapshot. Connecting the live flash works the same way: click its connect icon on the **Backup Flash** row (this is the same action described in [§2](#2-getting-data-onto-the-appliance) above); click it again to disconnect, which asks for confirmation since it stops all connected USB devices and restarts them without it.
4. Once a snapshot is mounted, its row shows a solid dot instead of a button — there's no direct "unmount" action on the row itself. To disconnect it without swapping in something else, stop it from the **Devices** tab instead.
5. Mounting the flash or a snapshot needs a free USB device slot. If all slots are already taken by other devices (keyboard, mouse, RNDIS, drives), free one on the **Devices** tab first — the app will tell you if it's blocked for this reason.

### Front Panel
No client app or network access needed — the same **Snapshots** menu used to mount the live **Backup Flash** ([§2](#2-getting-data-onto-the-appliance)) lists every historical snapshot too, in one combined list. See [Onboard Device Status & Menu Navigation](../1-getting-started/device-status-menu.md#2-main-menu-reference-specification) for the physical controls; on that screen specifically:
* Joystick **Up/Down** — move the selection between the live flash and each snapshot.
* **Button 1** — mount the selected entry. As with the client app, only one thing can be mounted at a time — mounting a different entry swaps out whatever was mounted before.
* **Button 2** — unmount the selected entry, if it's the one currently mounted. Unlike the client app's Snapshots tab (where a mounted snapshot has no direct unmount control and has to be stopped from the Devices tab), the front panel can unmount a snapshot directly.
* **Button 3** — refresh the list.

A confirmation prompt appears before either action actually takes effect, since it reconfigures the appliance's USB gadget.

### Without Mounting Anything
* **One file's history across every snapshot:** the [REST API](../10-developer-api/rest-api-reference.md#9-backup--snapshots-btrfs) can look up a specific path directly — which snapshots contain it, its size and timestamps in each — without mounting and searching snapshots one at a time.
* **From a Starlark script:** `list_backups()` returns the same snapshot list the client shows (name, size, timestamps, and an `mtp_source` you can pass straight to `insert_media()`/`reconnect_gadget()`) — useful for automating something like "mount last night's snapshot as media and boot from it" without any manual steps. See the [Starlark Scripting Reference](../3-bios-in-terminal/scripting-automation.md#3-built-in-functions).
