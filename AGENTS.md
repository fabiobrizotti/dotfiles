# AGENTS.md

Dotfiles for **Arch + Hyprland (Lua config)**, Catppuccin Macchiato + Orange, managed with GNU Stow. Portuguese-speaking user.

> **🚧 Migração Waybar/SwayNC/Wofi → AGS v3 em andamento.** `waybar/`, `swaync/` e `wofi/` foram removidos do repo e do stow em 2026-09-28. O Hyprland **ainda os invoca** (autostart, binds e layer_rules) — essa limpeza está agendada para a Fase 6. Trate o sistema como **transicionalmente inconsistente** até a Fase 6 concluir: `SUPER+R`, `SUPER+SHIFT+V`, teclas `XF86Audio*` e `XF86MonBrightness*` estão quebrados agora. O plano e o progresso vivem na nota de vault `Migracao Waybar-para-AGS`.

## Read first
- `specs.md` — the living spec/roadmap. Read it before any task; it tracks phases, decisions, incidents and rollback.

## Critical: live symlink setup
Files in `~/dotfiles/*/.config/...` are the **originals**; `~/.config/<app>` entries are **symlinks** into this repo via GNU Stow. **Editing here changes the running system immediately.** Always validate after editing the config of a running app.
- Exception: `hypr/.config/hypr/config/*.lua` modules load via **absolute path** into the repo (see Hyprland quirks below). **Confirmed 2026-09-28:** `hypr/` **is** part of the stow `PACKAGES` and `~/.config/hypr/config` **does** exist as a symlink into the repo — the two access paths (`~/.config/hypr/config/appearance.lua` via symlink, and the absolute `dofile` path in `hyprland.lua`) point at the **same** files. Editing in the repo changes the running system by both routes.
- AGS (`ags/` pacote): os **fontes** (`app.ts`, `widget/`, `style.scss`, `tsconfig.json`, `package.json`, `env.d.ts`) são symlinks do repo; **`node_modules/` e `@girs/` ficam como diretórios locais** em `~/.config/ags` (fora do stow via `ags/.stow-local-ignore` e fora do git). Serviços Astal vêm do sistema via `gi://Astal*` (não do npm), e `ags/gtk4/app` resolve de `/usr/share/ags/js`. Sempre validar com `agss` rodando (ver Validation).

## Git workflow (hard rules)
- Work only on branch **`dev`**. **Never push/merge to `main`** without explicit user approval.
- Rollback mechanism is git tags: `backup-pre-dev` (pristine original), `checkpoint-reforma-inicio`, `checkpoint-fase-b`, `checkpoint-pre-ags` (antes da remoção do waybar/swaync/wofi). Full restore: `git reset --hard <tag>`.
- Commit per phase with specs.md updated. `dotpush` alias pushes manually (user decides) — do not auto-push.

## Hyprland Lua config quirks (high risk of getting this wrong)
- Hyprland's Lua env does **not** expose `os.getenv` (returns nil) and `require` doesn't resolve relative dirs.
- Modules are loaded with **absolute `dofile` paths** like `/home/brizotti/dotfiles/hypr/.config/hypr/config/*.lua`. Do not "simplify" to relative paths or `require` — it breaks.
- Config uses the **experimental Lua API (`hyprlua`/`hl.*`, Hyprland 0.56)**. On Hyprland upgrade, verify Lua still works or plan migration to classic `hyprlang`.
- `binds.lua` uses `hl.dsp.exec_cmd(...)` for keybind actions.

## Validation (required after Hyprland config changes)
- `luac -p <file>` for syntax, then `hyprctl reload` (expect `ok`) and `hyprctl getoption decoration:blur:size` / `decoration:blur:passes` to confirm.
- Valid state = **~49 active binds** (`hyprctl binds | grep -c '^bind$'`), workspaces switching, processes running: `hyprpaper hypridle ags` (após Fase 3; hoje `waybar hyprpaper swaync swayosd-server hypridle` enquanto a migração não termina).
- Stow packages: `PACKAGES=(ags gtk hypr kitty lazygit localbin qt starship zsh)`. Re-apply a package after removing an original dir: `stow --restow --target="$HOME" <pkg>`. **Cuidado com `--adopt`:** adota arquivos do target sobre os do repo — só usar num pacote novo com fontes idênticos, nunca sobre edições feitas no repo.
- Thermal: `temp-watch` (pacote `localbin`) monitora a CPU no autostart do Hyprland; alerta via SwayNC a 85°C e crítico a 90°C. Daemons: `thermald` + `auto-cpufreq` (Trilha A; sem PWM/fancontrol neste laptop).

## Security / root access (sensitive)
- **Temporary passwords `031222` for both `brizotti` and `root`** (set during a sudo-incident recovery). **User must change them ASAP** — remind/flag, never reuse.
- `su -` asks the **root** password, not the user's. Prefer `sudo -i`.
- `sudo` requires an interactive password in this environment. The emergency root path is the **`docker` group**: `docker run --rm -v /:/host alpine sh -c 'chroot /host ...'` (used to fix sudo before).
- apt/pacman installs (`yay`, `pacman`) failed in non-interactive runs before — prefer telling the user to run them, or use the docker/chroot path.

## Apps / status notes (avoid redoing / being misled)
- Launcher era **wofi** (rofi 2.0 quebrava o parse de tema; revertido) e notificações usavam **SwayNC** — **ambos removidos na migração para AGS v3** (ver aviso no topo). Launcher/notificações serão `ags` nas Fases 3–4. `README.md` está **desatualizado** nesse ponto até a Fase 7.
- `gtk-4.0/` is **not** stowed — `~/.config/gtk-4.0/settings.ini` is generated by `nwg-look`; it is versioned directly in `gtk/.config/gtk-4.0/settings.ini` (keep in sync manually).
- Screenshot binds (see `binds.lua`, the source of truth): `PRINT`=area→clip, `SHIFT+PRINT`=area→save (`~/Imagens/Screenshots/`), `SUPER+PRINT`=full→clip.
- Kitty is translucent via window-rule + Hyprland blur.

## System tuning already applied (do not "fix" blindly)
- `/etc/systemd/network/20-ethernet.network` **and** `20-wlan.network` have `RequiredForOnline=no` (fixes 2min boot stall from `systemd-networkd-wait-online`; user connects over Wi-Fi, so wlan was the real culprit). Backup of wlan file: `/etc/systemd/network/20-wlan.network.bak-20260828-190919`. Effect visible **after reboot**.
- Journald limited (`SystemMaxUse=100M`). paccache trimmed.
- `amd-ucode` is installed but CPU is Intel — removable (`sudo pacman -Rns amd-ucode`) but left by choice.

## Design decisions
- Palette: Catppuccin Macchiato; accent orange `#fc7b53`. Font `JetBrainsMono Nerd Font`; cursor `Bibata-Modern-Classic`; icons `Papirus-Dark` (orange folders). Qt stays `Fusion` (Kvantum optional, not default).
