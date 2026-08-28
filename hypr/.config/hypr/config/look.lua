-- ============================================================================
-- LOOK
-- Look and feel: general, decoration, animações, curvas, input, layouts.
-- ============================================================================

hl.config({
    general = {
        gaps_in          = 2,
        gaps_out         = 10,
        border_size      = 2,
        col              = {
            active_border   = { colors = { "rgba(fc7b53ee)", "rgba(eed49fee)" }, angle = 45 },
            inactive_border = "rgba(363a4faa)",
        },
        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding         = 12,
        rounding_power   = 2,
        active_opacity   = 0.97,
        inactive_opacity = 0.93,
        shadow           = {
            enabled      = true,
            range        = 6,
            render_power = 3,
            color        = 0xcc0a0a0a,
        },
        blur             = {
            enabled             = true,
            size                = 8,
            passes              = 3,
            vibrancy            = 0.2,
            xray                = true,
            new_optimizations   = true,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },

    input = {
        kb_layout     = "br",
        follow_mouse  = 1,
        accel_profile = "flat",
        sensitivity   = -0.3,
        touchpad      = {
            natural_scroll = false,
        },
    },
})

-- ============================================================================
-- ANIMAÇÕES
-- Curvas (bezier/spring) + folhas (`leaf`). Cada folha controla UMA transição
-- específica: `speed` = velocidade, `bezier`/`spring` = curva de easing,
-- `style` = tipo de movimento visual. Mantenha as curvas nomeadas reutilizáveis.
-- ============================================================================

-- --- Curvas ---
hl.curve("easeOutQuint",   { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } }) -- desacelera no fim → entrada suave
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } }) -- acelera e desacelera → saída/troca
hl.curve("linear",         { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })          -- sem easing → movimento constante
hl.curve("almostLinear",   { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })   -- quase linear, leve respiro no início
hl.curve("quick",          { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })     -- arranque rápido → escala/pop
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 }) -- spring das janelas

-- --- Folhas base ---
-- global: velocidade padrão herdada pelas demais folhas
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
-- windows: spring do re-layout das janelas (empurra/fecha espaço)
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
-- workspaces: fade na troca de workspace (desfaz sem ruído visual)
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

-- --- Fades (opacidade de contexto) ---
-- fadeIn/fadeOut: entrada/saída por opacidade (complementa o spring "windows")
hl.animation({ leaf = "fadeIn", enabled = true, speed = 3, bezier = "easeOutQuint" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 2, bezier = "easeInOutCubic" })
-- fadeSwitch: fade ao alternar workspace (camada antiga dissolve, nova aparece)
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 4, bezier = "easeOutQuint" })
-- fadeShadow: sombra acompanha a janela com fade (evita "pop" de sombra)
hl.animation({ leaf = "fadeShadow", enabled = true, speed = 4, bezier = "easeOutQuint" })
-- fadeDim: escurecimento da janela inativa animado (não abrupto)
hl.animation({ leaf = "fadeDim", enabled = true, speed = 4, bezier = "easeOutQuint" })

-- --- Janelas individuais ---
-- windowsIn/Out: entrada desliza suave; saída desliza com easing (nível médio)
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "easeInOutCubic", style = "slide" })
-- windowsMove: arrastar/redimensionar fluido (quase linear p/ não "puxar")
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "almostLinear" })

-- --- Borda gradiente ---
-- borderangle: gira o gradiente laranja→amarelo (active_border) ao trocar foco
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "easeInOutCubic" })
