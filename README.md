# hyprkylian 🌸

Adaptation expérimentale de [Hyprclouds](https://github.com/arfan-on-clouds/hyprclouds) pour **Arch Linux + Hyprland Lua 0.55+ sous VMware**.

Le but : un bureau rose pastel et kawaii tout en **conservant les paramètres existants** (AZERTY, écran personnalisé, rendu logiciel). Ce projet n'est pas encore un portage intégral du dépôt d'origine : il en récupère une copie de référence et propose un bureau inspiré avec Eww simplifié ou Waybar, Kitty et un fond généré localement.

**Avant installation, créer un snapshot VMware.** L'installateur fait une sauvegarde de la configuration qu'il modifie. Ce projet n'a pas encore été testé en session graphique sur la VM cible.

## Installation (depuis SSH)

```bash
sudo pacman -S --needed git
git clone https://github.com/PapiCARUS/hyprkylian.git ~/hyprkylian
bash ~/hyprkylian/install.sh
```

Répondre aux confirmations, puis ouvrir **Kitty dans Hyprland** et lancer :

```bash
bash ~/.config/hyprkylian/start.sh
```

Relancer ensuite Hyprland avec le même `LIBGL_ALWAYS_SOFTWARE=1 start-hyprland` qu'avant. Le démarrage de la barre est enregistré pour les sessions suivantes.

## Annuler

```bash
bash ~/hyprkylian/restore.sh
```

La restauration remet les configurations Hyprland et Kitty sauvegardées, sans désinstaller les paquets. Les journaux de démarrage se trouvent dans `/tmp/hyprkylian-*.log`.

## Points importants

- Ne remplace pas `~/.config/hypr/hyprland.lua` : y ajoute un petit module séparé, sans toucher à `input` ou `monitor`.
- L'installateur ne change pas ton mode de lancement VMware et n'exécute pas de configurations Fedora obsolètes.
- La barre Eww est facultative, via l'AUR après inspection du `PKGBUILD`; Waybar sert de solution de secours.
- Code tiers : pas de redistribution du dépôt original, qui est seulement cloné pour référence.
