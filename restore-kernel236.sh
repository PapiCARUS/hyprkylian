#!/usr/bin/env bash
set -Eeuo pipefail
STATE="$HOME/.local/state/hyprkylian/kernel236"
[[ -f "$STATE/latest-backup" ]] || { echo "Pas de sauvegarde."; exit 1; }
BACKUP="$(cat "$STATE/latest-backup")"
[[ "$BACKUP" == "$STATE"/backups/* && -f "$BACKUP/manifest" ]] || exit 1
read -r -p "Restaurer la configuration precedente ? [o/N] " ans
[[ "$ans" =~ ^([oO]|oui|OUI)$ ]] || exit 0
mkdir -p "$BACKUP/new"
while IFS='|' read -r status kind name; do
  [[ "$kind" == config || "$kind" == bin ]] || exit 1
  [[ "$name" != */* && "$name" != .. && -n "$name" ]] || exit 1
  if [[ "$kind" == config ]]; then dst="$HOME/.config/$name"; else dst="$HOME/.local/bin/$name"; fi
  if [[ -e "$dst" || -L "$dst" ]]; then mv "$dst" "$BACKUP/new/$name"; fi
  if [[ "$status" == old ]]; then mv "$BACKUP/old/$name" "$dst"; fi
done < "$BACKUP/manifest"
rm -f "$STATE/latest-backup"
echo "Restauration terminee. Relance : LIBGL_ALWAYS_SOFTWARE=1 start-hyprland"
