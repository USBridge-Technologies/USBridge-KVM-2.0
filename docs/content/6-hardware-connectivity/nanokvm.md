# Sipeed NanoKVM

USBridge firmware also runs on the **Sipeed NanoKVM**, an off-the-shelf HDMI KVM built on the **SOPHGO SG2002** (one RISC-V C906 core at 1 GHz, 256 MB of RAM, of which Linux gets about 158 MB — the rest is reserved for video capture and encoding). It replaces Sipeed's own software on the NanoKVM's microSD card and turns the device into a USBridge appliance: same client apps, same API, same OTA updates as the Radxa-based units.

---

## 1. What Works

| Feature | On the NanoKVM |
| :--- | :--- |
| **Moonlight streaming** | Yes — the SG2002's hardware H.264 encoder, up to 1080p60 from the NanoKVM's HDMI input. The client's Net Graph shows the encoder as *NanoKVM (SG2002)*. |
| **Keyboard, mouse, absolute pointer, touch/pen** | Yes (USB HID gadget). |
| **Gamepad** | Yes (XInput, see [Gamepad Emulation](../2-kvm-vkm/gamepad.md)). |
| **Audio** | Yes — the target PC's sound through a USB audio (UAC1) device, plus the client's microphone and MIDI input into the target. |
| **Virtual media** | Yes — ISO, `.qcow2`, `.vdi`/`.vmdk` and whole drives streamed from the client over NBD, local images from the onboard storage, and MTP. See [§4](#4-virtual-media-and-the-ram-cache) for the RAM cache. |
| **Backup storage & snapshots** | Yes — btrfs on the rest of the microSD card, automatic read-only snapshots, same as [Snapshots & States](../4-snapshots-state-management/snapshots-overview.md). |
| **First-time setup** | Over the USB cable: plug the NanoKVM into your computer and click **Over USB** in the client (or open `http://10.55.0.1`) — see [Initial Setup §A](../1-getting-started/initial-setup.md#a-no-screen-needed-over-the-usb-cable). For many units: `usbridge_provision.json` on the card's **BOOT** partition, see [§3](#3-headless-setup-usbridge_provisionjson). |
| **OTA updates** | Yes — A/B updates from the USBridge update server, with automatic rollback, same as the [Firmware Update Guide](../9-updates-changelog/firmware-update-guide.md). |
| **Front-panel display & menu** | No — the NanoKVM's own small OLED isn't driven by this firmware; the device runs headless (network by DHCP, or set by provisioning; pairing over the USB cable). The menu's settings — network, updates, event log — are in the client: **gear menu → KVM settings**. |
| **Power & performance** | No — the SG2002's kernel has no CPU frequency scaling, and the one clock control it has is unreliable, so the CPU always runs at its stock 850 MHz. |
| **BIOS-in-Terminal (SSH KVM)** | Not on this board. |
| **ATX power control** | Not yet. |
| **Install to eMMC** | No — the NanoKVM has no eMMC; it always runs from its microSD card. |

Networking is the NanoKVM's wired Ethernet (`eth0`): DHCP by default, or a static address — from the provisioning file, or from the client (**gear menu → KVM settings → Ethernet**).

---

## 2. Flashing and the Card Layout

The NanoKVM boots only from its microSD card. To install USBridge (or to recover a unit that doesn't boot), take the card out, write the image onto it from a card reader on your computer, and put it back — see the [Recovery Flashing Guide §8](../9-updates-changelog/recovery-flashing-guide.md#8-sipeed-nanokvm-sophgo-sg2002) and [`flash-tool/nanokvm/`](../../../flash-tool/nanokvm/). Images are on [flash.usbridge.io](https://flash.usbridge.io/) as `usbridge-nanokvm-<version>.gptimg.zst` (+ `.gptimg.bmap`).

Any card of 2 GB or more works; 32 GB or more is a sensible size, since everything beyond the system partitions becomes backup storage.

| Partition | Size | Mounted at | What it holds |
| :--- | :--- | :--- | :--- |
| p1, FAT32, label **BOOT** | 32 MB | `/uboot` | The boot loader (`fip.bin`) — and the place for `usbridge_provision.json`. The only partition Windows/macOS can read. |
| p2 / p3, ext4 | ~440 MB each | `/` | System A / B (OTA updates write the inactive one). |
| p4 | — | — | Extended partition holding p5 and p6. |
| p5, ext4, label `data` | 128 MB | `/data` | Settings, license state, pairing keys — kept across updates. |
| p6, btrfs, label `EMMC` | the rest of the card | `/mnt/emmc` | Backup storage: `iso/`, `data/` and `backup/` (snapshots). Grows to the end of the card on first boot. |

> [!NOTE]
> Cards flashed with firmware **0.1.9 or older** have a different layout (no `EMMC` partition; `/data` is the whole card). They keep receiving OTA updates, with the backup storage placed on `/data` — plenty of room, but no btrfs snapshots. Reflash the card (backing up anything you need first) to get the snapshot-capable layout.

---

## 3. Headless Setup (`usbridge_provision.json`)

For a single NanoKVM the easiest way in is **over its USB cable** — no file to prepare: see [Initial Setup §A](../1-getting-started/initial-setup.md#a-no-screen-needed-over-the-usb-cable). A provisioning file is for setting up many units, or setting the network before first boot.

Everything in [Headless & Bulk Provisioning](../1-getting-started/headless-provisioning.md) applies, with one difference: the NanoKVM has no USB port for a separate flash drive, so the file goes **onto the NanoKVM's own microSD card, into the root of its BOOT partition** — see [the provisioning guide's NanoKVM section](../1-getting-started/headless-provisioning.md#sipeed-nanokvm-the-boot-partition-of-its-microsd-card) for the step-by-step, including what to do when Windows doesn't give the partition a drive letter.

Fields that don't apply on the NanoKVM: `wlan0` interfaces (wired Ethernet only), `users` (no SSH logins in release firmware), `sshkvm_enabled` and `install_to_emmc`.

---

## 4. Virtual Media and the RAM Cache

Drives streamed from the client sit behind the same [RAM cache](../5-remote-disk-image-mounting/mounting-iso-images.md#2-ram-cache-on-streamed-sources) as on the other boards, scaled to the NanoKVM's memory: the first **8 MB** of the image (boot sectors, El Torito, boot loaders) are held in RAM from the moment the drive is attached, and a **hot-block cache of about 26 MB** (a sixth of the RAM, instead of 1 GB on boards with 1 GB or more) keeps the most re-read blocks local. That's what keeps installers (Windows Setup included) from stalling on network round-trips while they boot; bulk reads of a large image still run at the speed of the network link.

The NanoKVM's USB port is USB 2.0 (High Speed), so virtual drives top out at USB 2.0 speeds regardless of the source.

---

## 5. Memory at a Glance

With a stream running, the system uses roughly 50–60 MB of the ~158 MB Linux has (streamer ~21 MB, USBridge service ~19 MB, update client ~23 MB); about 100 MB stays available, of which the virtual-media cache takes up to ~40 MB while a streamed drive is attached.
