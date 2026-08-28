#!/usr/bin/env bash
# One-shot recovery-flash installer for USBridge-KVM 2.0 (Radxa Zero 3W /
# RK3566). Downloads everything needed -- flash-device-fast.sh, the boot
# loader, and the latest firmware image + block map -- installs
# rkdeveloptool if it's missing (Debian/Ubuntu), and runs the flash.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/flash-tool/install.sh | bash
#
# Env overrides:
#   USBRIDGE_VERSION=1.2.59   pin a specific firmware version instead of latest
#   USBRIDGE_WORKDIR=/path    where to download files (default: ~/.usbridge-flash-tool)
#   USBRIDGE_NO_PROMPT=1      skip the "press Enter once in Maskrom mode" pause
#
# See the full guide for what this is and when to use it:
#   https://github.com/USBridge-Technologies/USBridge-KVM-2.0/blob/main/docs/content/9-updates-changelog/firmware-update-guide.md
set -euo pipefail

REPO_RAW_BASE="https://raw.githubusercontent.com/USBridge-Technologies/USBridge-KVM-2.0/main/flash-tool"
OTA_BASE="https://ota.usbridge.io/flash-images"
WORKDIR="${USBRIDGE_WORKDIR:-${HOME}/.usbridge-flash-tool}"

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
command -v rkdeveloptool >/dev/null 2>&1 || NEED_PKGS+=(rkdeveloptool)
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
ok "Prerequisites present: rkdeveloptool, zstd, python3."

if ! id -nG 2>/dev/null | grep -qw "rkdeveloptool" && ! id -nG 2>/dev/null | grep -qw "root"; then
    warn "Your user isn't in the 'rkdeveloptool' group yet (needs a re-login to take effect)."
    info "Running the actual flash step with sudo instead, so you don't have to log out and back in first."
    USE_SUDO=1
else
    USE_SUDO=0
fi

# ── download the flashing tool itself ────────────────────────────────────
info "Fetching flash-device-fast.sh and the boot loader..."
curl -fsSL -o flash-device-fast.sh "${REPO_RAW_BASE}/flash-device-fast.sh"
curl -fsSL -o rk356x_spl_loader_v1.23.114.bin "${REPO_RAW_BASE}/rk356x_spl_loader_v1.23.114.bin"
chmod +x flash-device-fast.sh

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
pause_for_tty "Put the appliance into Maskrom mode now (hold the Maskrom button, apply power, hold ~5s, release)."

if [[ "${USE_SUDO}" == "1" ]]; then
    sudo bash "${WORKDIR}/flash-device-fast.sh" "${WORKDIR}/${IMAGE}"
else
    bash "${WORKDIR}/flash-device-fast.sh" "${WORKDIR}/${IMAGE}"
fi
