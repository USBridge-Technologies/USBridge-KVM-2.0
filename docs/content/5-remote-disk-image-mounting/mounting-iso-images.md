# Mounting ISO Images (Virtual Media)

USBridge attaches a `.iso` image to the target as a standard, physically-present USB CD/DVD-ROM drive — hardware-level emulation, so it works identically at BIOS/UEFI boot menus and inside any installed OS, with no PXE infrastructure and no driver on the target.

---

## 1. Two Ways to Source an Image

| Source | How it works | Best for |
| :--- | :--- | :--- |
| **Local storage (SD/eMMC)** | Upload the `.iso` onto the appliance ahead of time (client app, or the [REST API](../10-developer-api/rest-api-reference.md#7-storage--virtual-media)); it's mounted straight from the device's own storage. | Images you'll reuse repeatedly, or a fully offline/air-gapped session — nothing needs to stay reachable on your workstation once uploaded. |
| **Direct client streaming (NBD)** | Point the client app at an `.iso` file on your own workstation and mount it *without uploading it anywhere first*. The client spins up a local NBD server for that file, and the appliance connects to it as an NBD client over the network — the file itself never leaves your machine. | One-off installs, large images you don't want to duplicate onto the appliance's storage, or anything you don't intend to keep around after the session. |

Both end up presented to the target identically — as a mounted optical drive. Which one to use is purely about where the bytes live, not a difference in target-side behavior.

---

## 2. RAM Cache on Streamed Sources

Direct client streaming backs the image with a RAM cache, so repeated/random access (an installer re-reading the same boot sectors, browsing the same directory) stays fast instead of re-hitting the network on every read — boot sectors in particular are available instantly. Local-storage sources don't need this; they're already reading from the appliance's own storage.

It's on by default. Turn it off per-mount with the API's `use_nbd_cache: false` if you'd rather not use the RAM for it.

---

## 3. Mounting Workflow

1. **Pick a source:** upload to local storage, or point the client at a file on your workstation for direct streaming — see the table above.
2. **Mount:** trigger the mount from the client app's *Devices*/*Virtual Media* controls, or from the appliance's front panel for an already-staged local file.
3. **Enumeration:** the target's USB controller enumerates a new optical drive immediately — it shows up in the BIOS/UEFI boot menu like any physically inserted disc.

---

> [!TIP]
> To boot from a pre-configured Virtual Machine image (`.vdi`/`.vmdk`) or a local partition instead of an installer disc, see [Booting Server from Workstation Drives & VMs](./booting-from-virtual-disks.md) — same streaming/caching model, different source types.
