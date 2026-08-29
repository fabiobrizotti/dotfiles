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

> **Vela de retorno ao `wofi`** (decisão pós-Fase K): o rofi 2.0 mainline (instalado na máquina) tem um **parser de tema reescrito** que rejeita parte relevante da sintaxe `.rasi` 1.x/rofi-wayland (`matching`, refs `@var`, `border solid`, `alpha()`, `rgba` decimal) — o launcher abria com "Error while parsing theme" apesar de `modes:` correto. Para evitar migrar todo o bloco de tema e a incerteza de `window_rule` (rofi 2.0 é layer-shell), **voltei para o `wofi`** (que sempre funcionou e usa `config` + `style.css`, sem parser problemático). Detalhes no histórico abaixo.

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
- **Launcher = `wofi` (revivido)**: o rofi 2.0 mainline quebra o parse do tema `.rasi` legado. **Revertido** do rofi de volta para o **wofi**: `wofi/` restaurado no stow (`PACKAGES`), repo e README; `menu`/`dmenu` em `programs.lua` apontam para `wofi`; pacote `rofi/` removido do stow e do repo.
- **zshrc**: adicionada a linha que carrega `~/.local/bin/env` (PATH do **uv**, com newline final e guard `[ -f ... ]`).
- **Auditoria de boot (pré-reboot)**: aplicado `RequiredForOnline=no` em `/etc/systemd/network/20-wlan.network` (via docker/chroot; backup `20-wlan.network.bak-20260828-190919`). O `20-ethernet.network` já tinha o fix, mas o usuário usa **Wi-Fi**, então o `systemd-networkd-wait-online` atrasava **~2min por boot** (`2min 256ms` confirmado via `systemd-analyze blame`). Heap o efeito só após reboot. Achados benignos não-bloqueantes na auditoria: ACPI/USB `AE_ALREADY_EXISTS` (firmware), `regulatory.db` cfg80211, docker/containerd cni, swaync tenta importar `libadwaita.css`/`libadwaita-tweaks.css` inexistentes. Pendência não-bloqueante: `rclone-gdrive` (user service) falha com token Google expirado (`rclone config reconnect gdrive:`); `rclone-icloud` OK.
- **🔐 SENHAS TEMPORÁRIAS:** `brizotti` e `root` estão com senha `031222` (restaurada via docker/chroot durante incidente). **TROCAR O QUANTO ANTES.**

---

## 🪟 Reforma Waybar — altura + UX (2026-08-28)

> **Objetivo:** corrigir desproporção visual da barra (muito baixa) e das pills dos
> workspaces, além de adicionar animação suave de troca de workspace.

**Mudanças em `waybar/.config/waybar/style.css`:**
- **Altura:** barra de ~22px → **36px** (`window#waybar` padding `6px 12px` + `min-height: 36px`; `.modules-*` `min-height: 32px`).
- **Fontes proporcionais:** base global `13px` no `*`; `#custom-icon` 16px (logo); `#workspaces` 11px; ícone da bateria 14px. Antes tudo estava inflado/desproporcional.
- **Pills dos workspaces menores com respiro:** `padding: 0 8px`, `border-radius: 10px` (12px no ativo), `margin: 0 2px` — não mais grudadas na linha laranja de baixo nem no topo da tela.
- **Transição suave de troca:** `transition: background/color/border-radius 0.3s ease` nas pills → crossfade suave de cor entre workspaces (a antiga volta a laranja-claro enquanto a nova fica laranja-crust).

> **⚠️ Limitação do parser GTK CSS do waybar:** **`transform`/`scale` NÃO são propriedades válidas** no waybar (erro `'transform' is not a valid property name`). Portanto **não é possível** um indicador de workspace que "desliza" lateralmente via CSS puro. Efeitos testados e descartados: `transform` (inválido), glow/`box-shadow` + `@keyframes` na pill ativa (causava "apagar e acender", não era contínuo). Solução final adotada = **crossfade de cor** via `transition` (Opção A), que é suave e limpo. Um deslize real exigiria módulo custom com script (mais complexo/frágil) — deixado como melhoria futura não-bloqueante.

---

## 🎬 Fase Animações — Hyprland + Waybar (2026-08-28)

> **Objetivo:** dar vida ao WM e fechar o design system (raio, alfa, elevação,
> semântica de cor) com micro-interações modernas. Nível de animação: **médio**.
>
> **Nota de numeração:** as "Etapas A/B/C + encerramento" desta seção são uma
> série nova e **independente** da numeração "glass" A–I acima (as antigas
> Fases D e H de glass realmente não existem — ver nota da seção GLASS).

### Fase A — Hyprland: animações ✅
- `look.lua`: ativadas as folhas que estavam em default/off usando as **curvas já
  definidas** (easeOutQuint, easeInOutCubic, almostLinear):
  - `fadeIn/fadeOut/fadeSwitch/fadeShadow/fadeDim` (fades de contexto)
  - `windowsIn/Out` com `style = "slide"` (entrada/saída que deslizam)
  - `windowsMove` (arrastar fluido, almostLinear)
  - `borderangle` (gradiente laranja→amarelo gira ao trocar foco)
- Comentários pt-BR por folha ("o que influencia"). Bloco reorganizado por concern.
- **Validação:** `luac -p` ok, `hyprctl reload` → `ok`, **9 folhas `enabled: 1`**
  (windowsIn/Out slide aplicado), binds **49** intactos.

### Fase B — Waybar: micro-polimento ✅
- Tooltip com linguagem glass (raio 10, borda laranja alpha 0.4, fundo crust 0.95).
- Hover das pills elevado (`surface1` 0.55 → **0.7**) — affordance de "clicável".
- `#mpris`: pill com borda verde + `box-shadow` sutil (elevação); estado `paused`
  zera borda/sombra. `transform/scale` segue bloqueado pelo parser GTK (mantido).
- `transition: all 0.3s` agora consistente também em `#custom-icon` e `#tray`.
- Clean code: bloco `#battery` **deduplicado** (era definido 2x) e comentado por estado.
- **Validação:** restart do waybar limpo (CSS parseado sem erro, barra 1920×36).

### Fase C — Waybar: barra flutuante "pill" ✅
- `config.jsonc`: `margin-top/left/right: 8px` → barra desprendida das bordas
  (largura medida: **1904px** = 1920 − 16 de margens).
- `style.css`: `border-radius: 14px` (ecoa o raio das janelas) + `border: 1px
  alpha(@orange,0.4)` em toda a volta (substituiu a `border-bottom` full-width).
- Traspassado de profundidade: canto transparente deixa ver wallpaper (sem blur
  ali, esperado); mouse passa por cima das margens (layer-shell respeita bounds).
- **Validação:** restart limpo, CSS ok, barra 1904×36.

### Pendências adiadas (registradas — próxima rodada)
- **◻️ D** wofi: janela centralizada + transições/scrollbar
- **◻️ E** swaync: accent bar laranja + vida no painel (widget-dnd/switch/estado vazio)
- **◻️ F** kitty: `cursor_trail`, `background_tint`, cores de `mark`
- **◻️ G** hyprlock: `fade_in` de entrada (verificar suporte na versão)
- **◻️ Opcional futuro:** `hyprland-plugins` (hyprbars), `matugen`/`wallust`
  (paleta dinâmica do wallpaper), script externo p/ borda girando continuamente.

---

## 🌡️ Controle Térmico + Alertas SwayNC (2026-08-28)

> **Objetivo:** proteger a CPU (Intel i3-1115G4, Tiger Lake) contra superaquecimento
> com segurança térmica automática + alertas visuais, e centralizar tudo nos dotfiles.

### Decisão de abordagem: **Trilha A** (throttling de CPU), **sem controle manual de ventoinha**
- **Hardware:** laptop, `intel_pstate` ativo, **sem chip PWM** → `fancontrol`/`pwmconfig`
  **não têm efeito** (confirmado: nenhum `pwm*`/`fan*_input` em hwmon; ventoinhas são
  `cooling_device` ACPI **on/off binário**, `max_state=1`). Controle manual de ventoinha
  descartado.
- **Solução:** `thermald` (daemon Intel de throttling) + `auto-cpufreq` (governor adaptativo
  por carga/energia/temperatura). Ambos **complementares**: thermald throttla por temp,
  auto-cpufreq ajusta o governor.
- **Descartados (evitar):** `power-profiles-daemon` e `tlp` (conflitariam com auto-cpufreq).
- **Governor atual:** `performance` (gerido pelo auto-cpufreq, que faz throttling por baixo).

### Daemons instalados/ativos
| Pacote | Origem | Estado | Validação |
|--------|--------|--------|-----------|
| `thermald` (2.5.12) | pacman | active (`--adaptive`) | `systemctl is-active thermald` |
| `auto-cpufreq` (3.1.0) | AUR/yay | active (daemon) | `auto-cpufreq --stats` |

Instalados manualmente na sessão; registrados em `setup/install-deps.sh` / `bkp-pacotes.sh`.

### Alerta térmico — `temp-watch` (pacote Stow `localbin`)
- **Arquivo:** `localbin/.local/bin/temp-watch` (binário **sem extensão** para o PATH do
  Hyprland resolver) → symlink `~/.local/bin/temp-watch`.
- **Limiares (configuráveis por env):** `ALERT=85°C` (notificação normal), `CRIT=90°C`
  (notificação crítica). Teto de segurança bem abaixo do crit Intel de 100°C.
- **Lógica:** lê `temp1_input` do `coretemp-isa-0000` via `sensors -u`. Debounce por
  **subida de estado** (normal→alta→crítica) + **histerese de 3°C** para não spammar.
- **Notificação:** `notify-send` (interceptado pelo SwayNC; nenhuma mudança no swaync).
- **Agendamento:** autostart via `hl.exec_cmd("temp-watch")` no bloco `hyprland.start` do
  `appearance.lua` → roda junto da sessão gráfica e **morre com ela** (comportamento correto).
  Não duplica no `hyprctl reload` (o bloco `start` só roda no login).
- **Achado importante:** o PATH do processo Hyprland já inclui `/home/brizotti/.local/bin`
  (confirmado via `/proc/<pid>/environ`), então `temp-watch` resolve sem caminho absoluto.

### Como validar
- `temp-watch --once` → imprime a temp do pacote e limiares.
- `systemctl is-active thermald auto-cpufreq` → ambos `active`.
- `auto-cpufreq --stats` → governor/temp/carga.
- `sensors` (coretemp) → temperatura real.
- `hyprctl reload` → `ok`; binds **49**; `decoration:blur:size=8`, `passes=3`.

### 🔐 Pedência de segurança (herdada)
- **TROCAR AS SENHAS TEMPORÁRIAS `031222`** (brizotti e root) o quanto antes.

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
| `47bf5dc` | fix | Reverte launcher: rofi → **wofi** (rofi 2.0 quebra parse de tema); restaura `wofi/`, atualiza programs/stow/README/AGENTS |
| `63bf80c` | waybar | Altura + UX: barra 22px → **36px**, fontes proporcionais (base 13px), pills dos workspaces menores com respiro (raio 10/12, padding 0-8px, margin 2px) e transição suave de cor na troca de workspace |
| `c018fd6` | A | Animações médias: ativa fadeIn/Out/Switch/Shadow/Dim, windowsIn/Out (`slide`), windowsMove, borderangle — 9 folhas `enabled: 1`, binds 49 intactos |
| `10d68d6` | B | Waybar micro-polimento: tooltip glass, hover de pill elevado, #mpris com borda verde + elevação, transições padronizadas (0.3s), dedupe do #battery |
| `3de1e69` | C | Waybar barra flutuante "pill": margens 8px + border-radius 14px + borda completa sutil (largura medida 1904px) |
| `e1aab38` | termo | `temp-watch` (pacote Stow `localbin`): script de monitor térmico + alertas SwayNC 85C/90C; stow/README/AGENTS/.gitignore |
| `3e40e4f` | termo | Inicia `temp-watch` no autostart do Hyprland (appearance.lua); renomeia para binário sem `.sh` p/ PATH do Hyprland resolver |

---

## 🔄 Como retomar o trabalho

1. `cd ~/dotfiles && git checkout dev`
2. Ler este `specs.md` e ver qual fase o checklist mostra como pendente (`◻️`).
3. Continuar a partir da primeira fase não concluída.
