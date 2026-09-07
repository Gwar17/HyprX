# HyprX — native Quickshell overlay for Hyprland

A small Arch Linux overlay installed **on top of an existing Hyprland setup**. No DMS and no Matugen. HyprX owns its Quickshell UI and a single deterministic visual theme.

## Install from Git

```bash
git clone https://github.com/Gwar17/HyprX.git
cd HyprX
./install.sh
```

Use `./install.sh --edge` for `quickshell-git` (master) or `./install.sh --fish` to switch to Fish and migrate simple Bash aliases. Both flags may be combined.

## Copy/paste install

After publishing the repository as `Gwar17/HyprX`, users can paste:

```bash
curl -fsSL https://raw.githubusercontent.com/Gwar17/HyprX/main/bootstrap.sh | bash
```

For a safer inspect-then-run flow:

```bash
curl -fsSLO https://raw.githubusercontent.com/Gwar17/HyprX/main/bootstrap.sh
less bootstrap.sh
bash bootstrap.sh
```

## What it adds

- Native named Quickshell config at `~/.config/quickshell/hyprx`
- Small Hyprland Lua overlay at `~/.config/hypr/hyprx`
- `awww` wallpaper helper with direct, random, and clipboard-path modes
- Quickshell launcher/control/file/clipboard/wallpaper surfaces and IPC hooks
- Unified Inter / JetBrains Mono Nerd Font / Papirus visual defaults
- Optional Bash → Fish migration

The installer backs up `hyprland.lua` before adding the guarded HyprX require block. It does not replace the base Hyprland configuration.

## Keys

`Super+Space` launcher · `Super+C` control center · `Super+E` files · `Super+V` clipboard · `Super+W` wallpapers · `Super+Shift+W` random wallpaper · `Super+Return` Kitty.

## Publish

```bash
git init
git add .
git commit -m "Initial HyprX Quickshell"
git branch -M main
git remote add origin git@github.com:Gwar17/HyprX.git
git push -u origin main
```

