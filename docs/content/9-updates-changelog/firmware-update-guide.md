# Firmware Update Guide

USBridge-KVM 2.0 updates itself over the network using a dual-partition (A/B) OTA mechanism — there's no manual flashing or physical media swap required for a routine update.

---

## 1. Checking for and Applying an Update

From the front panel: **Settings → Updates**.

| Button | Action |
| :--- | :--- |
| **[1] / OK** | Check for an update. The screen shows live status: `Downloading...` → `Installing...` → result. |
| **[2]** | Commit the currently-running update. |

The screen also shows the appliance's current firmware version and its [license/trial status](../8-maintenance-support/faq.md).

> [!TIP]
> **Check right after first connecting to the network.** Run a manual **Check for update** here as a standard step of first-time setup (see [Quick Start Guide](../1-getting-started/quick-start.md)), not only when you suspect you're out of date.

> [!NOTE]
> The appliance has no battery-backed clock, so a **Check for update** run in the first minute or two after connecting to the network can fail with an error — it's waiting on an NTP time sync that hasn't finished yet, not an actual update failure. Give it a minute and try again if the very first check right after connecting errors out.

> [!IMPORTANT]
> **Why the separate Commit step matters.** An update installs to a second, inactive partition and boots into it — but it isn't made permanent until you explicitly **Commit** it. This is a safety net: if the new firmware fails to boot or misbehaves, the device can fall back to the previous, known-good partition instead of being stuck on a bad update. Don't skip the Commit step once you've confirmed the device is working normally on the new version.

---

## 2. What Happens During an Update

1. The appliance checks in and downloads the new firmware if one is available.
2. It's written to the inactive partition — the currently-running system keeps operating normally throughout.
3. The device reboots into the new partition.
4. You verify the device is healthy, then **Commit** from the Updates screen to make the switch permanent.

Updates are cryptographically verified before being applied; a corrupted or unsigned update is rejected.

---

## 3. Licensing & Updates Are Independent

See [FAQ](../8-maintenance-support/faq.md) for how the trial/license works. The two are separate: a device still in trial (or locked) can check for and apply firmware updates same as a licensed one, and applying an update doesn't by itself change license state.

---

## 4. Full Reflash from Scratch (eMMC, via USB)

This is a **different procedure from the OTA update above** — use it only when the device won't boot at all, has no working OTA path yet (never connected to a network), or you specifically need to wipe and reinstall the eMMC from a blank state. A healthy device should always use the OTA flow in section 1 instead; it's faster, doesn't need a cable to a PC, and doesn't risk interrupting a working unit.

### 4.1 Download the Image

Every firmware build is published at:

**[https://ota.usbridge.io/flash-images/](https://ota.usbridge.io/flash-images/)**

The listing shows every retained version as `usbridge-rz3w-<version>.gptimg.zst`. Grab the newest one (or a specific version if you need to match a known-good build). The file is compressed with [Zstandard](https://facebook.github.io/zstd/).

> [!TIP]
> **`flash-tool/flash-device-fast.sh` (the recommended Linux path, step 4.4) decompresses on the fly — you don't need to decompress anything by hand for it.** Only decompress yourself if you're using the Windows RKDevTool GUI or the plain manual `rkdeveloptool wl` path, both of which need a plain `.gptimg` on disk:
>
> | OS | Decompress command |
> | :--- | :--- |
> | **Linux** | `sudo apt install zstd` (or your distro's equivalent), then `zstd -d usbridge-rz3w-<version>.gptimg.zst` |
> | **macOS** | `brew install zstd`, then `zstd -d usbridge-rz3w-<version>.gptimg.zst` |
> | **Windows** | Install [7-Zip](https://www.7-zip.org/) (supports `.zst` out of the box) — right-click the file → **7-Zip → Extract Here** |
>
> This produces a `usbridge-rz3w-<version>.gptimg` file (several GB, raw disk image).

You'll also need, from the same listing:

* **`usbridge-rz3w-<version>.gptimg.bmap`** — same version as the image, downloaded as-is (not compressed). A small XML block map listing which parts of the `.gptimg` actually contain data — lets the fast Linux flashing path (step 4.4) skip the image's mostly-empty regions instead of writing the whole multi-GB file byte for byte. Not needed for the Windows/RKDevTool or the plain `rkdeveloptool wl` path.
* **[rk356x_spl_loader_v1.23.114.bin](https://ota.usbridge.io/flash-images/rk356x_spl_loader_v1.23.114.bin)** (481 KB, not compressed) — the RK3566 boot loader binary. Not the firmware itself, just a small program `rkdeveloptool` pushes into the chip's RAM first to initialize DDR before it can accept the actual image write. Required for the Linux CLI flow; RKDevTool on Windows handles the equivalent step internally with its own bundled loader. Also ships pre-included in the [`flash-tool/`](https://github.com/USBridge-Technologies/USBridge-KVM-2.0/tree/main/flash-tool) directory of this repo.

### 4.2 Install a Rockchip Flashing Tool

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
3. Run `RKDevTool.exe`. Once the device is in Maskrom mode and connected (step 4.3), it appears in the tool's device list with a status light.

**macOS — build `rkdeveloptool` from source**

There's no official Mac build; Homebrew doesn't package it either, so build it yourself:
```bash
brew install libusb autoconf automake libtool pkg-config
git clone https://github.com/rockchip-linux/rkdeveloptool.git
cd rkdeveloptool
autoreconf -i
./configure
make
sudo make install
```

### 4.3 Enter Maskrom Mode

1. Disconnect the appliance from power.
2. Press and **hold the Maskrom button**.
3. While still holding it, connect power (USB-C).
4. Keep holding for about **5 seconds**, then release.

The device is now in Maskrom mode and enumerates over USB as a Rockchip loader device (not a normal drive) — this is what `rkdeveloptool`/RKDevTool detect.

### 4.4 Flash the Image

**Linux — recommended: one-liner installer** (also covers steps 4.1 and 4.2 for you)

```bash
curl -fsSL https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/flash-tool/install.sh | bash
```
Installs `rkdeveloptool`/`zstd`/`python3` if missing (Debian/Ubuntu via `apt`), downloads the flashing script + boot loader + the **latest** firmware image and block map, prompts you to enter Maskrom mode (step 4.3), and flashes — writing only the blocks that actually contain data (confirmed live: a 14.4 GiB image drops to writing 828.5 MiB actually used). `USBRIDGE_VERSION=<version>` pins a specific build instead of latest. Full details: [`flash-tool/README.md`](https://github.com/USBridge-Technologies/USBridge-KVM-2.0/tree/main/flash-tool).

> [!NOTE]
> **Running this from Windows?** See [4.5 Flashing from Windows via WSL](#45-flashing-from-windows-via-wsl) below — you can use this exact one-liner from inside WSL, no separate Linux machine needed.

**Linux — manual: `flash-tool/flash-device-fast.sh`** (if you'd rather download the files yourself and inspect the script first)

```bash
git clone https://github.com/USBridge-Technologies/USBridge-KVM-2.0.git
cd USBridge-KVM-2.0/flash-tool
# copy/move your downloaded usbridge-rz3w-<version>.gptimg.zst and matching
# .gptimg.bmap into this directory (the loader binary already ships here) --
# no need to decompress the .zst yourself, the script does it on the fly
./flash-device-fast.sh
```
Same underlying script the installer above uses. See [`flash-tool/README.md`](https://github.com/USBridge-Technologies/USBridge-KVM-2.0/tree/main/flash-tool) for details.

**Linux — manual, plain `rkdeveloptool`** (no `.bmap` needed, but slower — writes the entire image including its empty space):
```bash
# 1. Push the loader into RAM (initializes DDR) -- the device is in
#    Maskrom mode right after step 4.3 and can't accept a write yet.
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

### 4.5 Flashing from Windows via WSL

Yes — you can run the fast Linux path (`flash-tool/flash-device-fast.sh`, step 4.4) from **WSL2** on Windows, without a separate Linux machine or a VM. The one thing WSL doesn't do automatically is USB passthrough — the Maskrom device needs to be explicitly attached to your WSL distro first, using Microsoft's official `usbipd-win` tool.

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

1. Put the appliance into Maskrom mode (step 4.3) and connect it to a USB port on the Windows machine.
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
4. Run the one-liner installer (or `flash-device-fast.sh` manually) exactly as in the Linux instructions above (step 4.4) — from WSL's point of view this is a normal Linux USB device now, nothing else is different.

> [!NOTE]
> If the device isn't visible after `attach`, double check you ran `usbipd` from an **Administrator** PowerShell — both `bind` and `attach` need elevation. If you unplug and replug the device (e.g. between attempts), you'll need to `usbipd attach` again — Windows treats it as a new USB connection event.

---

### 4.6 Writing to an SD Card Instead

Everything above writes to the appliance's onboard eMMC over USB, in Maskrom mode. If you'd rather run the appliance off an SD card — no separate build, same `.gptimg` — there's a simpler path that skips USB/`rkdeveloptool`/Maskrom entirely: write the image directly onto the card from a reader on your computer.

**One-liner:**
```bash
USBRIDGE_SD_DEVICE=/dev/sdX curl -fsSL https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/flash-tool/install.sh | bash
```
Same installer as step 4.4, just pointed at a target device instead of Maskrom mode — installs `zstd`/`python3` if missing, downloads `flash-tool/flash-sd-card.sh` plus the latest firmware image and block map, and writes it. `USBRIDGE_VERSION=<version>` still works to pin a specific build. `rkdeveloptool` is not needed for this path at all.

**Manual:**
```bash
git clone https://github.com/USBridge-Technologies/USBridge-KVM-2.0.git
cd USBridge-KVM-2.0/flash-tool
# copy/move your downloaded usbridge-rz3w-<version>.gptimg.zst and matching
# .gptimg.bmap into this directory
sudo ./flash-sd-card.sh /dev/sdX
```

Either way:
- **Find `/dev/sdX` first** with `lsblk` before running this — it wipes the target device entirely. On Linux the target is usually your SD card reader, not the appliance (the appliance isn't connected to your computer for this path at all).
- The script refuses to target the host's own system disk, and refuses any disk the kernel doesn't report as removable (protects against picking the wrong `/dev/sdX` by mistake) — pass `--force` (manual) or set `USBRIDGE_SD_FORCE=1` (one-liner) only if you're certain about the target and it's being wrongly refused.
- Once written, move the card to the appliance's SD slot and power on — no Maskrom step, no USB cable to the appliance needed.

**On a board that also has a real eMMC**, the firmware detects whichever device it actually booted from at runtime (both the U-Boot env/bootcount and the `/uboot` + `/data` mounts follow the real boot device), so running from SD works correctly even with an eMMC present alongside it. Once booted from the card, the on-device **Settings** menu gains an **Install to eMMC** action — copies the running system onto the eMMC and powers the appliance off; remove the SD card and power back on to boot from eMMC, no computer needed for that step. The same thing can be triggered unattended via `install_to_emmc` in a [provisioning config](../1-getting-started/headless-provisioning.md#install-to-emmc-install_to_emmc).

> [!NOTE]
> Same as an eMMC reflash: a device started this way boots into the initial trial period and needs [network setup](../1-getting-started/initial-setup.md) again.
