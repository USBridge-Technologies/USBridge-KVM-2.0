# Creating & Managing Snapshots

---

## 1. First-Time Media Setup

1. Insert a MicroSD card into the appliance's card slot (power the appliance off first — don't hot-swap the card while it's actively mounted).
2. Power on, then on the front panel go to **Settings → SD Card → Format SD** — this lays down the required Btrfs layout on the card. It's a destructive operation with its own on-device confirmation step.
3. Once formatted, the **Settings → SD Card** screen header shows **READY** in green alongside filesystem type and free space (**OFFLINE** in red if the card isn't mounted — that's your at-a-glance status check).
4. Optionally, **Settings → SD Card → Snapshot Settings** lets you adjust the quiet-period interval described below.

---

## 2. Getting Data Onto the Appliance

There's more than one path onto the appliance's storage — pick whichever fits what you're doing:

| Method | How | Best for |
| :--- | :--- | :--- |
| **Client app, MTP mount** | **Snapshots** tab → **Backup Flash** entry → **Mount**. The volume exposes itself to your workstation as a standard **MTP** device (labeled **Main storage**) — no custom drivers. Copy files in with your OS's normal file manager. | Bulk transfers, arbitrary file types, anything you'd rather drag-and-drop. |
| **REST API upload** | `POST /api/iso/upload` for ISO/IMG images, `POST/PUT /api/scripts/write` for Starlark scripts — see the [REST API Reference](../10-developer-api/rest-api-reference.md#8-storage--virtual-media). | Scripted/automated staging, uploading from a pipeline instead of a person. |

Whichever way the files land on storage, the same snapshot daemon watches for it — see below.

### Automatic Snapshot Generation
The snapshot daemon watches the storage volume for file-system activity and freezes a new read-only snapshot after a **quiet period** — 30 seconds with no further writes by default (**Settings → SD Card → Snapshot Settings**). If you're writing continuously (a large, ongoing copy that never lets the quiet period elapse), it won't wait forever: a snapshot is forced at least every 30 minutes, so you're never left with an unbounded gap between snapshots.

---

## 3. Auditing & Recovering From a Snapshot

### Client App
1. **Snapshots** tab → select a snapshot entry → **Info** icon. This shows its date, size, and a **changelog**: the actual file-level operations captured in it (creation, rename, truncation, timestamp updates, and more) — not just a generic "something changed" summary.
2. To recover data, click that snapshot's **Mount** button — it mounts read-only via MTP, same as the live volume. Browse it with your file manager and copy out whatever you need; being read-only, there's no risk of altering the historical state while you're in there.

### Without Mounting Anything
* **One file's history across every snapshot:** the [REST API](../10-developer-api/rest-api-reference.md#9-backup--snapshots-btrfs) can look up a specific path directly — which snapshots contain it, its size and timestamps in each — without mounting and searching snapshots one at a time.
* **From a Starlark script:** `list_backups()` returns the same snapshot list the client shows (name, size, timestamps, and an `mtp_source` you can pass straight to `insert_media()`/`reconnect_gadget()`) — useful for automating something like "mount last night's snapshot as media and boot from it" without any manual steps. See the [Starlark Scripting Reference](../3-bios-in-terminal/scripting-automation.md#3-built-in-functions).
