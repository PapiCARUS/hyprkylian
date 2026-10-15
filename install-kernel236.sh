#!/usr/bin/env bash
# Arch VMware port of Kernel236/my-hyprland-dotfiles (Apache-2.0).
set -Eeuo pipefail
BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO='https://github.com/Kernel236/my-hyprland-dotfiles.git'
COMMIT='98b17a270212fc907c5b305dd661bad4f738ca89'
SRC="$HOME/.local/share/hyprkylian/kernel236-source"
STATE="$HOME/.local/state/hyprkylian/kernel236"
CONFIG="$HOME/.config"
BACKUP="$STATE/backups/$(date +%Y%m%d-%H%M%S)"
ITEMS=(hypr waybar kitty swaync rofi fastfetch wlogout btop assets)
BINS=(rofi-launcher rofi-wallpaper rofi-clipboard)
[[ "$EUID" != 0 ]] || { echo 'Ne lance pas ce script avec sudo.'; exit 1; }
[[ -f "$CONFIG/hypr/hyprland.lua" ]] || { echo 'Pas de configuration Hyprland Lua.'; exit 1; }
command -v pacman >/dev/null || { echo 'Arch uniquement'; exit 1; }
command -v git >/dev/null || { echo 'Installe git : sudo pacman -S git'; exit 1; }
if pgrep -u "$(id -u)" -x Hyprland >/dev/null 2>&1; then
  echo 'Ferme Hyprland (Super+M) avant de modifier sa configuration via SSH.'
  exit 1
fi
printf '\nHYPRKYLIAN : installation du VRAI bureau complet Kernel236.\n'
printf 'Source: %s (%s)\n' "$REPO" "$COMMIT"
printf 'Dossiers remplaces apres sauvegarde : %s\n' "${ITEMS[*]}"
printf 'Conserve boot, shell, connexion, AZERTY, resolution, mode VMware.\n'
read -r -p 'Snapshot VMware fait ? [o/N] ' ok
[[ "$ok" =~ ^([oO]|oui|OUI)$ ]] || exit 0
read -r -p 'Continuer ? [o/N] ' ok
[[ "$ok" =~ ^([oO]|oui|OUI)$ ]] || exit 0
mkdir -p "$STATE/backups" "$(dirname "$SRC")"
if [[ ! -d "$SRC/.git" ]]; then git clone "$REPO" "$SRC"; fi
git -C "$SRC" fetch --depth=1 origin "$COMMIT"
git -C "$SRC" checkout --detach "$COMMIT"
PKGS=(hyprland kitty waybar rofi rofi-calc rofi-emoji swaync hyprlock hypridle
      awww wl-clipboard cliphist swww wlogout yazi thunar fastfetch btop
      grim slurp swappy libnotify pamixer playerctl brightnessctl
      polkit-kde-agent ttf-jetbrains-mono-nerd noto-fonts-emoji jq)
AVAILABLE=(); MISSING=()
for pkg in "${PKGS[@]}"; do
  if pacman -Si "$pkg" >/dev/null 2>&1; then AVAILABLE+=("$pkg")
  elif ! pacman -Q "$pkg" >/dev/null 2>&1; then MISSING+=("$pkg")
  fi
done
printf 'Paquets officiels a verifier : %s\n' "${AVAILABLE[*]}"
if (("${#MISSING[@]}" > 0)); then printf 'Non disponibles (options eventuellement absentes): %s\n' "${MISSING[*]}"; fi
read -r -p 'Actualiser Arch et installer les paquets avec pacman -Syu ? [o/N] ' ok
[[ "$ok" =~ ^([oO]|oui|OUI)$ ]] || exit 0
if (("${#AVAILABLE[@]}" > 0)); then sudo pacman -Syu --needed "${AVAILABLE[@]}"; else sudo pacman -Syu; fi
mkdir -p "$BACKUP/old" "$BACKUP/new" "$HOME/.local/bin" "$CONFIG"
: > "$BACKUP/manifest"
for d in "${ITEMS[@]}"; do
  if [[ -e "$CONFIG/$d" || -L "$CONFIG/$d" ]]; then
    mv "$CONFIG/$d" "$BACKUP/old/$d"
    printf 'old|config|%s\n' "$d" >> "$BACKUP/manifest"
  else printf 'new|config|%s\n' "$d" >> "$BACKUP/manifest"; fi
done
for f in "${BINS[@]}"; do
  if [[ -e "$HOME/.local/bin/$f" || -L "$HOME/.local/bin/$f" ]]; then
    mv "$HOME/.local/bin/$f" "$BACKUP/old/$f"
    printf 'old|bin|%s\n' "$f" >> "$BACKUP/manifest"
  else printf 'new|bin|%s\n' "$f" >> "$BACKUP/manifest"; fi
done
printf '%s\n' "$BACKUP" > "$STATE/latest-backup"
for d in "${ITEMS[@]}"; do
  if [[ "$d" == assets ]]; then cp -a "$SRC/assets" "$CONFIG/assets"
  else cp -a "$SRC/.config/$d" "$CONFIG/$d"; fi
done
for f in "${BINS[@]}"; do
  cp -a "$SRC/.local/bin/$f" "$HOME/.local/bin/$f"
  chmod u+x "$HOME/.local/bin/$f"
done
python "$BASE/patch-kernel236.py" "$BACKUP/old/hypr/hyprland.lua" "$HOME"
linktheme() { ln -sfn "$2" "$1"; }
linktheme "$CONFIG/hypr/theme.lua" "$CONFIG/hypr/themes/macchiato.lua"
linktheme "$CONFIG/hypr/hyprlock.conf" "$CONFIG/hypr/themes/hyprlock-macchiato.conf"
linktheme "$CONFIG/waybar/theme.css" "$CONFIG/waybar/themes/macchiato.css"
linktheme "$CONFIG/fastfetch/config.jsonc" "$CONFIG/fastfetch/config-macchiato.jsonc"
linktheme "$CONFIG/rofi/colors.rasi" "$CONFIG/rofi/colors-macchiato.rasi"
linktheme "$CONFIG/kitty/theme.conf" "$CONFIG/kitty/themes/macchiato.conf"
linktheme "$CONFIG/swaync/theme.css" "$CONFIG/swaync/themes/macchiato.css"
cp -a "$CONFIG/swaync/themes/macchiato.css" "$CONFIG/swaync/style.css"
printf '%s\n' "$CONFIG/assets/backgrounds/whitehat" > "$CONFIG/rofi/.wall_dir"
wall="$(find "$CONFIG/assets/backgrounds/whitehat" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.webp' \) -print -quit)"
if [[ -n "$wall" ]]; then linktheme "$CONFIG/rofi/.current_wallpaper" "$wall"; fi
printf '\nInstallation terminee ! Sauvegarde: %s\n' "$BACKUP"
printf 'Dans VMware, demarre: LIBGL_ALWAYS_SOFTWARE=1 start-hyprland\n'
printf 'Super+T Kitty | Super+A Rofi | Super+I Raccourcis\n'
printf 'Restaurer depuis SSH: bash ~/hyprkylian/restore-kernel236.sh\n'