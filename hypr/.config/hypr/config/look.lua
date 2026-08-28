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

-- ANIMAÇÕES (curvas)
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
