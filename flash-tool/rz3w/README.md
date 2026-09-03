# USBridge-KVM Recovery Flash Tool — Radxa Zero 3W

Recover a **USBridge-KVM 2.0** appliance that won't boot, or do a full first-time reflash of its eMMC storage — over USB, from Linux, macOS, or Windows (via WSL). Also covers writing the same firmware straight onto an SD card instead, via a host card reader. This board is a hardware IP-KVM built on a Radxa Zero 3W (Rockchip **RK3566**); the eMMC path talks to that chip directly using Rockchip's own USB flashing protocol (`rkdeveloptool`), the same way any RK3566 board is recovered.

> Have the other supported board (**Radxa Cubie A7Z** / Allwinner A733) instead? See [`../a7z/`](../a7z/) — different SoC, different (simpler, SD-only) recovery path. Not sure which you have? The front-panel **Settings → Info** screen names the board.

> **Not sure you need this?** A healthy device updates itself over the network (OTA) — see [Firmware Update Guide § 1](../../docs/content/9-updates-changelog/firmware-update-guide.md#1-checking-for-and-applying-an-update). Use this tool only when the device won't boot, has never connected to a network, or you specifically need to wipe and reinstall the eMMC (or want to run it off an SD card). Full background: [USB Recovery Flashing Guide](../../docs/content/9-updates-changelog/recovery-flashing-guide.md).

New to USBridge-KVM 2.0? See the [product page](https://www.usbridge.io/) and the [project README](../../README.md) for what this appliance actually does.

## What's in this directory

| File | What it is |
| :--- | :--- |
| `install.sh` | One-shot installer — installs prerequisites, downloads everything below plus the latest firmware, and runs the flash. This is the file the `curl \| bash` one-liner fetches. Flashes the onboard eMMC over USB by default; set `USBRIDGE_SD_DEVICE` to write to an SD card instead (see below). |
| `flash-device-fast.sh` | eMMC flashing over USB (via `rkdeveloptool`, Maskrom mode). Uses a `.bmap` block map to write only the blocks that actually contain data — a 14.4 GiB image drops to ~830 MiB actually written. Accepts the downloaded `.gptimg.zst` directly and decompresses it on the fly (no multi-GB temporary file, no separate decompress step). |
| `flash-sd-card.sh` | Writes the same image straight onto an SD card via a host card reader — no USB/`rkdeveloptool`/Maskrom involved. Use this to run the appliance off an SD card instead of (re)flashing the onboard eMMC. Same sparse `.bmap`-based writing as above. |
| `rk356x_spl_loader_v1.23.114.bin` | The RK3566 boot loader binary `rkdeveloptool` needs to initialize DDR before it can write anything. Only needed for the eMMC/USB path — not used by `flash-sd-card.sh`. |
| [`factory-reset/`](factory-reset/) | Wipes the onboard eMMC back to factory-blank (no OS, empty GPT) instead of installing firmware — use this to make the board fall through to booting from an SD card. Not a firmware install; see that directory's own notes. |

## Restoring the eMMC to factory-blank (no firmware)

If you want the board wiped back to how it shipped — no OS on the eMMC, just the idblock/preloader and an empty partition table, so it boots from an SD card instead — use `factory-reset/restore-factory-default.sh` rather than the full firmware flash above:

```bash
# 1. Put the device in Maskrom mode
cd flash-tool/rz3w/factory-reset
./restore-factory-default.sh
```

See [`factory-reset/README.md`](factory-reset/README.md) for details on what gets written.

## Quick start (recommended): step-by-step installation

On Linux (or WSL on Windows — see [§ 5](../../docs/content/9-updates-changelog/recovery-flashing-guide.md#5-flashing-from-windows-via-wsl) of the full guide first for the one-time USB-passthrough setup):

```bash
# 1. Put the device in Maskrom mode (hold Maskrom button, connect USB-C, release button after 5s)

# 2. Install prerequisites
sudo apt update && sudo apt install -y rkdeveloptool zstd python3 curl

# 3. Download helper script and latest firmware
curl -fsSL -O https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/flash-tool/rz3w/flash-device-fast.sh
curl -fsSL -O https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/flash-tool/rz3w/rk356x_spl_loader_v1.23.114.bin
chmod +x flash-device-fast.sh
VERSION=$(curl -fsSL https://flash.usbridge.io/latest-rz3w.txt)
curl -fsSL -O https://flash.usbridge.io/usbridge-rz3w-${VERSION}.gptimg.zst
curl -fsSL -O https://flash.usbridge.io/usbridge-rz3w-${VERSION}.gptimg.bmap

# 4. Flash the device
sudo ./flash-device-fast.sh usbridge-rz3w-${VERSION}.gptimg.zst
```

These commands do everything: install `rkdeveloptool`/`zstd`/`python3`/`curl` if missing (Debian/Ubuntu via `apt`), download `flash-device-fast.sh` and the boot loader, fetch the **latest** firmware image + block map from [flash.usbridge.io](https://flash.usbridge.io/), and flash it.

Prefer a single command instead? `install.sh` does the same thing end to end:
```bash
curl -fsSL https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/flash-tool/rz3w/install.sh | bash
```
Useful overrides:
```bash
# pin a specific firmware version instead of the latest
USBRIDGE_VERSION=1.2.59 curl -fsSL .../install.sh | bash

# skip the "press Enter" pause -- have the device already in Maskrom mode
USBRIDGE_NO_PROMPT=1 curl -fsSL .../install.sh | bash

# write to an SD card instead of the onboard eMMC over USB (no Maskrom needed)
USBRIDGE_SD_DEVICE=/dev/sdX curl -fsSL .../install.sh | bash
```
Files land in `~/.usbridge-flash-tool/` by default (`USBRIDGE_WORKDIR` to change it) and are reused on a re-run instead of re-downloaded.

### SD card instead of eMMC

The appliance boots and runs identically off an SD card — same firmware image, no separate build. Insert the card into a reader on your computer (not the appliance) and either:

```bash
USBRIDGE_SD_DEVICE=/dev/sdX curl -fsSL https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/flash-tool/rz3w/install.sh | bash
```
or, step by step:
```bash
curl -fsSL -O https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/flash-tool/rz3w/flash-sd-card.sh
chmod +x flash-sd-card.sh
VERSION=$(curl -fsSL https://flash.usbridge.io/latest-rz3w.txt)
curl -fsSL -O https://flash.usbridge.io/usbridge-rz3w-${VERSION}.gptimg.zst
curl -fsSL -O https://flash.usbridge.io/usbridge-rz3w-${VERSION}.gptimg.bmap
sudo ./flash-sd-card.sh /dev/sdX usbridge-rz3w-${VERSION}.gptimg.zst
```

Either way, no Maskrom mode and no `rkdeveloptool` are needed for this path — find the right `/dev/sdX` with `lsblk` first, it wipes the target device entirely. The script refuses non-removable disks and the host's own system disk unless you also set `USBRIDGE_SD_FORCE=1` (or pass `--force` manually). Once written, move the card to the appliance's SD slot and power on.

On a board that also has a real eMMC, the firmware detects whichever device it actually booted from at runtime, so this works correctly with both present at once — and the on-device Settings menu gains an **Install to eMMC** action once booted from the card, letting you copy the running system onto the eMMC later without touching a computer again.

## Manual usage

Prefer to inspect what you're running first, or already have a git clone? Same tool, no auto-install/auto-download magic:

1. **Prerequisites**: `rkdeveloptool` (`sudo apt install rkdeveloptool` on Debian/Ubuntu — see [§ 2](../../docs/content/9-updates-changelog/recovery-flashing-guide.md#2-install-a-rockchip-flashing-tool) of the full guide for other distros/macOS/Windows; not needed for the SD card path), `zstd`, `python3`.
2. Download the firmware image + block map, matching versions, from **[flash.usbridge.io](https://flash.usbridge.io/)**: `usbridge-rz3w-<version>.gptimg.zst` and `usbridge-rz3w-<version>.gptimg.bmap`.
3. ```bash
   git clone https://github.com/USBridge-Technologies/USBridge-KVM-2.0.git
   cd USBridge-KVM-2.0/flash-tool/rz3w
   # put your downloaded .gptimg.zst and .gptimg.bmap in this directory
   # (the loader binary already ships here)
   ./flash-device-fast.sh
   ```
   Or point it at an image anywhere else: `./flash-device-fast.sh /path/to/usbridge-rz3w-<version>.gptimg.zst` (an already-decompressed `.gptimg` works too).

   For an SD card instead, same image/bmap, no `rkdeveloptool`/Maskrom step:
   ```bash
   sudo ./flash-sd-card.sh /dev/sdX
   # or an explicit image path:
   sudo ./flash-sd-card.sh /dev/sdX /path/to/usbridge-rz3w-<version>.gptimg.zst
   ```
   Requires root (direct block-device access). Refuses to target the host's own system disk or a non-removable disk unless you pass `--force`.

### Step by step (either method)

1. **Enter Maskrom mode**: disconnect power, press and hold the **Maskrom button**, apply power while still holding it, keep holding ~5 seconds, then release. The device now enumerates over USB as a Rockchip loader device (Vendor ID `2207`), not a normal drive. Not needed for the SD card path — `flash-sd-card.sh` writes to the card directly, the appliance isn't even connected to your computer.
2. **Run the script.** If your user account isn't in the `rkdeveloptool` group yet, the manual path tells you the one-time fix (`sudo usermod -aG rkdeveloptool $USER`, then re-login) — `install.sh` runs the flash step via `sudo` automatically instead, so you don't have to wait for that. `flash-sd-card.sh` always needs `sudo` (direct block-device access), regardless of that group.
3. It downloads the boot loader into the chip's RAM (eMMC path only), decompresses the image on the fly, and writes only the blocks the `.bmap` marks as used — watch the per-region progress in the terminal.
4. On success the device reboots on its own into the freshly-flashed firmware (eMMC path), or you move the card to the appliance's SD slot and power on (SD path).

A device flashed this way starts fresh, like a brand-new unit — it boots into the initial trial period and needs [network setup](../../docs/content/1-getting-started/initial-setup.md) again. See the [FAQ](../../docs/content/8-maintenance-support/faq.md) for how the trial/license works.

## Troubleshooting

- **"BMAP file not found"** — the `.bmap` must be downloaded separately from the `.gptimg.zst`/`.gptimg`, same version, sitting next to it with the matching base name.
- **"Loader binary not found"** — you're likely running a copy of `flash-device-fast.sh` without the rest of this directory; re-clone or re-download the whole `flash-tool/rz3w/` folder. (Not applicable to `flash-sd-card.sh`, which doesn't use the loader.)
- **Device never detected (eMMC/USB path)** — reconnect and redo the Maskrom-mode button sequence; on Windows/WSL, make sure you `usbipd attach`ed the device (see the [WSL section](../../docs/content/9-updates-changelog/recovery-flashing-guide.md#5-flashing-from-windows-via-wsl) of the full guide) — this is required again after every unplug/replug.
- **"does not look like a removable SD card / USB reader" (SD path)** — `flash-sd-card.sh` refuses disks the kernel doesn't report as removable, to avoid wiping the wrong device by mistake. If you're certain about the target, re-run with `--force` (or `USBRIDGE_SD_FORCE=1` for `install.sh`).
- Anything else: the full [USB Recovery Flashing Guide](../../docs/content/9-updates-changelog/recovery-flashing-guide.md) has the complete walkthrough, including the Windows RKDevTool GUI and manual `rkdeveloptool` paths as fallbacks.
