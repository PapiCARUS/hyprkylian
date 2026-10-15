# hyprkylian — bureau Hyprland anime, géométrique

**Portage expérimental du véritable environnement [Kernel236/my-hyprland-dotfiles](https://github.com/Kernel236/my-hyprland-dotfiles)** (licence Apache-2.0), version source épinglée au commit `98b17a270212fc907c5b305dd661bad4f738ca89`.

Destiné à **Arch Linux + Hyprland Lua 0.55+ dans VMware Workstation**. Les composants proviennent du dépôt officiel : Hyprland Lua, Waybar, Rofi, Kitty, SwayNC, wlogout, hyprlock, wallpapers anime, système de thèmes Macchiato / Matrix. L'installateur original n'est pas lancé : un script spécial VMware le remplace.

## Installation

**Un snapshot VMware est obligatoire** avant essai. Conserver une session SSH Windows ouverte pour la récupération. Fermer Hyprland dans la VM avant installation.

```bash
cd ~/hyprkylian
git pull --ff-only
bash install-kernel236.sh
```

La procédure demande plusieurs confirmations et lance une mise à jour Arch via pacman. Certaines dépendances facultatives peuvent manquer aux dépôts officiels ; le script les signale. Elle ne lance pas automatiquement d'installateur AUR. Il faut une connexion internet sur la VM pour cloner les sources amont.

Après installation, relancer Hyprland dans VMware :

```bash
LIBGL_ALWAYS_SOFTWARE=1 start-hyprland
```

Raccourcis source : **Super+T** terminal, **Super+A** applications, **Super+I** aide.

## Sauvegardes et récupération

Une copie des anciens dossiers `.config/hypr`, `waybar`, `kitty`, `swaync`, `rofi`, `fastfetch`, `wlogout`, `btop`, `assets`, et de trois utilitaires Rofi est conservée sous `~/.local/state/hyprkylian/kernel236/backups/`. Le script de récupération les remet à leur place (sans désinstaller les paquets).

```bash
bash ~/hyprkylian/restore-kernel236.sh
```

Le script recopie tes paramètres de clavier et de moniteur dans `~/.config/hypr/local-vm.lua`, supprime les variables NVIDIA du fichier principal, diminue blur, transparence et animations et évite de lancer hypridle dans la VM. **Tout n'a pas encore été testé visuellement sur cette machine**. Si l'interface ne démarre pas, utiliser SSH et le script de restauration.

## Historique

L'ancienne expérience Hyprclouds est encore présente dans les fichiers `install.sh` et `restore.sh`. **Ne pas les utiliser pour installer ce nouveau bureau**. Le projet actif est maintenant Kernel236.

## Attribution

Dotfiles originaux : [Kernel236/my-hyprland-dotfiles](https://github.com/Kernel236/my-hyprland-dotfiles), sous [Apache License 2.0](https://github.com/Kernel236/my-hyprland-dotfiles/blob/main/LICENSE). L'installateur clone l'original, il ne redistribue pas les éléments graphiques d'autres auteurs.
