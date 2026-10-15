#!/usr/bin/env bash
set -Eeuo pipefail
STATE="$HOME/.local/state/hyprkylian"
[[ -f "$STATE/latest-backup" ]] || { echo "Sauvegarde introuvable"; exit 1; }
BACKUP="$(cat "$STATE/latest-backup")"
[[ -f "$BACKUP/hyprland.lua" ]] || exit 1
read -r -p "Restaurer la configuration depuis $BACKUP ? [o/N] " ok
[[ "$ok" == o || "$ok" == O || "$ok" == oui ]] || exit 1
cp -a "$BACKUP/hyprland.lua" "$HOME/.config/hypr/hyprland.lua"
if [[ -f "$BACKUP/kitty-absent" ]]; then rm -f "$HOME/.config/kitty/kitty.conf"; else cp -a "$BACKUP/kitty.conf" "$HOME/.config/kitty/kitty.conf"; fi
pkill -x waybar 2>/dev/null || true
rm -rf "$HOME/.config/hyprkylian"
if [[ -d "$BACKUP/previous-target" ]]; then cp -a "$BACKUP/previous-target" "$HOME/.config/hyprkylian"; fi
echo "Restauration terminee. Redemarre la session."
