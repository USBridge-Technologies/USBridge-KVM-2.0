# USB Recovery Flashing Guide

This guide covers how to perform a full physical recovery reflash of a **USBridge-KVM 2.0** appliance using a PC.

> [!WARNING]
> This is a **different procedure from routine network OTA updates** — use it only when the device won't boot at all, has no working OTA path yet (never connected to a network), or you specifically need to wipe and reinstall from a blank state. A healthy device should always use the standard [OTA Firmware Update Guide](./firmware-update-guide.md) instead; it is faster, doesn't need a cable to a PC, and doesn't risk interrupting a working unit.

Sections 1–6 below cover the **Radxa Zero 3W (RK3566)** board — eMMC-over-USB (Maskrom) is its primary recovery path, with an SD-card alternative in §6. The **Radxa Cubie A7Z (Allwinner A733)** board works differently enough (different SoC, and SD-card-only for now) to get its own section — see [§7](#7-radxa-cubie-a7z-allwinner-a733). Not sure which you have? The front-panel **Settings → Info** screen names the board.

---

## 1. Download the Image

Firmware builds and helper scripts are available through:

* **[https://www.usbridge.io/product/kvm-software](https://www.usbridge.io/product/kvm-software)** (Web portal downloads tab, with step-by-step instructions for Linux, macOS, and Windows)
* **[https://flash.usbridge.io/](https://flash.usbridge.io/)** (Direct file server listing)

The listing shows every retained version as `usbridge-rz3w-<version>.gptimg.zst`. Grab the newest one (or a specific version if you need to match a known-good build). The file is compressed with [Zstandard](https://facebook.github.io/zstd/).

> [!TIP]
> **`flash-tool/rz3w/flash-device-fast.sh` (the recommended Linux path, step 4) decompresses on the fly — you don't need to decompress anything by hand for it.** Only decompress yourself if you're using the Windows RKDevTool GUI or the plain manual `rkdeveloptool wl` path, both of which need a plain `.gptimg` on disk:
>
> | OS | Decompress command |
> | :--- | :--- |
> | **Linux** | `sudo apt install zstd` (or your distro's equivalent), then `zstd -d usbridge-rz3w-<version>.gptimg.zst` |
> | **macOS** | `brew install zstd`, then `zstd -d usbridge-rz3w-<version>.gptimg.zst` |
> | **Windows** | Install [7-Zip](https://www.7-zip.org/) (supports `.zst` out of the box) — right-click the file → **7-Zip → Extract Here** |
>
> This produces a `usbridge-rz3w-<version>.gptimg` file (several GB, raw disk image).

You'll also need, from the same listing:

* **`usbridge-rz3w-<version>.gptimg.bmap`** — same version as the image, downloaded as-is (not compressed). A small XML block map listing which parts of the `.gptimg` actually contain data — lets the fast Linux flashing path skip the image's mostly-empty regions instead of writing the whole multi-GB file byte for byte. Not needed for the Windows/RKDevTool or the plain `rkdeveloptool wl` path.
* **[rk356x_spl_loader_v1.23.114.bin](https://flash.usbridge.io/rk356x_spl_loader_v1.23.114.bin)** (481 KB, not compressed) — the RK3566 boot loader binary. Not the firmware itself, just a small program `rkdeveloptool` pushes into the chip's RAM first to initialize DDR before it can accept the actual image write. Required for the Linux CLI flow; RKDevTool on Windows handles the equivalent step internally with its own bundled loader. Also ships pre-included in the [`flash-tool/`](../../flash-tool/) directory of this repo.

---

## 2. Install a Rockchip Flashing Tool

The appliance's SoC (RK3566) is a Rockchip chip, flashed the same way any Rockchip board is: over USB, in "Maskrom/Loader" mode, using Rockchip's flashing protocol. Pick the tool for your OS:

**Linux — `rkdeveloptool` (command line)**

```bash
sudo apt install rkdeveloptool
sudo usermod -aG rkdeveloptool $USER
# log out and back in (or reboot) for the group change to take effect
```
The package ships its own udev rule, so no manual driver setup is needed.

**Windows — `RKDevTool` (official Rockchip GUI)**

1. Download the Rockchip **RKDevTool** package (search "RKDevTool" — it ships bundled with **DriverAssistant**, the Rockchip USB driver installer).
2. Run `DriverAssistant.exe` → **Install Driver** first. This installs the Rockchip USB driver Windows needs to recognize the device in Maskrom mode (it won't show up as a normal drive/COM port).
3. Run `RKDevTool.exe`. Once the device is in Maskrom mode and connected (step 3), it appears in the tool's device list with a status light.

**macOS — build `rkdeveloptool` from source**

There's no official Mac build; Homebrew doesn't package it either, so build it yourself:
```bash
brew install libusb autoconf automake libtool pkg-config zstd
git clone https://github.com/rockchip-linux/rkdeveloptool.git
cd rkdeveloptool
autoreconf -i
./configure CXXFLAGS="-g -O2 -Wno-error"
make
sudo make install
```

---

## 3. Enter Maskrom Mode

1. Disconnect the appliance from power.
2. Press and **hold the Maskrom button**.
3. While still holding it, connect power (USB-C).
4. Keep holding for about **5 seconds**, then release.

The device is now in Maskrom mode and enumerates over USB as a Rockchip loader device (not a normal drive) — this is what `rkdeveloptool`/RKDevTool detect.

---

## 4. Flash the Image

**Linux — recommended: step-by-step installation** (also covers steps 1 and 2 for you)

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
Writing only the blocks that actually contain data (confirmed live: a 14.4 GiB image drops to writing 828.5 MiB actually used). Full details: [`flash-tool/README.md`](../../flash-tool/).

> [!NOTE]
> **Running this from Windows?** See [5. Flashing from Windows via WSL](#5-flashing-from-windows-via-wsl) below — you can use these exact steps inside WSL, no separate Linux machine needed.

**Linux — manual: `flash-tool/rz3w/flash-device-fast.sh`** (if you'd rather download the files yourself and inspect the script first)

```bash
git clone https://github.com/USBridge-Technologies/USBridge-KVM-2.0.git
cd USBridge-KVM-2.0/flash-tool
# copy/move your downloaded usbridge-rz3w-<version>.gptimg.zst and matching
# .gptimg.bmap into this directory (the loader binary already ships here) --
# no need to decompress the .zst yourself, the script does it on the fly
./flash-device-fast.sh
```
Same underlying script the installer above uses. See [`flash-tool/README.md`](../../flash-tool/) for details.

**Linux — manual, plain `rkdeveloptool`** (no `.bmap` needed, but slower — writes the entire image including its empty space):
```bash
# 1. Push the loader into RAM (initializes DDR) -- the device is in
#    Maskrom mode right after step 3 and can't accept a write yet.
rkdeveloptool db rk356x_spl_loader_v1.23.114.bin

# 2. Wait a couple seconds for DDR init, then write the image.
sleep 2
rkdeveloptool wl 0 usbridge-rz3w-<version>.gptimg
```
`wl` (write LBA) writes the image starting at sector 0 — the `.gptimg` already contains the full partition table (boot, rootfs A/B, data), so this one command reflashes the whole eMMC. It'll print progress as it writes; this takes noticeably longer than the fast path above since it writes every byte, empty space included.

> [!TIP]
> If `rkdeveloptool` reports the device is already in **loader mode** (rather than maskrom) — e.g. you're retrying after a failed attempt without power-cycling — skip the `db` step and go straight to `wl`. `flash-device-fast.sh` handles this automatically either way.

**Windows (RKDevTool GUI):**
1. Confirm the device shows up in the tool's device panel (green/connected status).
2. Go to the **Upgrade Firmware** (or **Advanced**) tab.
3. Point it at the decompressed `.gptimg` file — RKDevTool will read the embedded partition table automatically.
4. Click **Upgrade** / **Run** and wait for it to report success.

When it finishes, disconnect and reconnect power normally (Maskrom mode only applies to that one session) — the device boots the freshly-flashed firmware from a clean eMMC.

> [!NOTE]
> A device flashed this way starts fresh, same as a brand-new unit: it boots into the [initial trial period](../8-maintenance-support/faq.md), and needs [network setup](../1-getting-started/initial-setup.md) again before it can check in for OTA updates or license activation.

---

## 5. Flashing from Windows via WSL

Yes — you can run the fast Linux path (`flash-tool/rz3w/flash-device-fast.sh`, step 4) from **WSL2** on Windows, without a separate Linux machine or a VM. The one thing WSL doesn't do automatically is USB passthrough — the Maskrom device needs to be explicitly attached to your WSL distro first, using Microsoft's official `usbipd-win` tool.

**One-time setup:**

1. If you don't already have WSL2 with a distro installed, open PowerShell as Administrator: `wsl --install` (installs Ubuntu by default). Reboot if prompted.
2. Install `usbipd-win` on Windows (still in an Administrator PowerShell): `winget install usbipd`
3. Inside your WSL distro, install the USB/IP client and the flashing tools:
   ```bash
   sudo apt update
   sudo apt install -y linux-tools-virtual hwdata rkdeveloptool zstd python3
   sudo update-alternatives --install /usr/local/bin/usbip usbip /usr/lib/linux-tools/*-generic/usbip 20
   ```
   (WSL2's kernel already has the USB/IP virtual host controller built in — this just installs the userspace `usbip` client binary that talks to it.)

**Every time you want to flash:**

1. Put the appliance into Maskrom mode (step 3) and connect it to a USB port on the Windows machine.
2. In an Administrator PowerShell:
   ```powershell
   usbipd list
   ```
   Find the Rockchip device in the list (vendor ID `2207`) and note its `BUSID` (e.g. `2-3`).
   ```powershell
   usbipd bind --busid=<BUSID>      # one-time per device/port, persists across reboots
   usbipd attach --wsl --busid=<BUSID>
   ```
3. Back in WSL, confirm it showed up: `lsusb` should now list a Rockchip device (`2207:350a`).
4. Run the step-by-step Linux installation (or `flash-device-fast.sh` manually) exactly as in the Linux instructions above (step 4) — from WSL's point of view this is a normal Linux USB device now, nothing else is different.

> [!NOTE]
> If the device isn't visible after `attach`, double check you ran `usbipd` from an **Administrator** PowerShell — both `bind` and `attach` need elevation. If you unplug and replug the device (e.g. between attempts), you'll need to `usbipd attach` again — Windows treats it as a new USB connection event.

---

## 6. Writing to an SD Card Instead

Everything above writes to the appliance's onboard eMMC over USB, in Maskrom mode. If you'd rather run the appliance off an SD card — no separate build, same `.gptimg` — there's a simpler path that skips USB/`rkdeveloptool`/Maskrom entirely: write the image directly onto the card from a reader on your computer.

**One command:**
```bash
USBRIDGE_SD_DEVICE=/dev/sdX curl -fsSL https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/flash-tool/rz3w/install.sh | bash
```
Same installer as step 4, just pointed at a target device instead of Maskrom mode — installs `zstd`/`python3` if missing, downloads `flash-tool/rz3w/flash-sd-card.sh` plus the latest firmware image and block map, and writes it. `USBRIDGE_VERSION=<version>` still works to pin a specific build. `rkdeveloptool` is not needed for this path at all.

**Step by step:**
```bash
curl -fsSL -O https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/flash-tool/rz3w/flash-sd-card.sh
chmod +x flash-sd-card.sh
VERSION=$(curl -fsSL https://flash.usbridge.io/latest-rz3w.txt)
curl -fsSL -O https://flash.usbridge.io/usbridge-rz3w-${VERSION}.gptimg.zst
curl -fsSL -O https://flash.usbridge.io/usbridge-rz3w-${VERSION}.gptimg.bmap
sudo ./flash-sd-card.sh /dev/sdX usbridge-rz3w-${VERSION}.gptimg.zst
```

Either way:
- **Find `/dev/sdX` first** with `lsblk` before running this — it wipes the target device entirely. On Linux the target is usually your SD card reader, not the appliance (the appliance isn't connected to your computer for this path at all).
- The script refuses to target the host's own system disk, and refuses any disk the kernel doesn't report as removable (protects against picking the wrong `/dev/sdX` by mistake) — pass `--force` (manual) or set `USBRIDGE_SD_FORCE=1` (one-liner) only if you're certain about the target and it's being wrongly refused.
- Once written, move the card to the appliance's SD slot and power on — no Maskrom step, no USB cable to the appliance needed.

**On a board that also has a real eMMC**, the firmware detects whichever device it actually booted from at runtime (both the U-Boot env/bootcount and the `/uboot` + `/data` mounts follow the real boot device), so running from SD works correctly even with an eMMC present alongside it. Once booted from the card, the on-device **Settings** menu gains an **Install to eMMC** action — copies the running system onto the eMMC and powers the appliance off; remove the SD card and power back on to boot from eMMC, no computer needed for that step. The same thing can be triggered unattended via `install_to_emmc` in a [provisioning config](../1-getting-started/headless-provisioning.md#install-to-emmc-install_to_emmc).

A card larger than the firmware's build baseline isn't wasted, either — the extra capacity automatically becomes usable `/mnt/emmc` storage on first boot, no manual resizing needed; see [Storage Security & Immutability §4](../4-snapshots-state-management/security-storage.md#4-onboard-storage-mntemmc--automatic-capacity-growth).

> [!WARNING]
> **Planning to reuse this SD card as a backup/snapshot card after moving to eMMC?** Don't just reinsert it and format it from the front panel — Install to eMMC clones it byte for byte, so it still contains a full copy of the OS. See [Storage Security & Immutability §5](../4-snapshots-state-management/security-storage.md#5-reusing-a-boot-sd-card-as-a-backup-card) for the safe way to repurpose it.

> [!NOTE]
> Same as an eMMC reflash: a device started this way boots into the initial trial period and needs [network setup](../1-getting-started/initial-setup.md) again.

---

## 7. Radxa Cubie A7Z (Allwinner A733)

This board is a different SoC family from the rest of this guide (Allwinner A733, not Rockchip RK3566) and currently only boots from an SD card — it ships with its eMMC controller disabled, so there's no Maskrom/`rkdeveloptool`-equivalent onboard-eMMC recovery path yet. Recovery is always the SD-card route, same underlying idea as [§6](#6-writing-to-an-sd-card-instead) above but its own tool (different board, different image naming) — see [`flash-tool/a7z/`](../../flash-tool/a7z/).

**One command:**
```bash
USBRIDGE_SD_DEVICE=/dev/sdX curl -fsSL https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/flash-tool/a7z/install.sh | bash
```
Installs `zstd`/`python3` if missing, downloads `flash-tool/a7z/flash-sd-card.sh` plus the latest A7Z firmware image and block map, and writes it. `USBRIDGE_SD_DEVICE` is required here (not optional like RZ3W) — there's no eMMC/USB fallback to default to. `USBRIDGE_VERSION=<version>` still works to pin a specific build.

**Step by step:**
```bash
curl -fsSL -O https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/flash-tool/a7z/flash-sd-card.sh
chmod +x flash-sd-card.sh
VERSION=$(curl -fsSL https://flash.usbridge.io/latest-a7z.txt)
curl -fsSL -O https://flash.usbridge.io/usbridge-a7z-${VERSION}.gptimg.zst
curl -fsSL -O https://flash.usbridge.io/usbridge-a7z-${VERSION}.gptimg.bmap
sudo ./flash-sd-card.sh /dev/sdX usbridge-a7z-${VERSION}.gptimg.zst
```

Either way:
- **Find `/dev/sdX` first** with `lsblk` before running this — it wipes the target device entirely. The target is your SD card reader, not the appliance (the appliance isn't connected to your computer for this path at all).
- The script refuses to target the host's own system disk, and refuses any disk the kernel doesn't report as removable — pass `--force` (manual) or set `USBRIDGE_SD_FORCE=1` (one-liner) only if you're certain about the target and it's being wrongly refused.
- Once written, move the card to the appliance's SD slot and power on.
- Unlike RZ3W, there's no **Install to eMMC** step to move to afterward — just leave the card in the appliance.

A card larger than the firmware's build baseline isn't wasted either — same automatic `/mnt/emmc` capacity growth on first boot as RZ3W; see [Storage Security & Immutability §4](../4-snapshots-state-management/security-storage.md#4-onboard-storage-mntemmc--automatic-capacity-growth).

> [!NOTE]
> A device flashed this way starts fresh, same as a brand-new unit: it boots into the [initial trial period](../8-maintenance-support/faq.md) and needs [network setup](../1-getting-started/initial-setup.md) again.
