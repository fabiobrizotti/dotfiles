# =============================================================================
# HISTÓRICO DO SHELL
# =============================================================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# =============================================================================
# ALIASES MODERNOS (eza, bat, navegação)
# =============================================================================
# eza no lugar de ls
alias ls="eza --icons=always --group-directories-first"
alias ll="eza -la --icons=always --octal-permissions --group-directories-first"
alias la="eza -a --icons=always --group-directories-first"
alias lt="eza --tree --level=2 --icons=always"

# bat no lugar de cat
alias cat="bat --style=plain --paging=never"
alias catp="bat --style=numbers,changes,header"

# Atalho rápido para salvar dotfiles
dotpush() {
    cd ~/dotfiles && git add . && git commit -m "$1" && git push && cd -
}

# =============================================================================
# INTEGRAÇÃO DE PLUGINS DO ARROW E SINTAXE
# =============================================================================
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# Cor cinza suave para a sugestão automática
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6e738d"

# =============================================================================
# INTEGRAÇÃO DE BINÁRIOS MODERNOS (Starship, Zoxide, FZF)
# =============================================================================
# Inicializa o zoxide (substituto do cd: use 'z <pasta>')
eval "$(zoxide init zsh)"

# Inicializa o Starship Prompt
eval "$(starship init zsh)"

# Integração do FZF (Ctrl + R para histórico / Ctrl + T para arquivos)
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

# Git & Docker TUI Aliases
alias lg="lazygit"
alias lzd="lazydocker"
alias dps="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"

# =============================================================================
# MANUTENÇÃO DO SISTEMA
# =============================================================================
# Atualizar o sistema (pacman + AUR) e salvar backup de pacotes
update() {
    sudo pacman -Syu --noconfirm
    yay -Sua --noconfirm
    [ -x ~/dotfiles/setup/bkp-pacotes.sh ] && ~/dotfiles/setup/bkp-pacotes.sh
}

# Remover pacotes órfãos (não são dependência de nada)
cleanup() {
    local orphans
    orphans=$(pacman -Qtdq 2>/dev/null)
    if [ -n "$orphans" ]; then
        sudo pacman -Rns --noconfirm $orphans
    else
        echo "Nenhum pacote órfão para limpar."
    fi
}

# Limpar cache do pacman que não está em uso
cleancache() {
    sudo pacman -Sc --noconfirm
}

# Backup rápido da lista de pacotes instalados
bkp-pacotes() {
    [ -x ~/dotfiles/setup/bkp-pacotes.sh ] && ~/dotfiles/setup/bkp-pacotes.sh
}

# Adiciona o PATH do uv (gerencia ferramentas Python locais em ~/.local/bin)
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
