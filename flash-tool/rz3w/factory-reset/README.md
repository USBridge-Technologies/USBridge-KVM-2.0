# Factory-blank eMMC restore — Radxa Zero 3W

Wipes the onboard eMMC back to the state a brand-new, never-flashed board
ships in: no OS, no data — just the Rockchip idblock/preloader region and an
empty GPT partition table. With no OS on the eMMC, the board falls through
to booting from an SD card instead.

This is **not** a firmware reinstall. For a full USBridge-KVM firmware
install, use [`../flash-device-fast.sh`](../flash-device-fast.sh) instead.

## Usage

```bash
# 1. Put the device in Maskrom mode (hold Maskrom button, connect USB-C,
#    release after ~5s)
./restore-factory-default.sh
```

Needs `rkdeveloptool` and `zstd`; uses `pkexec` automatically if not run as
root (same as the flash scripts one directory up).

## What's here

| File | What it is |
| :--- | :--- |
| `restore-factory-default.sh` | Loads the RK3566 boot loader, then writes the two files below to the device over USB and reboots it. |
| `emmc-head-16MiB.img.zst` | LBA 0–32767 (first 16 MiB): MBR, primary GPT header/partition table, and the Rockchip idblock/preloader region. zstd-compressed (~16 MiB → ~560 KiB). |
| `emmc-tail-33sectors.img` | LBA 30535647–30535679 (last 33 sectors of a 30535680-sector / 14910 MB eMMC): where a backup GPT would normally live. Tiny, kept uncompressed. |

Both were captured once, via `rkdeveloptool read`, from a known
factory-blank unit. Neither file contains any partition *data* — the two
GPT partitions they describe (a 512 MB and a ~14.9 GB region) are defined in
the table but empty; nothing from LBA 32768 onward is included. The restore
script checks the target device's reported eMMC size against the one this
dump was captured from before writing the tail region, and skips that write
(with a warning) if they don't match, to avoid corrupting a differently-sized
chip.
