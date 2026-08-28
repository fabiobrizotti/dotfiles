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
