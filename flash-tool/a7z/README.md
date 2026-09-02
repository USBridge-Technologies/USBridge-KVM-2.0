# USBridge-KVM Recovery Flash Tool — Radxa Cubie A7Z

Recover a **USBridge-KVM 2.0** appliance on the **Radxa Cubie A7Z** (Allwinner **A733**) board, or do a full first-time flash — straight onto an SD card, from Linux, macOS, or Windows (via WSL).

> Have the other supported board (**Radxa Zero 3W** / Rockchip RK3566) instead? See [`../rz3w/`](../rz3w/) — different SoC, with an onboard-eMMC/USB (Maskrom) recovery path as well as SD. Not sure which you have? The front-panel **Settings → Info** screen names the board.

> **SD card only, for now.** This board ships with its eMMC controller disabled in the device tree, so unlike RZ3W there's no onboard-eMMC/USB recovery path to fall back to — flashing always means writing the image onto an SD card from a reader on your computer, then putting that card in the appliance's SD slot.

> **Not sure you need this?** A healthy device updates itself over the network (OTA) — see [Firmware Update Guide § 1](../../docs/content/9-updates-changelog/firmware-update-guide.md#1-checking-for-and-applying-an-update). Use this tool only when the device won't boot, has never connected to a network, or you specifically need to wipe and reinstall. Full background: [USB Recovery Flashing Guide § 7](../../docs/content/9-updates-changelog/recovery-flashing-guide.md#7-radxa-cubie-a7z-allwinner-a733).

New to USBridge-KVM 2.0? See the [product page](https://www.usbridge.io/) and the [project README](../../README.md) for what this appliance actually does.

## What's in this directory

| File | What it is |
| :--- | :--- |
| `install.sh` | One-shot installer — installs prerequisites, downloads `flash-sd-card.sh` plus the latest firmware, and runs the flash. This is the file the `curl \| bash` one-liner fetches. `USBRIDGE_SD_DEVICE` is required (not optional like RZ3W's) — there's no other target to default to. |
| `flash-sd-card.sh` | Writes the firmware image onto an SD card via a host card reader. Uses a `.bmap` block map to write only the blocks that actually contain data, same sparse writing as RZ3W's equivalent script. |

## Quick start: one command

On Linux (or WSL on Windows — see [§ 5](../../docs/content/9-updates-changelog/recovery-flashing-guide.md#5-flashing-from-windows-via-wsl) of the full guide for the one-time USB-passthrough setup, if your card reader is itself a USB device passed through from Windows):

```bash
USBRIDGE_SD_DEVICE=/dev/sdX curl -fsSL https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/flash-tool/a7z/install.sh | bash
```

Find the right `/dev/sdX` first with `lsblk` — it wipes the target device entirely. This installs `zstd`/`python3` if missing (Debian/Ubuntu via `apt`), downloads `flash-sd-card.sh`, fetches the **latest** firmware image + block map from [ota.usbridge.io](https://ota.usbridge.io/flash-images/), and flashes it.

Useful overrides:
```bash
# pin a specific firmware version instead of the latest
USBRIDGE_VERSION=1.1.159 USBRIDGE_SD_DEVICE=/dev/sdX curl -fsSL .../install.sh | bash

# the script refuses non-removable disks and the host's own system disk --
# only pass this if you're certain about the target and it's being wrongly refused
USBRIDGE_SD_FORCE=1 USBRIDGE_SD_DEVICE=/dev/sdX curl -fsSL .../install.sh | bash
```
Files land in `~/.usbridge-flash-tool/` by default (`USBRIDGE_WORKDIR` to change it) and are reused on a re-run instead of re-downloaded.

Once written, move the card to the appliance's SD slot and power on — there's no **Install to eMMC** step to move to afterward like RZ3W has; just leave the card in.

## Manual usage

Prefer to inspect what you're running first, or already have a git clone? Same tool, no auto-install/auto-download magic:

1. **Prerequisites**: `zstd`, `python3`.
2. Download the firmware image + block map, matching versions, from **[ota.usbridge.io/flash-images/](https://ota.usbridge.io/flash-images/)**: `usbridge-a7z-<version>.gptimg.zst` and `usbridge-a7z-<version>.gptimg.bmap`.
3. ```bash
   git clone https://github.com/USBridge-Technologies/USBridge-KVM-2.0.git
   cd USBridge-KVM-2.0/flash-tool/a7z
   # put your downloaded .gptimg.zst and .gptimg.bmap in this directory
   sudo ./flash-sd-card.sh /dev/sdX
   # or an explicit image path:
   sudo ./flash-sd-card.sh /dev/sdX /path/to/usbridge-a7z-<version>.gptimg.zst
   ```
   Requires root (direct block-device access). Refuses to target the host's own system disk or a non-removable disk unless you pass `--force`.

### Step by step

1. **Find the SD card**: insert it into a reader on your computer (not the appliance — the appliance isn't connected to your computer for this path at all) and identify its device path with `lsblk`.
2. **Run the script.** Always needs `sudo` (direct block-device access).
3. It decompresses the image on the fly and writes only the blocks the `.bmap` marks as used — watch the per-region progress in the terminal.
4. Move the card to the appliance's SD slot and power on.

A device flashed this way starts fresh, like a brand-new unit — it boots into the initial trial period and needs [network setup](../../docs/content/1-getting-started/initial-setup.md) again. See the [FAQ](../../docs/content/8-maintenance-support/faq.md) for how the trial/license works.

## Troubleshooting

- **"BMAP file not found"** — the `.bmap` must be downloaded separately from the `.gptimg.zst`/`.gptimg`, same version, sitting next to it with the matching base name.
- **"does not look like a removable SD card / USB reader"** — `flash-sd-card.sh` refuses disks the kernel doesn't report as removable, to avoid wiping the wrong device by mistake. If you're certain about the target, re-run with `--force` (or `USBRIDGE_SD_FORCE=1` for `install.sh`).
- Anything else: the full [USB Recovery Flashing Guide § 7](../../docs/content/9-updates-changelog/recovery-flashing-guide.md#7-radxa-cubie-a7z-allwinner-a733) has the complete walkthrough.
