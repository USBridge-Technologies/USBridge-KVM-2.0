# flash-tool

Linux tooling for a full from-scratch eMMC reflash of a USBridge-KVM
appliance over USB (RK3566 / Radxa Zero 3W), for when OTA isn't an option
(device won't boot, never connected to a network, etc).

See the full walkthrough — including entering Maskrom mode and the Windows
(RKDevTool) / macOS equivalents — in the
[Firmware Update Guide](../docs/content/9-updates-changelog/firmware-update-guide.md#4-full-reflash-from-scratch-emmc-via-usb).

## What's here

- `flash-device-fast.sh` — writes only the used blocks of a `.gptimg` (via
  its `.bmap` block map) instead of the whole multi-GB image byte for byte.
  Much faster than a plain `rkdeveloptool wl 0 <image>`.
- `rk356x_spl_loader_v1.23.114.bin` — the RK3566 boot loader binary
  `rkdeveloptool` needs to initialize DDR before it can write anything. Not
  the firmware itself, just a small helper program pushed into the chip's
  RAM.

## Quick usage

1. Install `rkdeveloptool` (`sudo apt install rkdeveloptool` on
   Debian/Ubuntu; see the Firmware Update Guide for other distros).
2. Download the latest `usbridge-rz3w-<version>.gptimg.zst` **and** the
   matching `usbridge-rz3w-<version>.gptimg.bmap` from
   [ota.usbridge.io/flash-images/](https://ota.usbridge.io/flash-images/) —
   same version, both files. Decompress the image: `zstd -d usbridge-rz3w-<version>.gptimg.zst`.
3. Put the decompressed `.gptimg` and its `.gptimg.bmap` in this directory
   (next to `flash-device-fast.sh`), or anywhere else and pass the image
   path as an argument.
4. Put the appliance into Maskrom mode (hold the Maskrom button, apply
   power, hold ~5s, release).
5. Run it:
   ```bash
   ./flash-device-fast.sh
   # or explicitly:
   ./flash-device-fast.sh /path/to/usbridge-rz3w-<version>.gptimg
   ```
