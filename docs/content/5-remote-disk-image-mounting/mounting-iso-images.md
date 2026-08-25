# Mounting ISO Images (Virtual Media)

USBridge attaches a `.iso` image to the target as a standard, physically-present USB CD/DVD-ROM drive — hardware-level emulation, so it works identically at BIOS/UEFI boot menus and inside any installed OS, with no PXE infrastructure and no driver on the target.

---

## 1. Two Ways to Source an Image

| Source | How it works | Best for |
| :--- | :--- | :--- |
| **Local storage (SD/eMMC)** | Upload the `.iso` onto the appliance ahead of time (client app, or `POST /api/iso/upload`); it's mounted straight from the device's own storage. | Images you'll reuse repeatedly, or a fully offline/air-gapped session — nothing needs to stay reachable on your workstation once uploaded. |
| **Direct client streaming (NBD)** | Point the client app at an `.iso` file on your own workstation and mount it *without uploading it anywhere first*. The client spins up a local NBD server for that file, and the appliance connects to it as an NBD client over the network — the file itself never leaves your machine. | One-off installs, large images you don't want to duplicate onto the appliance's storage, or anything you don't intend to keep around after the session. |

Both end up presented to the target identically — as a mounted optical drive. Which one to use is purely about where the bytes live, not a difference in target-side behavior.

---

## 2. RAM Cache on Streamed (NBD) Sources

Because NBD-streamed sources depend on the network round-trip to your workstation for every uncached read, the appliance fronts them with a RAM cache so repeated/random access (an installer re-reading the same boot sectors, browsing the same directory) doesn't re-hit the network every time:

* **First ~8 MB** are prefetched straight into RAM (`tmpfs`) — boot sectors are available instantly, before the rest of the image has even been touched.
* **Up to 1 GB of RAM** is used as a `dm-cache` layer for hot blocks — the kernel promotes/evicts blocks automatically as they're re-read, so frequently-accessed regions stay fast without you managing anything.
* Everything else is read from the NBD stream on demand, populating the cache as it goes.

This is enabled by default; disable it per-mount with `use_nbd_cache: false` if you'd rather not spend the RAM (e.g. on a very memory-constrained session). Local-storage sources don't need this — they're already reading from the appliance's own storage.

> [!NOTE]
> The 1 GB hot-block cache needs `dm_cache`/`thin-provisioning-tools` support on the appliance; without it, streaming still works but falls back to just the 8 MB instant-boot prefetch, no hot-block caching on top.

---

## 3. Mounting Workflow

1. **Pick a source:** upload to local storage, or point the client at a file on your workstation for direct streaming — see the table above.
2. **Mount:** trigger the mount from the client app's *Devices*/*Virtual Media* controls, or from the appliance's front panel for an already-staged local file.
3. **Enumeration:** the target's USB controller enumerates a new optical drive immediately — it shows up in the BIOS/UEFI boot menu like any physically inserted disc.

---

> [!TIP]
> To boot from a pre-configured Virtual Machine image (`.vdi`/`.vmdk`) or a local partition instead of an installer disc, see [Booting Server from Workstation Drives & VMs](./booting-from-virtual-disks.md) — same streaming/caching model, different source types.
