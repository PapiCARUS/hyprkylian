#!/usr/bin/env bash
set -Eeuo pipefail
APP=hyprkylian
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME/.config/$APP"
STATE="$HOME/.local/state/$APP"
HYPR="$HOME/.config/hypr/hyprland.lua"
[[ "$EUID" -ne 0 ]] || { echo "Ne lance pas ce script avec sudo."; exit 1; }
[[ -f "$HYPR" ]] || { echo "Configuration Hyprland Lua absente: $HYPR"; exit 1; }
command -v pacman >/dev/null || exit 1
echo "Ce port conserve ton fichier Hyprland Lua, l'AZERTY, la resolution et VMware."
read -r -p "Snapshot VMware cree ? [o/N] " ok
[[ "$ok" == o || "$ok" == O || "$ok" == oui ]] || exit 1
BACKUP="$STATE/backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP" "$TARGET" "$STATE" "$HOME/.config/kitty"
cp -a "$HYPR" "$BACKUP/hyprland.lua"
if [[ -f "$HOME/.config/kitty/kitty.conf" ]]; then cp -a "$HOME/.config/kitty/kitty.conf" "$BACKUP/kitty.conf"; else touch "$BACKUP/kitty-absent"; fi
[[ ! -d "$TARGET" ]] || cp -a "$TARGET" "$BACKUP/previous-target"
echo "$BACKUP" > "$STATE/latest-backup"
echo "Sauvegarde : $BACKUP"
sudo pacman -S --needed git kitty waybar wofi swww python python-pillow ttf-jetbrains-mono-nerd noto-fonts-emoji jq
mkdir -p "$HOME/.local/share/$APP"
if [[ ! -d "$HOME/.local/share/$APP/upstream/.git" ]]; then
 git clone --depth 1 https://github.com/arfan-on-clouds/hyprclouds.git "$HOME/.local/share/$APP/upstream"
fi
cp -a "$ROOT/config/." "$TARGET/"
cp "$ROOT/scripts/start.sh" "$TARGET/start.sh"
python "$ROOT/scripts/make_wallpaper.py" "$TARGET/wallpaper.png"
chmod +x "$TARGET/start.sh"
K="$HOME/.config/kitty/kitty.conf"
touch "$K"
sed -i '\|^include .*/hyprkylian/kitty-theme.conf$|d' "$K"
printf '\ninclude %s/kitty-theme.conf\n' "$TARGET" >> "$K"
echo "Installe. Aucun changement du clavier, de l'ecran ni de Hyprland Lua."
echo "Depuis Kitty DANS Hyprland : bash ~/.config/hyprkylian/start.sh"
echo "Annuler : bash ~/hyprkylian/restore.sh"
