#!/usr/bin/env bash
# One-shot recovery-flash installer for USBridge-KVM 2.0 (Radxa Zero 3W /
# RK3566). Downloads everything needed -- the flashing script(s), the boot
# loader, and the latest firmware image + block map -- installs
# rkdeveloptool if it's missing (Debian/Ubuntu), and runs the flash.
#
# By default this flashes the onboard eMMC over USB (Maskrom mode). Pass
# USBRIDGE_SD_DEVICE to instead write the image straight onto an SD card via
# a host card reader (no USB/Maskrom involved) -- see flash-sd-card.sh.
#
# For the other supported board (Radxa Cubie A7Z / Allwinner A733), see
# ../a7z/install.sh instead -- different SoC, different tooling, kept as its
# own self-contained subdirectory rather than one script branching on board.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/flash-tool/rz3w/install.sh | bash
#
#   # write to an SD card instead of the onboard eMMC over USB
#   USBRIDGE_SD_DEVICE=/dev/sdX curl -fsSL .../install.sh | bash
#
# Env overrides:
#   USBRIDGE_VERSION=1.2.59    pin a specific firmware version instead of latest
#   USBRIDGE_WORKDIR=/path     where to download files (default: ~/.usbridge-flash-tool)
#   USBRIDGE_NO_PROMPT=1       skip the "press Enter once in Maskrom mode" pause (eMMC mode only)
#   USBRIDGE_SD_DEVICE=/dev/sdX  write to this SD card/reader instead of flashing eMMC over USB
#   USBRIDGE_SD_FORCE=1        pass --force to flash-sd-card.sh (skip the "looks removable?" guard)
#
# See the full guide for what this is and when to use it:
#   https://github.com/USBridge-Technologies/USBridge-KVM-2.0/blob/main/docs/content/9-updates-changelog/firmware-update-guide.md
set -euo pipefail

REPO_RAW_BASE="https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/flash-tool/rz3w"
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

# This script is normally run via `curl | bash`, which means its own stdin
# is the script body, not the terminal -- any `read` that needs real user
# input has to come from /dev/tty explicitly, not the default stdin.
pause_for_tty() {
    if [[ "${USBRIDGE_NO_PROMPT:-0}" != "0" ]]; then
        return
    fi
    if [[ -r /dev/tty ]]; then
        read -r -p "$1 Press Enter to continue... " _ < /dev/tty
    else
        warn "No TTY available to prompt on -- continuing immediately. Make sure the device is already in Maskrom mode."
        sleep 2
    fi
}

banner "USBridge-KVM Recovery Flash Installer"

if [[ "$(uname -s)" != "Linux" ]]; then
    die "This installer is for Linux (including WSL on Windows). See the Firmware Update Guide for native macOS/Windows instructions."
fi

mkdir -p "${WORKDIR}"
cd "${WORKDIR}"
info "Working directory: ${WORKDIR}"

# ── install prerequisites ────────────────────────────────────────────────
NEED_PKGS=()
if [[ -z "${SD_DEVICE}" ]]; then
    command -v rkdeveloptool >/dev/null 2>&1 || NEED_PKGS+=(rkdeveloptool)
fi
command -v zstd >/dev/null 2>&1 || NEED_PKGS+=(zstd)
command -v python3 >/dev/null 2>&1 || NEED_PKGS+=(python3)

if ((${#NEED_PKGS[@]} > 0)); then
    if command -v apt-get >/dev/null 2>&1; then
        info "Installing missing prerequisites: ${NEED_PKGS[*]}"
        sudo apt-get update -qq
        sudo apt-get install -y "${NEED_PKGS[@]}"
    else
        die "Missing: ${NEED_PKGS[*]}. This installer only auto-installs on Debian/Ubuntu (apt) -- install these yourself and re-run. See the Firmware Update Guide for other distros."
    fi
fi
ok "Prerequisites present."

if [[ -z "${SD_DEVICE}" ]] && ! id -nG 2>/dev/null | grep -qw "rkdeveloptool" && ! id -nG 2>/dev/null | grep -qw "root"; then
    warn "Your user isn't in the 'rkdeveloptool' group yet (needs a re-login to take effect)."
    info "Running the actual flash step with sudo instead, so you don't have to log out and back in first."
    USE_SUDO=1
else
    USE_SUDO=0
fi

# ── download the flashing tool itself ────────────────────────────────────
if [[ -n "${SD_DEVICE}" ]]; then
    info "Fetching flash-sd-card.sh..."
    curl -fsSL -o flash-sd-card.sh "${REPO_RAW_BASE}/flash-sd-card.sh"
    chmod +x flash-sd-card.sh
else
    info "Fetching flash-device-fast.sh and the boot loader..."
    curl -fsSL -o flash-device-fast.sh "${REPO_RAW_BASE}/flash-device-fast.sh"
    curl -fsSL -o rk356x_spl_loader_v1.23.114.bin "${REPO_RAW_BASE}/rk356x_spl_loader_v1.23.114.bin"
    chmod +x flash-device-fast.sh
fi

# ── figure out which firmware version to flash ───────────────────────────
VERSION="${USBRIDGE_VERSION:-}"
if [[ -z "${VERSION}" ]]; then
    VERSION="$(curl -fsSL "${OTA_BASE}/latest-rz3w.txt")"
    [[ -n "${VERSION}" ]] || die "Could not determine the latest firmware version from ${OTA_BASE}/latest-rz3w.txt"
fi
info "Firmware version: ${VERSION}"

IMAGE="usbridge-rz3w-${VERSION}.gptimg.zst"
BMAP="usbridge-rz3w-${VERSION}.gptimg.bmap"

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
echo ""

if [[ -n "${SD_DEVICE}" ]]; then
    echo "  Target:  ${SD_DEVICE} (SD card, via host card reader)"
    echo ""
    SD_ARGS=("${SD_DEVICE}" "${WORKDIR}/${IMAGE}")
    [[ "${USBRIDGE_SD_FORCE:-0}" != "0" ]] && SD_ARGS=(--force "${SD_ARGS[@]}")
    # flash-sd-card.sh needs direct block-device access -- always run it via
    # sudo regardless of USE_SUDO (that flag is about the rkdeveloptool
    # group, irrelevant here).
    sudo bash "${WORKDIR}/flash-sd-card.sh" "${SD_ARGS[@]}"
else
    pause_for_tty "Put the appliance into Maskrom mode now (hold the Maskrom button, apply power, hold ~5s, release)."
    if [[ "${USE_SUDO}" == "1" ]]; then
        sudo bash "${WORKDIR}/flash-device-fast.sh" "${WORKDIR}/${IMAGE}"
    else
        bash "${WORKDIR}/flash-device-fast.sh" "${WORKDIR}/${IMAGE}"
    fi
fi
