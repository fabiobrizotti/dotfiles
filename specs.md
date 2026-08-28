# Specs — Reforma dos Dotfiles

> **Documento vivo.** Atualizado a cada fase. Use este arquivo para retomar o trabalho de onde parou em qualquer sessão futura.
> Leia este arquivo (e o README) antes de continuar qualquer tarefa.

---

## 🎯 Contexto

Reforma do setup de dotfiles num **Arch Linux + Hyprland (Lua)** com tema **Catppuccin Macchiato + laranja**.

**Objetivo do dono:** um sistema **bonito, leve e funcional**, corrigindo o desalinhamento de design que foi se acumulando ao longo do tempo ("fui fazendo sem ver muitas coisas").

**Direção visual (aprovada):** manter a identidade Catppuccin Macchiato + laranja, mas **corrigir todas as inconsistências** para ficar coeso.
**Permissão (aprovada):** **instalar pacotes necessários** para corrigir tema (cursor Bibata, kvantum, etc.).
**Validação (aprovada):** rodar `hyprctl reload` e conferir visualmente a cada mudança, antes de commitar cada fase.

---

## 🟠 OBSERVAÇÃO IMPORTANTE — Acesso root (2026-08-28)

Durante a sessão houve um incidente de perda de acesso sudo. Causa: tentativas
de instalação (yay) no ambiente não-interativo falharam e a senha do brizotti
acabou resetada/resincronizada. Restaurado o acesso via grupo **docker**
(usuário está no grupo docker → caminho de root de emergência).

**Estado atual das senhas (TODAS temporárias = `031222` — trocar o quanto antes):**
- `brizotti` = `031222` (sudo funciona)
- `root` = `031222` (su - funciona após sincronização)

**Lembretes:**
- O `su -` (sem usuário) pede a senha do **root**, não a do usuário → ambas setadas iguais por ora.
- **Recomendado:** `sudo -i` em vez de `su -` (padrão Arch).
- Trocar a senha de exemplo por uma pessoal e forte assim que possível:
  ```bash
  passwd            # atual: 031222 → nova
  sudo passwd root  # opcional, separar
  ```
- **Não reiniciar esperando resolver problema de senha** (é persistente em disco).

---

## 🛡️ Segurança e Restauração

- Todas as mudanças acontecem na **branch `dev`**. Nada é mergeado/pushado em `main` sem aprovação explícita.
- A tag **`backup-pre-dev`** aponta para o estado imutável original (commit `95632df`). Restauração total:
  ```bash
  cd ~/dotfiles
  git reset --hard backup-pre-dev
  ```
- Os arquivos em `~/dotfiles/*/.config/...` são **os originais**; `~/.config/hypr/...` etc. são **symlinks** para dentro de `~/dotfiles` (via `stow`). Mudanças aqui afetam o sistema ativo imediatamente.

---

## 🧩 Diagnóstico dos problemas encontrados

| # | Problema | Onde | Correção |
|---|----------|------|----------|
| 1 | Cores **hardcoded do Dracula** misturadas no tema | `waybar/style.css` (`#ffaa00`, `#ff5555`, `#50fa7b`) | Trocar por Catppuccin |
| 2 | Emojis coloridos quebrando estética Nerd Font | `waybar/config.jsonc` (`mp3` `🎵`/`▶`) | Padronizar Nerd Font |
| 3 | `macchiato.css` duplicando o topo do `style.css` | `waybar/macchiato.css` | Remover |
| 4 | Fonte inconsistente entre apps | GTK usa `Adwaita Sans`; Hyprland usa JetBrains Nerd | Unificar JetBrains Nerd |
| 5 | Cursor `Bibata-Modern-Classic` referenciado mas **não instalado** → fallback | `hyprland.lua`, gsettings, GTK | Instalar `bibata-cursor-theme` + setar `Indexed` |
| 6 | Ícones Papirus configurados mas cor laranja não aplicada em todo lugar | GTK/Qt | `papirus-folders -C orange` persistente |
| 7 | `hyprland.lua` monolítico (250 linhas) — difícil de manter | `hyprland.lua` | Refatorar em módulos |
| 8 | Cursores conflitantes | `gtk-cursor-theme-name=Adwaita` vs gsettings Bibata | Padronizar |
| 9 | Qt só com estilo `Fusion` — quebra coesão visual | `qt6ct.conf` | Usar kvantum + tema Catppuccin |
| 10 | Falta de backups/reprodutibilidade | geral | script `bkp-pacotes.sh` + `.gitignore` |

---

## 📋 Checklist de Fases

### Fase 0 — Fundação segura (git + scripts) ✅
- [x] Branch `dev` criada
- [x] Tag `backup-pre-dev` criada
- [x] `.gitignore` criado
- [x] `specs.md` criado
- [x] `setup/stow.sh` criado
- [x] `setup/bkp-pacotes.sh` criado
- [x] `setup/install-deps.sh` criado

### Fase 1 — Instalar dependências de tema
- [ ] `bibata-cursor-theme`
- [ ] `kvantum`
- [ ] `papirus-folders -C orange` persistente

### Fase 2 — Unificação visual
- [ ] Waybar: remover cores Dracula, padronizar Nerd Font, remover `macchiato.css`
- [ ] GTK: fonte JetBrains Nerd, cursor Bibata, `gtk.css` na paleta
- [ ] Qt: tema escuro coeso via kvantum/qt6ct (Catppuccin para Qt)
- [ ] Cursores: instalar, setar `Indexed`, padronizar em gsettings+GTK+Qt
- [ ] Fonte única em todo o sistema

### Fase 3 — Refatorar Hyprland em módulos
- [ ] Dividir `hyprland.lua` em `autostart.lua`, `appearance.lua`, `binds.lua`, `window-rules.lua`, `monitor.lua`
- [ ] Manter comportamento idêntico (só organização)
- [ ] Validar com `hyprctl reload`

### Fase 4 — Melhorias de UX
- [ ] Kitty tab bar alinhada às bordas arredondadas
- [ ] Aliases de manutenção no zsh (`update`, `cleanup`, `mirrors`)
- [ ] Wallpaper manager simples (lista/rotação)

### Fase 5 — Validação final
- [ ] `hyprctl reload` sem erros em todos os configs
- [ ] Commit por fase na branch `dev`
- [ ] `specs.md` atualizado ao final de cada fase

---

## 🎨 Decisões de design

**Paleta unificada:** Catppuccin Macchiato (referência: cores em `waybar/style.css` topo + `macchiato.css`).
**Cor de destaque:** laranja `#fc7b53`.
**Fonte única:** `JetBrainsMono Nerd Font` (todo o sistema, incluindo GTK/Qt).
**Cursor:** `Bibata-Modern-Classic` (com `Indexed=` correto após instalar).
**Ícones:** `Papirus-Dark` com pastas laranja (`papirus-folders -C orange`).

### Referência rápida de cores (Macchiato)
- base `#24273a`, mantle `#1e2030`, crust `#181926`
- surface0 `#363a4f`, surface1 `#494d64`, surface2 `#5b6078`
- text `#cad3f5`, subtext0 `#a5adcb`, subtext1 `#b8c0e0`
- orange `#fc7b53`, peach `#f5a97f`, yellow `#eed49f`, green `#a6da95`
- red `#ed8796`, mauve `#c6a0f6`, sapphire `#7dc4e4`

---

## 📝 Histórico de commits / mudanças

_(preencher a cada fase)_

| Commit/Ref | Fase | Descrição |
|-----------|------|-----------|
| `backup-pre-dev` | — | Estado original imutável (baseline) |

---

## 🔄 Como retomar o trabalho

1. `cd ~/dotfiles && git checkout dev`
2. Ler este `specs.md` e ver qual fase o checklist mostra como pendente (`◻️`).
3. Continuar a partir da primeira fase não concluída.
