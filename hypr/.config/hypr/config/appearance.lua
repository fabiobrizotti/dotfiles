-- ============================================================================
-- APPEARANCE
-- Dark mode, variáveis de ambiente (GTK/Qt/cursores) e autostart.
-- ============================================================================

-- DARK MODE
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
  -- Monitor térmico (temp-watch.sh, pacote localbin) — alerta SwayNC 85C/90C
  hl.exec_cmd("temp-watch")
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
