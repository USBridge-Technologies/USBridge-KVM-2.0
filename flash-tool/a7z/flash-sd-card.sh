#!/usr/bin/env bash
# Write the USBridge-KVM firmware image directly onto an SD card via a host
# card reader, for the Radxa Cubie A7Z (Allwinner A733) board: insert the
# card into a reader on your computer, write it here, then put it in the
# appliance's SD slot and power on.
#
# This is currently the *only* way to flash this board -- it ships with its
# eMMC controller disabled in the device tree, so unlike RZ3W there's no
# USB/Maskrom-equivalent onboard-eMMC recovery path to fall back to yet.
#
# The boot loader (SPL/U-Boot/ATF) is baked into the .gptimg at fixed
# offsets that the A733 boot ROM reads directly off the SD card -- so a
# straight raw copy of the image onto the card carries the whole boot
# chain, no separate loader-upload step needed.
#
# Prerequisites: the firmware image, downloaded from
# https://flash.usbridge.io/ (matching versions):
#   - usbridge-a7z-<version>.gptimg.zst   (or an already-decompressed .gptimg)
#   - usbridge-a7z-<version>.gptimg.bmap
#
# Usage:
#   sudo ./flash-sd-card.sh /dev/sdX                       # looks for *.gptimg[.zst] next to this script
#   sudo ./flash-sd-card.sh /dev/sdX path/to/image.gptimg[.zst]
#   sudo ./flash-sd-card.sh -y /dev/sdX                     # skip the confirmation prompt
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'
info()    { echo -e "${CYAN}[INFO]${NC}  $*"; }
ok()      { echo -e "${GREEN}[ OK ]${NC}  $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
die()     { echo -e "${RED}[FAIL]${NC}  $*" >&2; exit 1; }
banner()  { echo -e "\n${BOLD}━━━  $*  ━━━${NC}\n"; }

banner "USBridge-KVM — SD Card Flash"

[[ "$EUID" -eq 0 ]] || die "Please run as root (sudo) -- direct block device access is required."

AUTO_YES=0
FORCE=0
while [[ "${1:-}" == "-y" || "${1:-}" == "--force" ]]; do
    [[ "$1" == "-y" ]] && AUTO_YES=1
    [[ "$1" == "--force" ]] && FORCE=1
    shift
done

DEVICE="${1:-}"
[[ -n "$DEVICE" ]] || die "Usage: $0 [-y] [--force] <device> [image.gptimg[.zst]]   (e.g. $0 /dev/sdX)\nWARNING: this will destroy all data on the target device!"
[[ -b "$DEVICE" ]] || die "Device $DEVICE is not a valid block device."

DEVICE_BASE="$(basename "$DEVICE")"
# Resolve to the *whole disk* backing $DEVICE (in case a partition like
# /dev/sdX1 was passed instead of the disk itself) so the checks below look
# at the actual physical device, not one of its partitions.
DISK_BASE="$(lsblk -no PKNAME "$DEVICE" 2>/dev/null | head -1)"
[[ -z "$DISK_BASE" ]] && DISK_BASE="$DEVICE_BASE"

# ── refuse to target the host's own system disk ─────────────────────────────
# Cheap but effective guard: resolve the disk backing the host's root mount
# and refuse if $DEVICE is that disk (or a partition of it). Catches the
# single most dangerous mistake (typing the wrong /dev/sdX) without needing
# to be exhaustive.
HOST_ROOT_DISK="$(lsblk -no PKNAME "$(findmnt -no SOURCE /)" 2>/dev/null || true)"
if [[ -n "$HOST_ROOT_DISK" && "$DISK_BASE" == "$HOST_ROOT_DISK" ]]; then
    die "Refusing to flash $DEVICE -- it looks like the host's own system disk (/dev/${HOST_ROOT_DISK})."
fi

# ── refuse non-removable media (internal SSD/NVMe/HDD) unless --force ──────
# "It's not the host root disk" is not the same as "it's safe" -- a second
# internal drive, an internal NVMe data disk, etc. would pass that check too.
# Require the kernel to report the disk as removable (true for SD card
# readers and USB mass storage) before proceeding without --force.
REMOVABLE="$(cat "/sys/block/${DISK_BASE}/removable" 2>/dev/null || echo 0)"
TRANSPORT="$(lsblk -dno TRAN "/dev/${DISK_BASE}" 2>/dev/null || true)"
if [[ "$REMOVABLE" != "1" && "$TRANSPORT" != "usb" && "$TRANSPORT" != "mmc" ]]; then
    if [[ "$FORCE" -eq 1 ]]; then
        warn "/dev/${DISK_BASE} is not reported as removable (transport: '${TRANSPORT:-unknown}') -- proceeding anyway due to --force."
    else
        die "/dev/${DISK_BASE} does not look like a removable SD card / USB reader (kernel 'removable' flag: ${REMOVABLE}, transport: '${TRANSPORT:-unknown}').\nThis usually means it's an internal disk (SSD/NVMe/HDD) -- refusing to avoid wiping it.\nIf you're sure this really is your SD card reader, re-run with --force."
    fi
fi

find_image() {
    if [[ $# -gt 0 && -f "$1" ]]; then
        readlink -f "$1"
        return
    fi
    local img
    # Prefer an already-decompressed image if one is sitting there, else
    # fall back to the compressed download (flashed via the on-the-fly path).
    img="$(find "${SCRIPT_DIR}" -maxdepth 1 -iname '*.gptimg' | head -n1)"
    if [[ -z "${img}" ]]; then
        img="$(find "${SCRIPT_DIR}" -maxdepth 1 -iname '*.gptimg.zst' | head -n1)"
    fi
    if [[ -z "${img}" ]]; then
        die "No .gptimg or .gptimg.zst found next to this script and none passed as an argument.\nDownload one from https://flash.usbridge.io/, see the Firmware Update Guide."
    fi
    readlink -f "${img}"
}

IMAGE="$(find_image "${2:-}")"
BMAP="${IMAGE%.zst}.bmap"

if [[ "$IMAGE" == *.zst ]]; then
    command -v zstd >/dev/null 2>&1 || die "zstd not found (needed to decompress ${IMAGE} on the fly). Install it: sudo apt install zstd"
fi

if [[ ! -f "$BMAP" ]]; then
    die "BMAP file not found: $BMAP\nDownload usbridge-a7z-<version>.gptimg.bmap from https://flash.usbridge.io/ (same version as the image, uncompressed) and put it next to the image with the exact same base name."
fi

info "Device : $DEVICE"
info "Image  : $(basename "$IMAGE")"
info "BMAP   : $(basename "$BMAP")"

IMAGE_SIZE_BYTES="$(grep -oE '<ImageSize>[[:space:]]*[0-9]+' "$BMAP" | grep -oE '[0-9]+' || true)"
[[ -n "$IMAGE_SIZE_BYTES" ]] || die "Could not read <ImageSize> from BMAP."

DEVICE_SIZE_BYTES="$(blockdev --getsize64 "$DEVICE" 2>/dev/null || true)"
[[ -n "$DEVICE_SIZE_BYTES" ]] || die "Could not read size of $DEVICE via blockdev."

info "Target : $(( DEVICE_SIZE_BYTES / 1024 / 1024 )) MiB — image: $(( IMAGE_SIZE_BYTES / 1024 / 1024 )) MiB"
if (( DEVICE_SIZE_BYTES < IMAGE_SIZE_BYTES )); then
    die "Target card ($(( DEVICE_SIZE_BYTES / 1024 / 1024 )) MiB) is smaller than the image ($(( IMAGE_SIZE_BYTES / 1024 / 1024 )) MiB)."
fi

echo ""
warn "ALL DATA on $DEVICE will be permanently destroyed!"
if [[ "$AUTO_YES" -eq 1 ]]; then
    info "Auto-confirming due to -y flag."
else
    read -r -p "Type 'yes' to continue: " CONFIRM
    [[ "$CONFIRM" == "yes" || "$CONFIRM" == "y" ]] || { info "Cancelled."; exit 0; }
fi

info "Unmounting any mounted partitions on $DEVICE..."
umount "${DEVICE}"* 2>/dev/null || true

banner "Writing image (sparse -- only mapped blocks)"
[[ "$IMAGE" == *.zst ]] && info "Decompressing on the fly -- no temporary decompressed .gptimg is written to disk."

export IMAGE BMAP DEVICE
python3 - << 'EOF'
import xml.etree.ElementTree as ET
import sys, os, subprocess

img_path = os.environ['IMAGE']
bmap_path = os.environ['BMAP']
device = os.environ['DEVICE']
is_zst = img_path.endswith('.zst')

tree = ET.parse(bmap_path)
root = tree.getroot()
block_size = int(root.find('BlockSize').text.strip())
ranges = []
for r in root.find('BlockMap').findall('Range'):
    parts = r.text.strip().split('-')
    start = int(parts[0])
    end = int(parts[1]) if len(parts) > 1 else start
    ranges.append((start, end))
ranges.sort()

print(f"Found {len(ranges)} mapped regions in BMAP. Writing only these blocks to {device}...")

CHUNK = 16 * 1024 * 1024
total_size_mb = 0

zst_proc = None
stream = None
f_img = None
pos = 0

if is_zst:
    zst_proc = subprocess.Popen(['zstd', '-d', '-c', '-q', img_path], stdout=subprocess.PIPE)
    stream = zst_proc.stdout
else:
    f_img = open(img_path, 'rb')

f_dev = open(device, 'r+b')

def skip_forward(n):
    remaining = n
    while remaining > 0:
        chunk = stream.read(min(remaining, CHUNK))
        if not chunk:
            raise EOFError("unexpected end of decompressed stream while skipping ahead")
        remaining -= len(chunk)

def copy_n(n):
    remaining = n
    while remaining > 0:
        to_read = min(remaining, CHUNK)
        chunk = stream.read(to_read) if is_zst else f_img.read(to_read)
        if not chunk:
            raise EOFError("unexpected end of image data")
        f_dev.write(chunk)
        remaining -= len(chunk)

for i, (start, end) in enumerate(ranges):
    num_blocks = end - start + 1
    byte_start = start * block_size
    length = num_blocks * block_size
    size_mb = length / (1024 * 1024)
    total_size_mb += size_mb

    print(f"[{i+1}/{len(ranges)}] Writing {size_mb:.1f} MiB at offset {byte_start}...")

    if is_zst:
        gap = byte_start - pos
        if gap < 0:
            print("\n[FAIL] BMAP ranges are out of order -- can't seek backward while streaming through zstd.")
            sys.exit(1)
        if gap:
            skip_forward(gap)
    else:
        f_img.seek(byte_start)

    f_dev.seek(byte_start)
    try:
        copy_n(length)
    except Exception as e:
        print(f"\n[FAIL] Failed during chunk write: {e}")
        sys.exit(1)
    pos = byte_start + length

f_dev.flush()
os.fsync(f_dev.fileno())
f_dev.close()

if is_zst:
    stream.close()
    zst_proc.wait()
else:
    f_img.close()

print(f"\n[ OK ] Wrote a total of {total_size_mb:.1f} MiB (skipping empty space).")
EOF

banner "Finishing up"
sync
blockdev --flushbufs "$DEVICE" 2>/dev/null || true

EJECTED=0
if command -v udisksctl &>/dev/null && udisksctl power-off -b "$DEVICE" 2>/dev/null; then
    EJECTED=1
elif command -v eject &>/dev/null && eject "$DEVICE" 2>/dev/null; then
    EJECTED=1
fi

ok "Flash complete."
if [[ "$EJECTED" -eq 1 ]]; then
    info "Card powered off -- safe to remove."
else
    info "Could not auto-eject $DEVICE; safe to remove now regardless (all writes are synced)."
fi

echo ""
echo -e "  ${CYAN}Notes:${NC}"
echo "  • This card boots and runs standalone -- the boot loader (SPL/U-Boot/"
echo "    ATF) is baked into the gptimg at fixed offsets the A733 boot ROM"
echo "    reads directly off the card."
echo "  • This board currently only boots from SD (its eMMC controller ships"
echo "    disabled) -- there's no \"Install to eMMC\" step to move to afterward,"
echo "    unlike RZ3W. Just leave the card in the appliance."
echo ""
