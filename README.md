# hyprkylian 🌸

Prototype rose kawaii pour **Arch Linux + Hyprland Lua en VM VMware**, inspiré de [Hyprclouds](https://github.com/arfan-on-clouds/hyprclouds). Ce n'est **pas encore le portage complet** du bureau original : les widgets Eww d'origine demandent davantage d'adaptation. Le projet récupère les sources amont pour consultation, et installe pour l'instant un thème rose avec **Waybar, Kitty et un fond généré localement**.

## Avant de commencer

- Hyprland Lua et Kitty déjà opérationnels.
- Faire un **snapshot VMware avant installation**.
- Le clavier AZERTY, la résolution VMware et le lancement avec `LIBGL_ALWAYS_SOFTWARE=1 start-hyprland` ne sont pas modifiés.
- Le script fait une sauvegarde des fichiers qu'il modifie.

## Installation depuis SSH Windows (dans ta session Arch)

```bash
sudo pacman -S --needed git
git clone https://github.com/PapiCARUS/hyprkylian.git ~/hyprkylian
bash ~/hyprkylian/install.sh
```

L'installateur demande une confirmation et le mot de passe sudo. **Il n'exécute pas les anciens scripts Fedora Hyprclouds.**

## Démarrer le bureau rose

Dans **Kitty à l'intérieur de Hyprland** (pas dans la session SSH) :

```bash
bash ~/.config/hyprkylian/start.sh
```

Le démarrage est manuel pendant cette première phase de test. Le script lance un fond via `swww` et une barre `waybar` sans modifier la configuration Hyprland. Le terminal Kitty adopte le thème dans les nouvelles fenêtres.

Journaux : `/tmp/hyprkylian-waybar.log` et `/tmp/hyprkylian-wallpaper.log`.

## Restaurer

```bash
bash ~/hyprkylian/restore.sh
```

La restauration remet les sauvegardes Hyprland et Kitty et retire les fichiers du thème. Les paquets installés restent présents.

**Statut** : fichiers publiés et relus, mais pas encore testés sur cette VM.