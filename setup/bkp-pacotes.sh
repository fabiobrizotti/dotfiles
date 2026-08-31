#!/usr/bin/env bash
# =============================================================================
# BACKUP DE PACOTES — Reproduzibilidade / restauração do sistema Arch
#
# Salva a lista de pacotes instalados para que o setup possa ser
# reproduzido em outra máquina ou restaurado após um problema.
#
# Uso:
#   ./setup/bkp-pacotes.sh            # Salva com timestamp em ~/dotfiles/backup/
#   ./setup/bkp-pacotes.sh -r         # Restaura (instala) a partir do backup salvo
# =============================================================================
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$DOTFILES_DIR/backup"
EXPLICIT="$BACKUP_DIR/pacotes-explicitos.txt"
FULL="$BACKUP_DIR/pacotes-completos.txt"
ORPHANS="$BACKUP_DIR/orfaos.txt"

mkdir -p "$BACKUP_DIR"

backup() {
    echo "▶ Salvar lista de pacotes em $BACKUP_DIR"
    pacman -Qqe > "$EXPLICIT"         # explicitamente instalados
    pacman -Qq  > "$FULL"             # todos instalados
    pacman -Qtdq > "$ORPHANS" || true # órfãos (pode ficar vazio)
    echo "✔ Explicitos: $(wc -l < "$EXPLICIT")"
    echo "✔ Completos : $(wc -l < "$FULL")"
    echo "✔ Órfãos    : $(wc -l < "$ORPHANS")"
    echo "Dica: órfãos podem ser removidos com: sudo pacman -Rns --noconfirm \$(pacman -Qtdq)"
}

restore() {
    if [[ ! -f "$EXPLICIT" ]]; then
        echo "✖ Nenhum backup encontrado em $EXPLICIT" >&2
        exit 1
    fi
    echo "▶ Reinstalando pacotes explícitos (necessário sudo)..."
    sudo pacman -S --needed --noconfirm - < "$EXPLICIT"
    echo "✔ Restauração concluída."
}

case "${1:-}" in
    "-r"|"restore") restore ;;
    ""|"backup") backup ;;
    *) echo "Uso: $0 [backup|-r restore]"; exit 1 ;;
esac
