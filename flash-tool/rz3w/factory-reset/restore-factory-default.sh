#!/usr/bin/env bash
# Wipes a Radxa Zero 3W (RK3566) eMMC back to its factory-blank state: no OS,
# no data -- just the Rockchip idblock/preloader region and an empty GPT
# partition table. This is what a brand-new, never-flashed board looks like,
# and it's what makes the board fall through to booting from an SD card
# instead of the (now-empty) onboard eMMC.
#
# This is NOT a firmware reinstall -- it does not write any OS/rootfs image.
# For a full USBridge-KVM firmware install, use ../flash-device-fast.sh
# instead (see ../README.md).
#
# What gets written, both captured once via `rkdeveloptool read` from a known
# factory-blank unit:
#   emmc-head-16MiB.img.zst   -- LBA 0-32767 (MBR + primary GPT + idblock/
#                                 preloader region), zstd-compressed
#   emmc-tail-33sectors.img   -- LBA 30535647-30535679 (last 33 sectors,
#                                 where a backup GPT would normally live;
#                                 tiny, kept uncompressed)
#
# Prerequisites: rkdeveloptool, zstd, pkexec (or run this whole script as
# root). The loader binary (rk356x_spl_loader_v1.23.114.bin) is expected one
# directory up, alongside flash-device-fast.sh.
#
# Usage:
#   1. Put the device in Maskrom mode (hold Maskrom button, connect USB-C,
#      release after ~5s).
#   2. ./restore-factory-default.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOADER="${SCRIPT_DIR}/../rk356x_spl_loader_v1.23.114.bin"
HEAD_ZST="${SCRIPT_DIR}/emmc-head-16MiB.img.zst"
TAIL_IMG="${SCRIPT_DIR}/emmc-tail-33sectors.img"

# Sector geometry this dump was captured from (14910 MB / 30535680 sectors
# SAMSUNG eMMC). The tail dump's start LBA -- last 33 sectors of that exact
# device size. If a board reports a different total sector count via
# `rkdeveloptool read-flash-info`, do NOT write the tail blindly; the script
# checks this below and skips the tail write if the size doesn't match.
EXPECTED_SECTORS=30535680
TAIL_START_LBA=30535647

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'
info()    { echo -e "${CYAN}[INFO]${NC}  $*"; }
ok()      { echo -e "${GREEN}[ OK ]${NC}  $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
die()     { echo -e "${RED}[FAIL]${NC}  $*" >&2; exit 1; }
banner()  { echo -e "\n${BOLD}━━━  $*  ━━━${NC}\n"; }

command -v rkdeveloptool >/dev/null 2>&1 || die "rkdeveloptool not found. sudo apt install rkdeveloptool"
command -v zstd >/dev/null 2>&1 || die "zstd not found. sudo apt install zstd"
[[ -f "$LOADER" ]] || die "Loader binary not found: ${LOADER}"
[[ -f "$HEAD_ZST" ]] || die "Missing ${HEAD_ZST}"
[[ -f "$TAIL_IMG" ]] || die "Missing ${TAIL_IMG}"

# pkexec if available and not already root, else run rkdeveloptool directly
# (works if the user is in the 'rkdeveloptool' udev group).
RK="rkdeveloptool"
if [[ "$(id -u)" -ne 0 ]] && command -v pkexec >/dev/null 2>&1; then
    RK="pkexec rkdeveloptool"
fi

banner "Step 1 — Connect device"
info "Device must already be in Maskrom mode."
LD_OUT="$($RK ld 2>&1)" || die "No Rockchip device detected. Is it in Maskrom mode and connected?"
echo "$LD_OUT" | grep -q "Maskrom\|Loader" || die "Unexpected device state:\n$LD_OUT"
ok "Device detected."

banner "Step 2 — Download boot loader"
$RK db "$LOADER" >/dev/null || die "Failed to download loader."
sleep 2
ok "Loader sent."

banner "Step 3 — Verify eMMC size"
FLASH_INFO="$($RK read-flash-info 2>&1)" || die "Failed to read flash info."
echo "$FLASH_INFO"
ACTUAL_SECTORS="$(echo "$FLASH_INFO" | grep -oP '\d+(?= Sectors)')"
WRITE_TAIL=1
if [[ "$ACTUAL_SECTORS" != "$EXPECTED_SECTORS" ]]; then
    warn "This device reports ${ACTUAL_SECTORS} sectors, dump was captured from a ${EXPECTED_SECTORS}-sector device."
    warn "Skipping the tail write (backup GPT area) to avoid writing to the wrong offset on a differently-sized chip."
    WRITE_TAIL=0
fi

banner "Step 4 — Write head region (idblock + primary GPT)"
TMP_HEAD="$(mktemp --suffix=.img)"
trap 'rm -f "$TMP_HEAD"' EXIT
zstd -d -f -q -o "$TMP_HEAD" "$HEAD_ZST"
$RK wl 0 "$TMP_HEAD" || die "Failed to write head region."
ok "Head region written."

if [[ "$WRITE_TAIL" -eq 1 ]]; then
    banner "Step 5 — Write tail region"
    $RK wl "$TAIL_START_LBA" "$TAIL_IMG" || die "Failed to write tail region."
    ok "Tail region written."
else
    banner "Step 5 — (skipped)"
fi

banner "Step 6 — Reboot"
$RK reset >/dev/null 2>&1 || warn "Reset command failed (device may have rebooted anyway)."
ok "Done. eMMC is back to factory-blank (no OS, empty GPT) -- device should now boot from SD."
