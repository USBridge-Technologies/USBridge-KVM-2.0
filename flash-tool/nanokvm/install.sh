#!/usr/bin/env bash
# One-shot recovery-flash installer for USBridge-KVM 2.0 on the Sipeed
# NanoKVM (SOPHGO SG2002). Downloads flash-sd-card.sh plus the latest
# firmware image + block map, and runs the flash.
#
# microSD card only: the NanoKVM boots from its card (no eMMC, no USB
# recovery mode like RZ3W's Maskrom/rkdeveloptool flow) --
# USBRIDGE_SD_DEVICE is required, not optional, here.
#
# For the other boards see ../rz3w/install.sh and ../a7z/install.sh.
#
# Usage:
#   USBRIDGE_SD_DEVICE=/dev/sdX curl -fsSL https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/flash-tool/nanokvm/install.sh | bash
#
# Env overrides:
#   USBRIDGE_SD_DEVICE=/dev/sdX  (required) card/reader to write to
#   USBRIDGE_VERSION=0.1.9      pin a specific firmware version instead of latest
#   USBRIDGE_WORKDIR=/path      where to download files (default: ~/.usbridge-flash-tool)
#   USBRIDGE_SD_FORCE=1         pass --force to flash-sd-card.sh (skip the "looks removable?" guard)
#
# See the full guide for what this is and when to use it:
#   https://github.com/USBridge-Technologies/USBridge-KVM-2.0/blob/main/docs/content/9-updates-changelog/firmware-update-guide.md
set -euo pipefail

REPO_RAW_BASE="https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/flash-tool/nanokvm"
OTA_BASE="https://flash.usbridge.io"
WORKDIR="${USBRIDGE_WORKDIR:-${HOME}/.usbridge-flash-tool}"
SD_DEVICE="${USBRIDGE_SD_DEVICE:-}"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'
info()    { echo -e "${CYAN}[INFO]${NC}  $*"; }
ok()      { echo -e "${GREEN}[ OK ]${NC}  $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
die()     { echo -e "${RED}[FAIL]${NC}  $*" >&2; exit 1; }
banner()  { echo -e "\n${BOLD}━━━  $*  ━━━${NC}\n"; }

banner "USBridge-KVM Recovery Flash Installer -- Sipeed NanoKVM"

if [[ "$(uname -s)" != "Linux" ]]; then
    die "This installer is for Linux (including WSL on Windows). See the Firmware Update Guide for native macOS/Windows instructions."
fi

[[ -n "${SD_DEVICE}" ]] || die "USBRIDGE_SD_DEVICE is required for this board (e.g. USBRIDGE_SD_DEVICE=/dev/sdX ...) -- the NanoKVM boots from its microSD card only. Find yours with 'lsblk' first."

mkdir -p "${WORKDIR}"
cd "${WORKDIR}"
info "Working directory: ${WORKDIR}"

# ── install prerequisites ────────────────────────────────────────────────
NEED_PKGS=()
command -v zstd >/dev/null 2>&1 || NEED_PKGS+=(zstd)
command -v python3 >/dev/null 2>&1 || NEED_PKGS+=(python3)

if ((${#NEED_PKGS[@]} > 0)); then
    if command -v apt-get >/dev/null 2>&1; then
        info "Installing missing prerequisites: ${NEED_PKGS[*]}"
        sudo apt-get update -qq
        sudo apt-get install -y "${NEED_PKGS[@]}"
    else
        die "Missing: ${NEED_PKGS[*]}. This installer only auto-installs on Debian/Ubuntu (apt) -- install these yourself and re-run."
    fi
fi
ok "Prerequisites present."

# ── download the flashing tool itself ────────────────────────────────────
info "Fetching flash-sd-card.sh..."
curl -fsSL -o flash-sd-card.sh "${REPO_RAW_BASE}/flash-sd-card.sh"
chmod +x flash-sd-card.sh

# ── figure out which firmware version to flash ───────────────────────────
VERSION="${USBRIDGE_VERSION:-}"
if [[ -z "${VERSION}" ]]; then
    VERSION="$(curl -fsSL "${OTA_BASE}/latest-nanokvm.txt")"
    [[ -n "${VERSION}" ]] || die "Could not determine the latest firmware version from ${OTA_BASE}/latest-nanokvm.txt"
fi
info "Firmware version: ${VERSION}"

IMAGE="usbridge-nanokvm-${VERSION}.gptimg.zst"
BMAP="usbridge-nanokvm-${VERSION}.gptimg.bmap"

for f in "${IMAGE}" "${BMAP}"; do
    if [[ -f "${f}" ]]; then
        info "${f} already downloaded, skipping."
    else
        info "Downloading ${f}..."
        curl -fsSL -o "${f}" "${OTA_BASE}/${f}"
    fi
done
ok "Firmware ${VERSION} ready in ${WORKDIR}."

# ── flash ─────────────────────────────────────────────────────────────────
banner "Ready to flash"
echo "  Image:   ${WORKDIR}/${IMAGE}"
echo "  Version: ${VERSION}"
echo "  Target:  ${SD_DEVICE} (SD card, via host card reader)"
echo ""

SD_ARGS=("${SD_DEVICE}" "${WORKDIR}/${IMAGE}")
[[ "${USBRIDGE_SD_FORCE:-0}" != "0" ]] && SD_ARGS=(--force "${SD_ARGS[@]}")
# flash-sd-card.sh needs direct block-device access.
sudo bash "${WORKDIR}/flash-sd-card.sh" "${SD_ARGS[@]}"
