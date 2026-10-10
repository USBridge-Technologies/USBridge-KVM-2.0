# USBridge-KVM Recovery Flash Tool — Sipeed NanoKVM

Install USBridge on a **Sipeed NanoKVM** (SOPHGO **SG2002**), or recover one that won't boot — by writing the firmware image onto its microSD card from a card reader on your computer (Linux, macOS, or Windows via WSL).

> Other boards: [`../rz3w/`](../rz3w/) (Radxa Zero 3W, RK3566) and [`../a7z/`](../a7z/) (Radxa Cubie A7Z, A733).

> **microSD only.** The NanoKVM boots from its microSD card and has no eMMC or USB recovery mode: take the card out, write it here, put it back. The boot loader (`fip.bin`) is in the image's FAT **BOOT** partition, where the SG2002 boot ROM loads it from.

> **Not sure you need this?** A healthy device updates itself over the network (OTA) — see [Firmware Update Guide § 1](../../docs/content/9-updates-changelog/firmware-update-guide.md#1-checking-for-and-applying-an-update). Full background: [Recovery Flashing Guide § 8](../../docs/content/9-updates-changelog/recovery-flashing-guide.md#8-sipeed-nanokvm-sophgo-sg2002) and the [NanoKVM page](../../docs/content/6-hardware-connectivity/nanokvm.md).

## What's in this directory

| File | What it is |
| :--- | :--- |
| `install.sh` | One-shot installer — installs prerequisites, downloads `flash-sd-card.sh` plus the latest NanoKVM firmware, and runs the flash. `USBRIDGE_SD_DEVICE` is required. |
| `flash-sd-card.sh` | Writes the firmware image onto the card via a host card reader, using the `.bmap` block map to write only the blocks that contain data. |

## Quick start: one command

```bash
USBRIDGE_SD_DEVICE=/dev/sdX curl -fsSL https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/flash-tool/nanokvm/install.sh | bash
```

Find the right `/dev/sdX` first with `lsblk` — it wipes the target device entirely. Overrides: `USBRIDGE_VERSION=<version>` pins a build, `USBRIDGE_SD_FORCE=1` skips the removable-disk check (only if you're certain), `USBRIDGE_WORKDIR` changes the download directory (default `~/.usbridge-flash-tool/`).

## Manual usage

1. **Prerequisites**: `zstd`, `python3`.
2. Download, matching versions, from **[flash.usbridge.io](https://flash.usbridge.io/)**: `usbridge-nanokvm-<version>.gptimg.zst` and `usbridge-nanokvm-<version>.gptimg.bmap` (`latest-nanokvm.txt` names the newest version).
3. ```bash
   sudo ./flash-sd-card.sh /dev/sdX usbridge-nanokvm-<version>.gptimg.zst
   ```

**Windows without WSL:** extract the `.gptimg.zst` with 7-Zip, then write the `.gptimg` with balenaEtcher or Rufus (DD image mode). If Windows offers to format any of the card's partitions afterwards, always **Cancel**.

## After flashing

- Optional: put a [`usbridge_provision.json`](../../docs/content/1-getting-started/headless-provisioning.md#sipeed-nanokvm-the-boot-partition-of-its-microsd-card) into the card's **BOOT** partition (static IP, master key, …) — on Windows, give BOOT a drive letter in `diskmgmt.msc` if it has none.
- Put the card back into the NanoKVM and power on. It gets its address by DHCP; on first boot the backup storage (`/mnt/emmc`, btrfs) grows to the rest of the card.
- A device flashed this way starts fresh: initial trial period, [network setup](../../docs/content/1-getting-started/initial-setup.md) again.

## Troubleshooting

- **"BMAP file not found"** — download the `.gptimg.bmap` of the same version and put it next to the image with the same base name.
- **"does not look like a removable SD card / USB reader"** — the script refuses disks the kernel doesn't report as removable; re-run with `--force` (or `USBRIDGE_SD_FORCE=1`) only if you're certain about the target.
