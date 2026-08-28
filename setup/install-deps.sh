#!/usr/bin/env bash
# =============================================================================
# INSTALL-DEPS — Dependências de tema necessárias para a reforma visual
#
# Instala pacotes de tema que faltam para o design ficar correto e coeso.
# Pacotes da AUR são instalados via yay.
#
# Uso:
#   ./setup/install-deps.sh           # Modo verificação (mostra o que falta)
#   ./setup/install-deps.sh --apply   # Instala de fato (sudo/yay)
# =============================================================================
set -euo pipefail

is_installed() { pacman -Q "$1" >/dev/null 2>&1; }

# Pacotes do repositório oficial (pacman)
OFFICIAL=(
    bibata-cursor-theme   # cursor Bibata-Modern-Classic (Hyprland já referencia)
)

# Pacotes da AUR (via yay)
AUR=()

check() {
    local missing=0
    echo "▶ Verificando pacotes oficiais..."
    for p in "${OFFICIAL[@]}"; do
        if is_installed "$p"; then echo "  ✔ $p"; else echo "  ✖ $p (falta)"; missing=1; fi
    done
    echo "▶ Verificando pacotes AUR..."
    for p in "${AUR[@]}"; do
        if is_installed "$p"; then echo "  ✔ $p"; else echo "  ✖ $p (falta)"; missing=1; fi
    done
    [[ $missing -eq 0 ]] && echo "✔ Tudo instalado." || echo "Alguns pacotes faltam."
    return $missing
}

install() {
    local to_install=()
    for p in "${OFFICIAL[@]}"; do is_installed "$p" || to_install+=("$p"); done
    if [[ ${#to_install[@]} -gt 0 ]]; then
        echo "▶ Instalando (pacman): ${to_install[*]}"
        sudo pacman -S --needed --noconfirm "${to_install[@]}"
    fi

    local aur_to_install=()
    for p in "${AUR[@]}"; do is_installed "$p" || aur_to_install+=("$p"); done
    if [[ ${#aur_to_install[@]} -gt 0 ]]; then
        echo "▶ Instalando (AUR/yay): ${aur_to_install[*]}"
        yay -S --needed --noconfirm "${aur_to_install[@]}"
    fi

    echo "✔ Dependências instaladas."
    echo "Lembrete: após instalar o Bibata, rode o passo de setar o 'Indexed' "
    echo "          e reaplicar o tema de cursor (ver specs.md Fase 2)."
}

case "${1:-}" in
    "--apply") install ;;
    *) check || exit 1 ;;
esac
