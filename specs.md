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
- [x] `bibata-cursor-theme`
- [x] `kvantum` (já instalado; configurar na Fase 2)
- [x] `papirus-folders -C orange` persistente

> **Nota de instalação do bibata:** o yay parou na compilação (sem `.pkg.tar.zst`).
> Compilei manualmente via `makepkg` (dep `python-clickgen` já instalado) e instalei
> via `pacman -U --overwrite '/usr/share/icons/*' <pkg>` (registrado como
> `bibata-cursor-theme 2.0.7-1`). **Correção aplicada:** todos os 12 temas tiveram
> `Inherits="hicolor"` → `Inherits=hicolor` (sem aspas), senão o cursor não renderiza.
> gsettings já aponta para `Bibata-Modern-Classic` (via hyprland.lua autostart).

### Fase 2 — Unificação visual
- [x] Waybar: remover cores Dracula, padronizar Nerd Font, remover `macchiato.css`
- [x] GTK: fonte JetBrains Nerd, cursor Bibata, `gtk.css` na paleta
- [x] Qt: tema escuro coeso via qt6ct (`Fusion` + Papirus-Dark + JetBrains Nerd) — **decisão: manter `Fusion`** (seguro; Kvantum exige instalar tema, deixado como melhoria opcional futura para não quebrar apps Qt)
- [x] Cursores: instalado, `Indexed`/Inherits corrigido, padronizado em env+GTK (gsettings aponta Bibata)
- [x] Fonte única em todo o sistema (JetBrainsMono Nerd Font — Hyprland/Gtk/Qt)

### Fase 3 — Refatorar Hyprland em módulos
- [x] Dividir `hyprland.lua` em `autostart.lua`, `appearance.lua`, `binds.lua`, `window-rules.lua`, `monitor.lua`
- [x] Manter comportamento idêntico (só organização)
- [x] Validar com `hyprctl reload`

> **Achado importante (Fase 3):** o Hyprland **não expõe `os.getenv`** no ambiente Lua do config
> (retorna `nil`). Por isso o caminho dos módulos usa **caminho absoluto literal**
> (`/home/brizotti/dotfiles/hypr/.config/hypr/config/`). Também descobriu-se que o
> `require` não resolve para o diretório desejado → usa-se **`dofile`** com caminho literal.
> Módulos: `programs`, `appearance`, `monitor`, `look`, `binds`, `window-rules`.
> O config modular aplica **59 binds** (idêntico ao original monolítico) e as workspaces
> funcionam.

### Achado pré-existente (bug do config original)
Antes da refatoração, o Hyprland aplicava **apenas 3 binds** (config de *fallback* de exemplo),
não o config real do usuário — o que explicava o "sistema não se comporta como queria" e a
dificuldade de trocar workspaces. Com o `hyprland.lua` correto aplicando todos os binds, o
comportamento foi restaurado (59 binds → workspaces funcionando).

### Fase 4 — Melhorias de UX
- [x] Kitty: padding 12px, opacidade 0.85, `hide_window_decorations` (alinha ao README/Hyprland)
- [x] zsh: aliases de manutenção `update`, `cleanup`, `cleancache`, `bkp-pacotes`
- [x] Wallpaper: validado — hyprpaper funcional (monitor `eDP-1`, `default.jpg` 1920x1080, fallback `cover`)

### Fase 5 — Validação final
- [x] `hyprctl reload` sem erros → `ok`
- [x] Binds ativos: **59** (workspaces + apps + mídia + captura)
- [x] Workspaces: `dispatch workspace N` OK
- [x] Processos essenciais rodando: waybar, hyprpaper, swaync, swayosd-server, hypridle
- [x] gsettings coerente (Bibata, Papirus-Dark, adw-gtk3-dark)
- [x] Sem erros no log/parse do Hyprland
- [x] Commit por fase na branch `dev`; `specs.md` atualizado a cada fase

---

## 🪟 Reforma GLASS (visual "vidro" leve e bonito)

> **Sobre a numeração:** as fases de "glass" foram enumeradas durante o desenvolvimento de forma
> **irregular** — **não existem commits "Fase D" nem "Fase H"** (a revisão completa do histórico
> confirma que D foi pulada entre C→E e H entre G→I). As referências **A–I** usam a numeração
> real dos commits e **não serão renumeradas** para não quebrar o histórico/tags.

### Fase A — Hyprland glass
- [x] Blur forte (size 8, passes 3, xray), bordas fino, sombras, opacidade de janela (0.97/0.93)
- [x] Curvas de animação e cantos arredondados (rounding 12)

### Fase B — Waybar glass
- [x] Fundo mantle translúcido com blur (efeito vidro)
- [x] Workspaces em pill, limpeza do CSS (remove roxo antigo)

### Fase C — rofi-wayland glass
- [x] `config.rasi` Macchiato/laranja translúcido
- [x] Menu e clipboard via rofi (se tornou o launcher padrão)
- [x] Pacote Stow `rofi` criado e aplicado

> **⚠️ Incidente — rofi 2.0 (compatibilidade de sintaxe):** o config original usava `modi:`
> (sintaxe 1.x / fork rofi-wayland), mas o binário instalado é **rofi 2.0.0**, que renomeou para
> **`modes:`** e **ignora silenciosamente `modi:`** — resultando em rofi que não abria corretamente.
> **Corrigido:** `modi:` → `modes:` no `config.rasi`. Além disso, o **rofi 2.0 usa layer-shell**
> (abre como *layer surface* na level 3, `namespace: "rofi"`), então **regras de janela**
> (`window_rule` com `float`/`center`) **NÃO se aplicam** a ele — o dimensionamento/posição é
> controlado pelo próprio `config.rasi`. Atualize a doc/README de "rofi-wayland" → **rofi 2.0**
> para evitar reaplicar sintaxe 1.x.

### Fase E — SwayNC glass
- [x] Consolido nos dotfiles (`config.jsonc` + `style.css`), pacote Stow `swaync`

### Fase F — Hyprlock glass
- [x] Blur do fundo sincronizado (passes 3, size 8)

### Fase G — GTK4 settings
- [x] `gtk-4.0/settings.ini` versionado (fonte JetBrains Nerd + cursor Bibata coerentes)

### Fase I — Documentação + histórico
- [x] Commit que registra a reforma glass, decisões de performance e o histórico de commits

> **Pacote `wofi` descomissionado** (fase de fechamento): o launcher real é o **rofi** (mainline
> 2.0, não o fork rofi-wayland); `wofi/` foi removido do stow, do repo e do README (ver histórico Fase K).

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

## 🔍 Decisões do replanejamento (validação pós-reforma)

- **Waybar**: fundo roxo escuro `#22062b` + texto azul **mantidos** (escolha explícita do usuário; não tratado como inconsistência).
- **`dotpush`**: **mantido** com `git push` (usuário gerencia push manualmente; regra de não-push no `dev` vale para as execuções de sessão, não para o alias).
- **`gtk-4.0/` (vazio)**: removido do pacote Stow — o `~/.config/gtk-4.0` real é gerado por `nwg-look`/adw-gtk3 (symlinks externos), não pelos dotfiles.
- **QT**: mantido `style=Fusion` (seguro; Kvantum fica como melhoria opcional futura).
- **ATENÇÃO (upgrade futuro do Hyprland)**: o config usa a **API Lua (`hyprlua`/`hl.*`)**, experimental no 0.56. Ao atualizar o Hyprland, verificar compatibilidade do formato Lua; alternativa é migrar para `hyprlang` clássico se quebrar.
- **Starship**: o config ativo em `~/.config/starship.toml` **não era o do repo** (o stow do starship nunca foi/caiu — arquivo normal de config default). **Corrigido**: `~/.config/starship.toml` agora é **symlink** para `starship/.config/starship.toml` (prompt customizado em linha dupla, `❯` laranja). Backup do antigo em `/tmp/opencode/starship-bkp/`.
- **`wofi` descomissionado**: o launcher real é **rofi 2.0** (mainline); removi `wofi/` do stow (`PACKAGES`), do repo e do README.
- **zshrc**: adicionada a linha que carrega `~/.local/bin/env` (PATH do **uv**, com newline final e guard `[ -f ... ]`).
- **🔐 SENHAS TEMPORÁRIAS:** `brizotti` e `root` estão com senha `031222` (restaurada via docker/chroot durante incidente). **TROCAR O QUANTO ANTES.**

---

## 📝 Histórico de commits / mudanças

_(preencher a cada fase)_

| Commit/Ref | Fase | Descrição |
|-----------|------|-----------|
| `backup-pre-dev` | — | Estado original imutável (baseline) |
| `c8fb328` | 0 | Fundação segura: branch `dev`, tag, specs.md, scripts setup |
| `9c6d8b9` | docs | Registra incidente de acesso root e senhas temporárias |
| `9dcd96b` | 2 | Waybar: cores Catppuccin, Nerd Font, remove macchiato.css |
| `6c1cacd` | 1 | bibata-cursor-theme movido para lista AUR |
| `667d00f` | 2 | GTK: fonte JetBrains Nerd + cursor Bibata (GTK-2/3) |
| `73b872f` | 3 | Hyprland modular via `dofile` (config/*.lua) |
| `a4ad637` | 1 | Bibata compilado manualmente + `pacman -U` + Inherits corrigido |
| `d808cc1` | 2 | Qt mantém Fusion; cursores Bibata instalados |
| `2b889df` | 4 | zsh: aliases de manutenção `update`/`cleanup`/`cleancache`/`bkp-pacotes` |
| `f8c5d56` | 4 | kitty: padding 12px, opacidade 0.85, hide_window_decorations |
| `f32ba9f` | 0 | Checkpoint de reversão (tag, snapshot `/etc` network, bkp swaync, lista de pacotes) |
| `e0d7678` | A | Hyprland glass: blur forte, bordas, sombras, opacidade de janela |
| `f525e29` | B | Waybar glass: fundo mantle translúcido + blur, workspaces pill, limpa CSS |
| `a278c5a` | C | rofi-wayland glass: config.rasi, binds/programs via rofi, pacote Stow `rofi` |
| `5701bdb` | E | SwayNC: consolida no Stow (`config.jsonc` + `style.css`) |
| `334c72f` | F | Hyprlock: blur do fundo sincronizado (passes 3, size 8) |
| `61811ca` | G | GTK4: settings.ini versionado (fonte/cursor coerentes) |
| `a81c48a` | I | Documenta reforma glass + performance e histórico de commits |
| `f2aef39` | J | Declara PATH do uv no zshrc + adiciona AGENTS.md (contexto da sessão) |
| `153d4c8` | K | Descomissiona wofi (rofi é o launcher), remove do stow e atualiza README+AGENTS |
| `020c660` | docs | Documenta load absoluto do hypr/config e remove wofi dos PACKAGES no AGENTS |

---

## 🔄 Como retomar o trabalho

1. `cd ~/dotfiles && git checkout dev`
2. Ler este `specs.md` e ver qual fase o checklist mostra como pendente (`◻️`).
3. Continuar a partir da primeira fase não concluída.
