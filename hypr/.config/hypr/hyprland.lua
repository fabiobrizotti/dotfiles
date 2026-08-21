-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- HYPRLAND CONFIG - OPTIMIZED                           --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

------------------
---- DARK MODE ---
------------------
hl.on("hyprland.start", function () 
  -- Temas GTK e Preferência Escura
  hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark"')
  hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')
  hl.exec_cmd('gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"')
  hl.exec_cmd('gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Classic"')
  hl.exec_cmd('gsettings set org.gnome.desktop.interface cursor-size 24')
  
  -- Autostart dos processos essenciais
  hl.exec_cmd("waybar")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("swayosd-server")
  hl.exec_cmd("swaync")
  hl.exec_cmd("hypridle")
  -- Autostart Clipboard Watcher
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)

-- Variáveis de Ambiente para GTK, Qt e Cursores
hl.env("GTK_THEME", "adw-gtk3-dark")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("HYPRCURSOR_SIZE", "24")
------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "",
    mode     = "1920x1080@60",
    position = "auto",
    scale    = "1",
})

---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local fileManager = "nemo"
local menu        = "wofi --show drun"
local spotify     = "spotify"
local browser     = "firefox"

-----------------------
---- LOOK AND FEEL ----
-----------------------

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
        rounding         = 10,
        rounding_power   = 2,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow           = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },
        blur             = {
            enabled  = true,
            size     = 6,
            passes   = 2,
            vibrancy = 0.1696,
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

--------------------
---- ANIMATIONS ----
--------------------

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- Apps Binds
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Escape", hl.dsp.window.close())
hl.bind("ALT + Tab", hl.dsp.window.cycle_next())
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("kitty --class impala-float -e impala"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("blueman-manager"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | wofi --dmenu --prompt 'Histórico de Cópia...' | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(spotify))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + C",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- Focus Binds
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Workspaces
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + M", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.window.move({ workspace = "special:magic" }))

-- Mouse Binds
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

------------------------------------------
---- TECLAS DE MÍDIA E BRILHO (SWAYOSD) --
------------------------------------------

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"), { locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness raise"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"),
    { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

------------------------------------------
---- TECLAS DE CAPTURA DE TELA (PRINT) ---
------------------------------------------

-- PrintScreen simples: Selecionar uma área e copiar para a Área de Transferência
hl.bind("PRINT", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))

-- SHIFT + PrintScreen: Selecionar uma área e salvar na pasta de Imagens
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("grim -g \"$(slurp)\" ~/Imagens/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png"))

-- SUPER + PrintScreen: Capturar a TELA INTEIRA e copiar para a Área de Transferência
hl.bind("SUPER + PRINT", hl.dsp.exec_cmd("grim - | wl-copy"))

--------------------------------
---- WINDOW RULES --------------
--------------------------------

hl.window_rule({
    name = "kitty-opacity",
    match = { class = "^(kitty)$" },
    opacity = "0.85 0.85",
})

hl.window_rule({
    name = "vscode-opacity",
    match = { class = "^([Cc]ode|code-oss|code-url-handler)$" },
    opacity = "0.85 0.85",
})

hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})
hl.window_rule({
    name = "impala-floating",
    match = { class = "^(impala-float)$" },
    float = true,
    size = "750 450",
    center = true,
})

hl.window_rule({
    name = "blueman-floating",
    match = { class = "^(blueman-manager)$" },
    float = true,
    size = "650 400",
    center = true,
})
