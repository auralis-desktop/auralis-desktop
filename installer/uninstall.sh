#!/usr/bin/env bash
# Auralis uninstaller -- removes config files, preserves backups

set -euo pipefail

HYPR_DIR="$HOME/.config/hypr"
QS_DIR="$HOME/.config/quickshell/auralis"

echo "This will remove:"
echo "  $HYPR_DIR"
echo "  $QS_DIR"
echo ""
read -rp "Continue? [y/N] " reply
[[ "${reply}" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

rm -rf "$HYPR_DIR"
rm -rf "$QS_DIR"

echo "Auralis configuration removed."
echo "Your backups are in ~/.auralis-backup/"
echo "To restore: cp -ra ~/.auralis-backup/<timestamp>/. ~/"
