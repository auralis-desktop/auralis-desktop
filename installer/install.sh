#!/usr/bin/env bash
# ╭──────────────────────────────────────────────────────────────────────────╮
# │                                                                          │
# │              ✦  A U R A L I S  ✦                                        │
# │         Material Design 3 Desktop Experience                             │
# │                  v1.0.0                                                  │
# │                                                                          │
# ╰──────────────────────────────────────────────────────────────────────────╯
#
# Usage:
#   ./install.sh          Interactive install
#   ./install.sh --auto   Unattended (no prompts)
#   ./install.sh --help   Show help

set -euo pipefail

# ── Constants ────────────────────────────────────────────────────────────────
AURALIS_VERSION="1.0.0"
AURALIS_REPO="https://github.com/auralis-desktop/auralis-desktop"
AURALIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.auralis-backup/$(date +%Y%m%d_%H%M%S)"
CONFIG_DIR="$HOME/.config"
HYPR_DIR="$CONFIG_DIR/hypr"
QS_DIR="$CONFIG_DIR/quickshell/auralis"
LOG_FILE="/tmp/auralis-install-$$.log"

AUTO_MODE=0
UNINSTALL=0
for arg in "$@"; do
    case "$arg" in
        --auto)       AUTO_MODE=1 ;;
        --uninstall)  UNINSTALL=1 ;;
        --help|-h)    _usage; exit 0 ;;
    esac
done

# ── ANSI colors ──────────────────────────────────────────────────────────────
if [ -t 1 ] && command -v tput &>/dev/null && [ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]; then
    R='\033[0;31m'  G='\033[0;32m'  Y='\033[0;33m'
    B='\033[0;34m'  M='\033[0;35m'  C='\033[0;36m'
    W='\033[0;37m'  BOLD='\033[1m'  DIM='\033[2m'
    RESET='\033[0m'
else
    R='' G='' Y='' B='' M='' C='' W='' BOLD='' DIM='' RESET=''
fi

# ── Helpers ──────────────────────────────────────────────────────────────────
_banner() {
    echo -e "${M}${BOLD}"
    echo "  ╭──────────────────────────────────────────────╮"
    echo "  │                                              │"
    echo "  │         ✦  A U R A L I S  v${AURALIS_VERSION}  ✦        │"
    echo "  │    A desktop that feels alive.               │"
    echo "  │                                              │"
    echo "  ╰──────────────────────────────────────────────╯"
    echo -e "${RESET}"
}

_step()    { echo -e "${B}${BOLD}[${1}/${TOTAL_STEPS}]${RESET} ${BOLD}${2}${RESET}"; }
_ok()      { echo -e "  ${G}✓${RESET}  ${1}"; }
_warn()    { echo -e "  ${Y}⚠${RESET}  ${1}"; }
_err()     { echo -e "  ${R}✗${RESET}  ${1}" >&2; }
_info()    { echo -e "  ${C}·${RESET}  ${1}"; }
_section() { echo -e "\n${BOLD}${W}── ${1} ──${RESET}"; }

_confirm() {
    [ "$AUTO_MODE" -eq 1 ] && return 0
    echo -en "  ${Y}?${RESET}  ${1} [Y/n] "
    read -r reply
    [[ "${reply:-Y}" =~ ^[Yy]$ ]]
}

_usage() {
    echo "Usage: ./install.sh [--auto] [--uninstall] [--help]"
    echo "  --auto       Non-interactive mode"
    echo "  --uninstall  Remove Auralis configurations"
    echo "  --help       Show this message"
}

TOTAL_STEPS=6

# ── Step 1: System checks ────────────────────────────────────────────────────
_step 1 "Checking system"

# Distro detection
if [ -f /etc/arch-release ]; then
    DISTRO="arch"
    _ok "Arch Linux detected"
elif [ -f /etc/os-release ]; then
    . /etc/os-release
    _warn "Distribution: ${PRETTY_NAME:-Unknown}. This installer is optimised for Arch."
    DISTRO="unknown"
else
    _err "Cannot detect distribution"
    DISTRO="unknown"
fi

# Architecture
ARCH="$(uname -m)"
if [ "$ARCH" != "x86_64" ] && [ "$ARCH" != "aarch64" ]; then
    _warn "Untested architecture: ${ARCH}"
fi
_ok "Architecture: ${ARCH}"

# Check for pacman
if ! command -v pacman &>/dev/null; then
    _err "pacman not found. This installer supports Arch-based systems."
    exit 1
fi

# Detect AUR helper
AUR_HELPER=""
for h in paru yay; do
    if command -v "$h" &>/dev/null; then
        AUR_HELPER="$h"
        _ok "AUR helper: ${h}"
        break
    fi
done
if [ -z "$AUR_HELPER" ]; then
    _warn "No AUR helper found (paru/yay). AUR packages will be skipped."
fi

# Check Hyprland
HYPR_VERSION=""
if command -v hyprctl &>/dev/null; then
    HYPR_VERSION="$(hyprctl version 2>/dev/null | head -1 | grep -oP 'v[\d.]+')"
    _ok "Hyprland ${HYPR_VERSION} found"
else
    _warn "Hyprland not found -- will install"
fi

# Check Quickshell
QS_VERSION=""
if command -v qs &>/dev/null; then
    QS_VERSION="$(qs --version 2>/dev/null | head -1)"
    _ok "Quickshell found: ${QS_VERSION}"
else
    _warn "Quickshell not found -- will install (AUR)"
fi

# ── Step 2: Package installation ─────────────────────────────────────────────
_step 2 "Installing dependencies"

PKGLIST="$AURALIS_DIR/installer/packages/arch.txt"
OFFICIAL_PKGS=()
AUR_PKGS=()
SKIP_PKGS=()

while IFS= read -r line; do
    line="${line%%#*}"        # strip inline comments
    line="${line//[$'\t' ]}"  # strip whitespace
    [ -z "$line" ] && continue

    pkg="${line%% *}"
    meta="${line#* }"

    is_aur=0
    is_optional=0
    [[ "$meta" == *"aur"*      ]] && is_aur=1
    [[ "$meta" == *"optional"* ]] && is_optional=1

    # Check if already installed
    if pacman -Q "$pkg" &>/dev/null; then
        SKIP_PKGS+=("$pkg")
        continue
    fi

    if [ "$is_aur" -eq 1 ]; then
        AUR_PKGS+=("$pkg")
    else
        OFFICIAL_PKGS+=("$pkg")
    fi
done < "$PKGLIST"

# Show summary
_section "Package summary"
[ "${#SKIP_PKGS[@]}"    -gt 0 ] && _ok  "Already installed: ${#SKIP_PKGS[@]} packages"
[ "${#OFFICIAL_PKGS[@]}" -gt 0 ] && _info "To install (pacman): ${OFFICIAL_PKGS[*]}"
[ "${#AUR_PKGS[@]}"     -gt 0 ] && _info "To install (AUR):    ${AUR_PKGS[*]}"

if [ "${#OFFICIAL_PKGS[@]}" -gt 0 ]; then
    _confirm "Install ${#OFFICIAL_PKGS[@]} official packages?" || true
    sudo pacman -S --needed --noconfirm "${OFFICIAL_PKGS[@]}" 2>>"$LOG_FILE" \
        && _ok "Official packages installed" \
        || { _err "pacman failed -- see ${LOG_FILE}"; exit 1; }
fi

if [ "${#AUR_PKGS[@]}" -gt 0 ]; then
    if [ -n "$AUR_HELPER" ]; then
        _confirm "Install ${#AUR_PKGS[@]} AUR packages with ${AUR_HELPER}?" || true
        "$AUR_HELPER" -S --needed --noconfirm "${AUR_PKGS[@]}" 2>>"$LOG_FILE" \
            && _ok "AUR packages installed" \
            || _warn "Some AUR packages failed -- see ${LOG_FILE}"
    else
        _warn "AUR packages skipped (no helper): ${AUR_PKGS[*]}"
    fi
fi

# ── Step 3: Backup existing configurations ───────────────────────────────────
_step 3 "Backing up existing configurations"

_backup_if_exists() {
    local src="$1"
    if [ -e "$src" ]; then
        local dest="$BACKUP_DIR$(dirname "${src#$HOME}")"
        mkdir -p "$dest"
        cp -ra "$src" "$dest/"
        _ok "Backed up: ${src} → ${BACKUP_DIR}"
    fi
}

mkdir -p "$BACKUP_DIR"
_backup_if_exists "$HYPR_DIR"
_backup_if_exists "$QS_DIR"
_ok "Backup stored at: ${BACKUP_DIR}"

# ── Step 4: Install Hyprland dotfiles ────────────────────────────────────────
_step 4 "Installing Hyprland dotfiles"

mkdir -p "$HYPR_DIR/config"
mkdir -p "$HYPR_DIR/wallpapers"
mkdir -p "$HYPR_DIR/shaders"

_install_file() {
    local src="$1"
    local dst="$2"
    mkdir -p "$(dirname "$dst")"
    cp -f "$src" "$dst"
    _ok "Installed: ${dst#$HOME/}"
}

_install_file "$AURALIS_DIR/hyprland/hyprland.lua" "$HYPR_DIR/hyprland.lua"
for f in "$AURALIS_DIR/hyprland/config/"*.lua; do
    _install_file "$f" "$HYPR_DIR/config/$(basename "$f")"
done

# ── Step 5: Install Quickshell shell ─────────────────────────────────────────
_step 5 "Installing Auralis Shell (Quickshell)"

mkdir -p "$QS_DIR"
mkdir -p "$QS_DIR/config"

# Copy shell files
cp -ra "$AURALIS_DIR/shell/." "$QS_DIR/"
_ok "Shell files installed to ${QS_DIR#$HOME/}"

# Create default settings.json if not present
SETTINGS_FILE="$QS_DIR/config/settings.json"
if [ ! -f "$SETTINGS_FILE" ]; then
    cp "$AURALIS_DIR/shell/config/settings.json" "$SETTINGS_FILE"
    _ok "Default settings installed"
fi

# Create wallpapers dir
mkdir -p "$HOME/Pictures/Wallpapers"
mkdir -p "$HOME/Pictures/Screenshots"

# ── Step 6: Final checks ─────────────────────────────────────────────────────
_step 6 "Final system checks"

_check() {
    local name="$1"
    local cmd="$2"
    if eval "$cmd" &>/dev/null; then
        _ok "${name}"
    else
        _warn "${name} check failed"
    fi
}

_check "Hyprland"            "command -v hyprctl"
_check "Quickshell"          "command -v qs"
_check "PipeWire"            "command -v wpctl"
_check "NetworkManager"      "command -v nmcli"
_check "brightnessctl"       "command -v brightnessctl"
_check "playerctl"           "command -v playerctl"
_check "swww"                "command -v swww"
_check "Hyprland config"     "test -f $HYPR_DIR/hyprland.lua"
_check "Quickshell config"   "test -f $QS_DIR/Main.qml"

# ── Done ─────────────────────────────────────────────────────────────────────
echo -e "\n${G}${BOLD}╭──────────────────────────────────────────────────────╮${RESET}"
echo -e "${G}${BOLD}│  ✦  Auralis installed successfully!                  │${RESET}"
echo -e "${G}${BOLD}╰──────────────────────────────────────────────────────╯${RESET}\n"

echo -e "${BOLD}Next steps:${RESET}"
echo -e "  1. Log out of your current session"
echo -e "  2. Select ${BOLD}Hyprland${RESET} at your display manager login screen"
echo -e "     OR run: ${C}${BOLD}Hyprland${RESET}"
echo -e "  3. Auralis Shell starts automatically"
echo -e "  4. Press ${BOLD}SUPER + Space${RESET} to open the launcher"
echo -e "  5. Press ${BOLD}SUPER + S${RESET} to open settings"
echo -e "  6. Press ${BOLD}SUPER + SHIFT + Q${RESET} for the power menu\n"

echo -e "  Backup: ${DIM}${BACKUP_DIR}${RESET}"
echo -e "  Docs:   ${DIM}${AURALIS_REPO}${RESET}\n"
