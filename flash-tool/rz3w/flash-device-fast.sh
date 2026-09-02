#!/usr/bin/env bash
# Fast full-eMMC reflash for USBridge-KVM (Radxa Zero 3W / RK3566), using
# rkdeveloptool + a .bmap block map to skip the image's mostly-empty
# regions -- writes only the actually-used blocks instead of the whole
# multi-GB image byte for byte, which is what makes this "fast" versus a
# plain `rkdeveloptool wl 0 <image>`.
#
# Accepts either a decompressed .gptimg OR a .gptimg.zst directly -- for
# the latter, decompression happens on the fly through a zstd pipe, so
# there's no need to `zstd -d` a multi-GB file to disk first just to flash
# it (saves both the wait and the disk space). This only works because
# bmap ranges are sorted, non-overlapping, forward-only offsets.
#
# See the Firmware Update Guide for the full walkthrough (entering Maskrom
# mode, installing rkdeveloptool, WSL notes for Windows, etc.):
#   docs/content/9-updates-changelog/firmware-update-guide.md
#
# Prerequisites, downloaded from https://flash.usbridge.io/ and
# matching the SAME version:
#   - usbridge-rz3w-<version>.gptimg.zst    (or decompress it yourself first
#                                             with `zstd -d` -- either works)
#   - usbridge-rz3w-<version>.gptimg.bmap   (downloaded as-is, not compressed)
#   - rk356x_spl_loader_v1.23.114.bin       (ships alongside this script --
#                                             re-download only if this repo's
#                                             copy goes stale)
#
# Usage:
#   ./flash-device-fast.sh                            # looks for a *.gptimg[.zst] next to this script
#   ./flash-device-fast.sh path/to/image.gptimg        # explicit path, already decompressed
#   ./flash-device-fast.sh path/to/image.gptimg.zst    # explicit path, decompressed on the fly
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOADER="${SCRIPT_DIR}/rk356x_spl_loader_v1.23.114.bin"

VID=0x2207
PID_MASKROM=0x350a
PID_LOADER=0x350c

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'
info()    { echo -e "${CYAN}[INFO]${NC}  $*"; }
ok()      { echo -e "${GREEN}[ OK ]${NC}  $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
die()     { echo -e "${RED}[FAIL]${NC}  $*" >&2; exit 1; }
banner()  { echo -e "\n${BOLD}━━━  $*  ━━━${NC}\n"; }

check_tools() {
    command -v rkdeveloptool >/dev/null 2>&1 || \
        die "rkdeveloptool not found. Linux: sudo apt install rkdeveloptool\nSee the Firmware Update Guide for macOS/Windows/WSL."
    command -v python3 >/dev/null 2>&1 || \
        die "python3 not found (needed to read the .bmap file and write chunks)."
    if ! id -nG 2>/dev/null | grep -qw "rkdeveloptool" && ! id -nG 2>/dev/null | grep -qw "root"; then
        echo -e "${YELLOW}"
        echo "  Your user is not in the 'rkdeveloptool' group."
        echo "  Run the following ONE TIME, then log out and back in:"
        echo ""
        echo "      sudo usermod -aG rkdeveloptool \$USER"
        echo -e "${NC}"
        exit 1
    fi
}

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

detect_device() {
    local ld_out
    ld_out="$(rkdeveloptool ld 2>&1)" || true
    if echo "$ld_out" | grep -q "Vid=${VID},Pid=${PID_MASKROM}"; then
        echo "maskrom"
    elif echo "$ld_out" | grep -q "Vid=${VID},Pid=${PID_LOADER}"; then
        echo "loader"
    elif echo "$ld_out" | grep -q "${VID}"; then
        echo "loader"
    else
        echo "none"
    fi
}

wait_for_device() {
    local target="$1"
    local timeout=60
    local elapsed=0
    while true; do
        state="$(detect_device)"
        if [[ "$target" == "any" && "$state" != "none" ]]; then return 0; fi
        if [[ "$target" == "$state" ]]; then return 0; fi
        if ((elapsed >= timeout)); then return 1; fi
        sleep 1
        ((elapsed++))
    done
}

banner "USBridge RZ3W — Fast BMAP Flash"

check_tools

IMAGE="$(find_image "$@")"
# The .bmap always matches the *decompressed* image's name -- for a .zst
# input, that's the image path with the .zst suffix stripped, plus .bmap
# (e.g. foo.gptimg.zst -> foo.gptimg.bmap). For an already-decompressed
# .gptimg, stripping ".zst" is a no-op, so this is just IMAGE + ".bmap".
BMAP="${IMAGE%.zst}.bmap"

if [[ "$IMAGE" == *.zst ]]; then
    command -v zstd >/dev/null 2>&1 || die "zstd not found (needed to decompress ${IMAGE} on the fly). Install it: sudo apt install zstd"
fi

if [[ ! -f "$BMAP" ]]; then
    die "BMAP file not found: $BMAP\nDownload usbridge-rz3w-<version>.gptimg.bmap from https://flash.usbridge.io/ (same version as the image, uncompressed) and put it next to the image with the exact same base name."
fi

info "Image : $(basename "$IMAGE")"
info "BMAP  : $(basename "$BMAP")"

[[ -f "$LOADER" ]] || die "Loader binary not found: ${LOADER}\nIt should have shipped alongside this script in flash-tool/."

banner "Step 1 — Connect device"
info "Device must already be in Maskrom mode -- see the Firmware Update Guide if you haven't done that yet (hold the Maskrom button, apply power, hold ~5s, release)."
STATE="$(detect_device)"
if [[ "$STATE" == "none" ]]; then
    info "Waiting for Rockchip device (timeout 60 s)..."
    wait_for_device "any" || die "Device did not appear."
    STATE="$(detect_device)"
fi

if [[ "$STATE" == "maskrom" ]]; then
    ok "Device found in MASKROM mode."
elif [[ "$STATE" == "loader" ]]; then
    ok "Device found in LOADER mode."
else
    die "Unexpected device state: ${STATE}"
fi

if [[ "$STATE" == "maskrom" ]]; then
    banner "Step 2 — Download boot loader"
    info "Sending loader to device RAM..."
    rkdeveloptool db "$LOADER" >/dev/null || die "Failed to download loader."
    ok "Loader sent. Waiting for DDR init..."
    sleep 2
else
    banner "Step 2 — (skipped, already in loader mode)"
fi

banner "Step 3 — Fast Write using BMAP"
[[ "$IMAGE" == *.zst ]] && info "Decompressing on the fly -- no temporary decompressed .gptimg is written to disk."

export IMAGE BMAP
python3 - << 'EOF'
import xml.etree.ElementTree as ET
import sys, os, subprocess, tempfile

img_path = os.environ['IMAGE']
bmap_path = os.environ['BMAP']
is_zst = img_path.endswith('.zst')

try:
    tree = ET.parse(bmap_path)
except Exception as e:
    print(f"Failed to parse bmap: {e}")
    sys.exit(1)

root = tree.getroot()
block_size = int(root.find('BlockSize').text.strip())
ranges = []
for r in root.find('BlockMap').findall('Range'):
    parts = r.text.strip().split('-')
    start = int(parts[0])
    end = int(parts[1]) if len(parts) > 1 else start
    ranges.append((start, end))
# bmaptool always emits ranges sorted and non-overlapping -- sort defensively
# anyway since the streaming-zst path below can only read forward.
ranges.sort()

print(f"Found {len(ranges)} mapped regions in BMAP. Flashing only these blocks...")

total_size_mb = 0
CHUNK = 16 * 1024 * 1024

zst_proc = None
stream = None
f_img = None
pos = 0

if is_zst:
    zst_proc = subprocess.Popen(['zstd', '-d', '-c', '-q', img_path], stdout=subprocess.PIPE)
    stream = zst_proc.stdout
else:
    f_img = open(img_path, 'rb')

def skip_forward(n):
    """Discard n bytes from the sequential zstd stream."""
    remaining = n
    while remaining > 0:
        chunk = stream.read(min(remaining, CHUNK))
        if not chunk:
            raise EOFError("unexpected end of decompressed stream while skipping ahead")
        remaining -= len(chunk)

def read_into(f_out, n):
    """Read exactly n bytes (from the seekable file or the zst stream) into f_out."""
    remaining = n
    while remaining > 0:
        to_read = min(remaining, CHUNK)
        chunk = stream.read(to_read) if is_zst else f_img.read(to_read)
        if not chunk:
            raise EOFError("unexpected end of image data")
        f_out.write(chunk)
        remaining -= len(chunk)

for i, (start, end) in enumerate(ranges):
    num_blocks = end - start + 1
    byte_start = start * block_size
    lba = byte_start // 512
    length = num_blocks * block_size
    size_mb = length / (1024 * 1024)
    total_size_mb += size_mb

    print(f"[{i+1}/{len(ranges)}] Writing {size_mb:.1f} MiB at LBA {lba}...")

    if is_zst:
        gap = byte_start - pos
        if gap < 0:
            print("\n[FAIL] BMAP ranges are out of order -- can't seek backward while streaming through zstd.")
            sys.exit(1)
        if gap:
            skip_forward(gap)
    else:
        f_img.seek(byte_start)

    fd, tmp_path = tempfile.mkstemp(suffix='.bin')
    try:
        with os.fdopen(fd, 'wb') as f_tmp:
            read_into(f_tmp, length)
        pos = byte_start + length
        subprocess.run(['rkdeveloptool', 'wl', str(lba), tmp_path], check=True, stdout=subprocess.DEVNULL)
    except Exception as e:
        print(f"\n[FAIL] Failed during chunk write: {e}")
        if os.path.exists(tmp_path):
            os.remove(tmp_path)
        sys.exit(1)

    os.remove(tmp_path)

if is_zst:
    stream.close()
    zst_proc.wait()
else:
    f_img.close()

print(f"\n[ OK ] Wrote a total of {total_size_mb:.1f} MiB (skipping empty space).")
EOF

banner "Step 4 — Reboot"
info "Rebooting device..."
rkdeveloptool rd >/dev/null 2>&1 || warn "Reboot command failed (device may have rebooted)."
ok "Done!"
