-- ============================================================================
-- HYPRLAND CONFIG - CENTRAL
-- Configuração modular (desmembrada em config/*.lua). Cada módulo é carregado
-- aqui em ordem via dofile (caminho absoluto). A tabela `hl` é global e
-- acessível em todos os módulos, assim como a tabela global PROGRAMS.
--
-- NOTA: Usamos caminho literal porque o Hyprland não expõe os.getenv.
-- ============================================================================

local cfgDir = "/home/brizotti/dotfiles/hypr/.config/hypr/config/"

-- Programas usados nos binds (define a tabela global PROGRAMS)
dofile(cfgDir .. "programs.lua")

-- Dark mode, variáveis de ambiente e autostart
dofile(cfgDir .. "appearance.lua")

-- Monitores
dofile(cfgDir .. "monitor.lua")

-- Look and feel: general, decoration, animações e curvas
dofile(cfgDir .. "look.lua")

-- Keybindings (usa PROGRAMS)
dofile(cfgDir .. "binds.lua")

-- Regras de janela
dofile(cfgDir .. "window-rules.lua")

misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    force_default_wallpaper = 0,
}

-- macOS features
hl.bind("SUPER", "grave",  "hyprswitch gui --mod-key SUPER --key grave --close mod-key-release"))

hl.curve("macStyle", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.0} } })
hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "macStyle", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 6, bezier = "macStyle", style = "popin 80%" })
hl.animation({ leaf = "fade", enabled = true, speed = 5, bezier = "macStyle" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 7, bezier = "macStyle", style = "slide" })

hl.layer_rule({ match = { namespace = "^wofi$" }, blur = true, ignore_alpha = 0.2 })
hl.layer_rule({ match = { namespace = "^swaync-control-center$" }, blur = true, ignore_alpha = 0.2 })
hl.layer_rule({ match = { namespace = "^swaync-notification-window$" }, blur = true, ignore_alpha = 0.2 })
hl.layer_rule({ match = { namespace = "^swayosd$" }, blur = true, ignore_alpha = 0.2 })
