<div align="center">

# ❄️ Arch Linux & Hyprland Dotfiles

<p align="center">
  <b>Configurações personalizadas para Arch Linux com Hyprland (Lua), Waybar e paleta Catppuccin Macchiato + Orange.</b>
</p>

![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-00A99D?style=for-the-badge&logo=wayland&logoColor=white)
![Catppuccin](https://img.shields.io/badge/Theme-Catppuccin_Macchiato-c6a0f6?style=for-the-badge)
![GNU Stow](https://img.shields.io/badge/Managed_with-GNU_Stow-informational?style=for-the-badge&logo=gnu)

</div>

---

## 🎨 Visão Geral do Setup

| Componente | Ferramenta | Detalhes da Configuração |
| :--- | :--- | :--- |
| **Window Manager** | [Hyprland](https://hyprland.org/) | Configuração modular em Lua (`hyprland.lua`), bordas em gradiente laranja/amarelo, cantos arredondados (10px) e regras flutuantes. |
| **Barra Superior** | [Waybar](https://github.com/Alexays/Waybar) | Paleta Catppuccin Macchiato + Laranja, workspaces em algarismos romanos (I a X), animações de bateria e integração com MPRIS. |
| **Launcher de Apps** | [Wofi](https://hg.sr.ht/~scoopta/wofi) | Janela central translúcida (glass), ícones e destaque em laranja. |
| **Terminal** | [Kitty](https://sw.kovidgoyal.net/kitty/) | JetBrainsMono Nerd Font, opacidade 0.85, padding interno de 12px e paleta sem azul (tons quentes). |
| **Shell & Prompt** | [Zsh](https://www.zsh.org/) + [Starship](https://starship.rs/) | Prompt customizado com status Git, linguagens e plugins (`autosuggestions`, `syntax-highlighting`, `zoxide`, `eza`, `fzf`). |
| **Lockscreen & Idle** | [Hyprlock](https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/) & [Hypridle](https://wiki.hyprland.org/Hypr-Ecosystem/hypridle/) | Bloqueio com blur no wallpaper padrão, relógio gigante e regras automáticas de suspensão. |
| **Conectividade** | [Impala](https://github.com/pythops/impala) & [Blueman](https://github.com/blueman-project/blueman) | Janelas flutuantes dedicadas para Wi-Fi (`iwd`/`iwctl`) e Bluetooth. |
| **Aparência GTK / Qt** | `nwg-look`, `qt6ct`, `Papirus-Dark` | Pastas personalizadas em laranja (`papirus-folders -C orange`), tema escuro `adw-gtk3-dark` e cursor `Bibata-Modern-Classic`. |

---

## ⌨️ Atalhos Principais (Keybindings)

| Atalho | Ação / Comando |
| :--- | :--- |
| <kbd>SUPER</kbd> + <kbd>T</kbd> | Abre o Terminal (**Kitty**) |
| <kbd>SUPER</kbd> + <kbd>R</kbd> | Abre o Menu de Aplicativos (**wofi**) |
| <kbd>SUPER</kbd> + <kbd>B</kbd> | Abre o Navegador Web (**Firefox**) |
| <kbd>SUPER</kbd> + <kbd>E</kbd> | Gerenciador de Arquivos (**Nemo**) |
| <kbd>SUPER</kbd> + <kbd>N</kbd> | Gerenciador de Wi-Fi Flutuante (**Impala / iwd**) |
| <kbd>SUPER</kbd> + <kbd>SHIFT</kbd> + <kbd>B</kbd> | Gerenciador de Bluetooth (**Blueman**) |
| <kbd>SUPER</kbd> + <kbd>L</kbd> | Bloqueia a Sessão (**Hyprlock**) |
| <kbd>SUPER</kbd> + <kbd>V</kbd> | Alterna Janela para Modo Flutuante |
| <kbd>SUPER</kbd> + <kbd>1</kbd> - <kbd>0</kbd> | Alterna entre Workspaces (I a X) |
| <kbd>PRINT</kbd> | Captura área da tela para o Clipboard (`grim` + `slurp`) |
| <kbd>SHIFT</kbd> + <kbd>PRINT</kbd> | Salva captura da tela em `~/Imagens/Screenshots/` |

---

## 📁 Estrutura dos Módulos (GNU Stow)

```text
~/dotfiles/
├── gtk/          # Configurações GTK-2.0, GTK-3.0 e GTK-4.0 (settings.ini, dark mode)
├── hypr/         # Configurações do Hyprland, Hyprpaper, Hyprlock e Hypridle
├── kitty/        # kitty.conf com paleta Macchiato + Laranja e fontes
├── lazygit/      # config.yml com tema e lazygit integrado
├── localbin/     # Scripts locais (temp-watch.sh — monitor térmico + alertas SwayNC)
├── qt/           # Configurações do qt5ct e qt6ct (estilo Fusion / Papirus)
├── starship/     # starship.toml com prompt customizado e status Git
├── swaync/       # Configurações e estilos do centro de notificações SwayNC
├── waybar/       # config.jsonc e estilos CSS modularizados
├── wofi/         # config + style.css do launcher (tema glass)
└── zsh/          # .zshrc com aliases modernos (eza, bat, zoxide, dotpush)
