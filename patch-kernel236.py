#!/usr/bin/env python3
"""VMware-specific adaptation of actual Kernel236 Hyprland Lua dotfiles."""
import sys
from pathlib import Path
old = Path(sys.argv[1]).read_text()
home = Path(sys.argv[2])
cfg = home / ".config"
for root in [cfg / p for p in ("hypr", "waybar", "kitty", "swaync", "rofi", "fastfetch", "wlogout", "btop")]:
    for p in root.rglob("*"):
        if not p.is_file() or p.is_symlink() or p.suffix not in {".lua",".json",".jsonc",".rasi",".css",".sh",".conf",".ini",""}:
            continue
        try: data = p.read_text()
        except (UnicodeError, OSError): continue
        new = data.replace("/home/kernel_x23_6", str(home))
        if new != data: p.write_text(new)
for p in (home / ".local/bin").glob("rofi-*"):
    if p.is_file():
        try: p.write_text(p.read_text().replace("/home/kernel_x23_6", str(home)))
        except UnicodeError: pass
entry = cfg / "hypr/hyprland.lua"
s = entry.read_text()
s = "\n".join(line for line in s.splitlines() if not any(
    tag in line for tag in ('hl.env("LIBVA_DRIVER_NAME"', 'hl.env("GBM_BACKEND"',
                      'hl.env("__GLX_VENDOR_LIBRARY_NAME"', 'hl.env("NVD_BACKEND"'))) + "\n"
s += '\n-- VMware overrides, original backed up by hyprkylian\ndofile(os.getenv("HOME") .. "/.config/hypr/local-vm.lua")\n'
entry.write_text(s)
monitors = [line.strip() for line in old.splitlines() if "hl.monitor(" in line and "2304x1260" in line]
inputs = [line.strip() for line in old.splitlines() if "hl.config(" in line and "kb_layout" in line and "input" in line]
inp = inputs[-1] if inputs else 'hl.config({ input = { kb_layout = "fr", kb_variant = "oss_latin9" } })'
vm = """-- VMware: minimal effects for software rendering
hl.env("LIBGL_ALWAYS_SOFTWARE", "1")
hl.config({ decoration = { rounding = 2, active_opacity = 1.0,
 inactive_opacity = 1.0, blur = { enabled = false } },
 animations = { enabled = false } })
"""
vm += "\n".join(monitors) + "\n" + inp + "\n"
(cfg / "hypr/local-vm.lua").write_text(vm)
start = cfg / "hypr/conf/autostart.lua"
s = start.read_text().replace('hl.exec_cmd(os.getenv("HOME") .. "/.local/bin/rofi-wallpaper --random")',
'hl.exec_cmd("sh -c \'sleep 2; ~/.local/bin/rofi-wallpaper --random\'")')
s = s.replace('hl.exec_cmd("hypridle")', '-- hypridle disabled on VMware')
start.write_text(s)
for p in (cfg / "waybar/scripts/theme-switch.sh", home / ".local/bin/rofi-wallpaper"):
    if p.exists():
        p.write_text(p.read_text().replace('--transition-type random --transition-fps 255 --transition-duration 0.8', '--transition-type none'))
bar = cfg / "waybar/config.jsonc"
bar.write_text(bar.read_text().replace('    "battery",\n','').replace('    "custom/weather",\n',''))
with (cfg / "waybar/style.css").open("a") as f:
    f.write('\n/* Low-radius geometry */\nwindow#waybar, #workspaces, #clock, #tray, #cpu, #memory {border-radius: 2px;}\n')
kitty = cfg / "kitty/kitty.conf"
kitty.write_text(kitty.read_text().replace('background_opacity 0.60', 'background_opacity 0.93'))
