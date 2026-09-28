-- ============================================================================
-- WINDOW RULES
-- Regras de janela (opacidade, flutuantes, eventos).
-- ============================================================================

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
