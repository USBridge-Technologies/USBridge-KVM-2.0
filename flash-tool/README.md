# USBridge-KVM Recovery Flash Tool

Recover a **USBridge-KVM 2.0** appliance that won't boot, or do a full first-time reflash of its eMMC storage — over USB, from Linux, macOS, or Windows (via WSL). USBridge-KVM 2.0 is a hardware IP-KVM built on a Radxa Zero 3W (Rockchip **RK3566**); this tool talks to that chip directly using Rockchip's own USB flashing protocol (`rkdeveloptool`), the same way any RK3566 board is recovered.

> **Not sure you need this?** A healthy device updates itself over the network (OTA) — see [Firmware Update Guide § 1](../docs/content/9-updates-changelog/firmware-update-guide.md#1-checking-for-and-applying-an-update). Use this tool only when the device won't boot, has never connected to a network, or you specifically need to wipe and reinstall the eMMC. Full background: [Firmware Update Guide § 4](../docs/content/9-updates-changelog/firmware-update-guide.md#4-full-reflash-from-scratch-emmc-via-usb).

New to USBridge-KVM 2.0? See the [product page](https://www.usbridge.io/) and the [project README](../README.md) for what this appliance actually does.

## What's in this directory

| File | What it is |
| :--- | :--- |
| `flash-device-fast.sh` | The flashing script. Uses a `.bmap` block map to write only the eMMC blocks that actually contain data — a 14.4 GiB image drops to ~830 MiB actually written. Accepts the downloaded `.gptimg.zst` directly and decompresses it on the fly (no multi-GB temporary file, no separate decompress step). |
| `rk356x_spl_loader_v1.23.114.bin` | The RK3566 boot loader binary `rkdeveloptool` needs to initialize DDR before it can write anything. Not the firmware itself — a small helper the script pushes into the chip's RAM automatically. |

## Prerequisites

1. **`rkdeveloptool`** — the Rockchip USB flashing CLI.
   - Debian/Ubuntu Linux: `sudo apt install rkdeveloptool`
   - Other Linux distros / macOS / Windows (via WSL): see [Install a Rockchip Flashing Tool](../docs/content/9-updates-changelog/firmware-update-guide.md#42-install-a-rockchip-flashing-tool) in the full guide.
2. **`zstd`** (usually already installed on Linux; `sudo apt install zstd` if not).
3. **`python3`** (used to parse the `.bmap` and stream the write).
4. The firmware image + block map, matching versions, from **[ota.usbridge.io/flash-images/](https://ota.usbridge.io/flash-images/)**:
   - `usbridge-rz3w-<version>.gptimg.zst`
   - `usbridge-rz3w-<version>.gptimg.bmap`

## Usage

```bash
git clone https://github.com/USBridge-Technologies/USBridge-KVM-2.0.git
cd USBridge-KVM-2.0/flash-tool

# put your downloaded usbridge-rz3w-<version>.gptimg.zst and matching
# .gptimg.bmap in this directory (the loader binary already ships here)

./flash-device-fast.sh
```

Or point it at an image anywhere else:
```bash
./flash-device-fast.sh /path/to/usbridge-rz3w-<version>.gptimg.zst
```
(An already-decompressed `.gptimg` works too, if you'd rather have one on disk — same command, just point it at that file instead.)

### Step by step

1. **Enter Maskrom mode**: disconnect power, press and hold the **Maskrom button**, apply power while still holding it, keep holding ~5 seconds, then release. The device now enumerates over USB as a Rockchip loader device (Vendor ID `2207`), not a normal drive.
2. **Run the script** (see Usage above). If your user account isn't in the `rkdeveloptool` group yet, the script tells you the one-time fix (`sudo usermod -aG rkdeveloptool $USER`, then re-login) — or just run it once via `pkexec bash flash-device-fast.sh ...` / `sudo` if you'd rather not wait for that to take effect.
3. It downloads the boot loader into the chip's RAM, decompresses the image on the fly, and writes only the blocks the `.bmap` marks as used — watch the per-region progress in the terminal.
4. On success the device reboots on its own into the freshly-flashed firmware.

A device flashed this way starts fresh, like a brand-new unit — it boots into the initial trial period and needs [network setup](../docs/content/1-getting-started/initial-setup.md) again. See the [FAQ](../docs/content/8-maintenance-support/faq.md) for how the trial/license works.

## Troubleshooting

- **"BMAP file not found"** — the `.bmap` must be downloaded separately from the `.gptimg.zst`/`.gptimg`, same version, sitting next to it with the matching base name.
- **"Loader binary not found"** — you're likely running a copy of `flash-device-fast.sh` without the rest of this directory; re-clone or re-download the whole `flash-tool/` folder.
- **Device never detected** — reconnect and redo the Maskrom-mode button sequence; on Windows/WSL, make sure you `usbipd attach`ed the device (see the [WSL section](../docs/content/9-updates-changelog/firmware-update-guide.md#45-flashing-from-windows-via-wsl) of the full guide) — this is required again after every unplug/replug.
- Anything else: the full [Firmware Update Guide](../docs/content/9-updates-changelog/firmware-update-guide.md) has the complete walkthrough, including the Windows RKDevTool GUI and manual `rkdeveloptool` paths as fallbacks.
