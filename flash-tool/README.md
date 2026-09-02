# USBridge-KVM Recovery Flash Tool

Recover a **USBridge-KVM 2.0** appliance that won't boot, or do a full first-time reflash — over USB or straight onto an SD card, from Linux, macOS, or Windows (via WSL).

> **Not sure you need this?** A healthy device updates itself over the network (OTA) — see [Firmware Update Guide § 1](../docs/content/9-updates-changelog/firmware-update-guide.md#1-checking-for-and-applying-an-update). Use this tool only when the device won't boot, has never connected to a network, or you specifically need to wipe and reinstall. Full background: [USB Recovery Flashing Guide](../docs/content/9-updates-changelog/recovery-flashing-guide.md).

New to USBridge-KVM 2.0? See the [product page](https://www.usbridge.io/) and the [project README](../README.md) for what this appliance actually does.

## Pick your board

USBridge-KVM 2.0 ships on two different hardware platforms — pick the matching subdirectory. Not sure which you have? The front-panel **Settings → Info** screen names the board.

| Board | SoC | Directory | Recovery path |
| :--- | :--- | :--- | :--- |
| **Radxa Zero 3W** (the common one) | Rockchip RK3566 | [`rz3w/`](./rz3w/) | Onboard eMMC over USB (Maskrom + `rkdeveloptool`), or straight onto an SD card |
| **Radxa Cubie A7Z** | Allwinner A733 | [`a7z/`](./a7z/) | SD card only for now (this board ships with its eMMC controller disabled) |

Each subdirectory is self-contained — its own `install.sh`/flashing script(s) and its own README with the full quick-start and manual-usage instructions for that board. Files aren't duplicated across them by reference (even where the underlying script is nearly identical, e.g. both boards' `flash-sd-card.sh`) so each one can be downloaded and run on its own without pulling in the other board's tooling.

## Troubleshooting

Board-specific issues (BMAP errors, device-not-detected, etc.) are covered in each subdirectory's own README. For anything not covered there, the full [USB Recovery Flashing Guide](../docs/content/9-updates-changelog/recovery-flashing-guide.md) has the complete walkthrough for both boards, including the Windows RKDevTool GUI and WSL USB-passthrough setup (RZ3W).
