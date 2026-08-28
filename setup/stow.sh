#!/usr/bin/env bash
# =============================================================================
# STOW SCRIPT — Gerencia os dotfiles com GNU Stow com segurança
#
# Uso:
#   ./setup/stow.sh apply     # Aplica/instala os symlinks (stow -R)
#   ./setup/stow.sh remove    # Remove os symlinks (mantém os arquivos em dotfiles)
#   ./setup/stow.sh list      # Lista os symlinks gerenciados
# =============================================================================
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
PACKAGES=(gtk hypr kitty lazygit qt rofi starship waybar zsh)

cd "$DOTFILES_DIR"

apply() {
    echo "▶ Aplicando stow para: ${PACKAGES[*]}"
    for pkg in "${PACKAGES[@]}"; do
        echo "  - $pkg"
        stow --restow --target="$HOME" "$pkg"
    done
    echo "✔ Dotfiles aplicados (symlinks criados)."
}

remove() {
    echo "▶ Removendo stow (arquivos em dotfiles preservados)..."
    for pkg in "${PACKAGES[@]}"; do
        stow --delete --target="$HOME" "$pkg"
    done
    echo "✔ Symlinks removidos."
}

list() {
    echo "▶ Symlinks gerenciados apontando para ~/dotfiles:"
    find "$HOME/.config" -maxdepth 2 -type l -lname '*dotfiles*' 2>/dev/null \
        | sed "s|$HOME/||"
}

case "${1:-}" in
    apply)  apply ;;
    remove) remove ;;
    list)   list ;;
    *) echo "Uso: $0 {apply|remove|list}"; exit 1 ;;
esac
