#!/usr/bin/env python3
"""Improve the already installed Kernel236 desktop without touching Hyprland Lua.

- Preset an actual anime wallpaper from the original repo (Howl's Moving Castle).
- Keep wallpaper changes persistent when picking another image.
- Make Waybar readable and structured at 2304x1260.
"""
from pathlib import Path
from datetime import datetime
import shutil
import sys

home = Path.home()
config = home / ".config"
bar = config / "waybar"
picker = home / ".local/bin/rofi-wallpaper"
rofi = config / "rofi"
image = config / "assets/backgrounds/whitehat/2143421-2560x1440-desktop-hd-howls-moving-castle-wallpaper.jpg"
paths = [bar / "style.css", bar / "config.jsonc", picker]
if any(not p.is_file() for p in paths):
    sys.exit("Kernel236 absent ou incomplet : merci de signaler le résultat de ls ~/.config/waybar")
backup = home / ".local/state/hyprkylian/polish" / datetime.now().strftime("%Y%m%d-%H%M%S")
backup.mkdir(parents=True, exist_ok=True)
for f in paths:
    shutil.copy2(f, backup / f.name)
wall_link = rofi / ".current_wallpaper"
if wall_link.is_symlink():
    (backup / "wallpaper-link.txt").write_text(str(wall_link.readlink()))
elif wall_link.is_file():
    shutil.copy2(wall_link, backup / "wallpaper-file")

css = bar / "style.css"
s = css.read_text()
key = "/* hyprkylian geometric-ui v1 */"
if key not in s:
    s += """
%s
* { font-size: 16px; }
window#waybar { background: alpha(@base, 0.93); border-bottom: 1px solid @surface1; }
#window, #tray, #clock, #cpu, #memory, #workspaces,
#custom-control-center, #custom-active-ip, #custom-idle-inhibitor {
 border-radius: 2px; padding: 5px 12px; margin: 5px 2px;
}
#workspaces button, #workspaces button.active { border-radius: 2px; padding: 2px 10px; }
""" % key
    css.write_text(s)

bar_config = bar / "config.jsonc"
s = bar_config.read_text()
# Replace the collapsed group with always-visible CPU/RAM.
s = s.replace('"group/system",', '"cpu",\n    "memory",')
bar_config.write_text(s)

s = picker.read_text()
anchor = 'if [[ "${1:-}" == "--random" ]]; then\n'
if anchor in s and "# hyprkylian: use selected wallpaper" not in s:
    replacement = anchor + (
        '    # hyprkylian: use selected wallpaper on every login\n'
        '    if [[ -f "$CURRENT_LINK" ]]; then\n'
        '        apply_wall "$(readlink -f "$CURRENT_LINK")"\n'
        '        exit 0\n'
        '    fi\n'
    )
    picker.write_text(s.replace(anchor, replacement, 1))
elif "# hyprkylian: use selected wallpaper" not in s:
    print("Note : impossible de rendre le fond persistant automatiquement.", file=sys.stderr)

if image.is_file():
    wall_link.unlink(missing_ok=True)
    wall_link.symlink_to(image)
    print("Fond anime sélectionné :", image.name)
else:
    print("Fond d'écran anime non trouvé; fond conservé.")

print("Barre Waybar agrandie et panneaux géométriques.")
print("Sauvegarde :", backup)
print("Dans Kitty (Hyprland), lancer :")
print("  ~/.local/bin/rofi-wallpaper --random")
print("  killall -SIGUSR2 waybar")
print("Pour choisir ensuite un fond : Super+Shift+W")
