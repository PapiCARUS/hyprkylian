#!/usr/bin/env bash
set -u
ROOT="$HOME/.config/hyprkylian"
[[ -n "${WAYLAND_DISPLAY:-}" ]] || { echo "Lance depuis Kitty dans Hyprland, pas depuis SSH."; exit 1; }
if ! pgrep -x swww-daemon >/dev/null; then
 swww-daemon >/tmp/hyprkylian-swww.log 2>&1 &
 sleep 2
fi
swww img "$ROOT/wallpaper.png" --transition-type none >/tmp/hyprkylian-wallpaper.log 2>&1 || true
pkill -x waybar 2>/dev/null || true
waybar -c "$ROOT/waybar/config.jsonc" -s "$ROOT/waybar/style.css" >/tmp/hyprkylian-waybar.log 2>&1 &
echo "Bureau pastel lance. Journal : /tmp/hyprkylian-waybar.log"
