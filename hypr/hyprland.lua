-- HyprX default Hyprland Lua configuration.
-- Existing user hyprland.lua files are preserved by install.sh; this file is used only when none exists.

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 10,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 0.96,
        shadow = {
            enabled = true,
            range = 18,
            render_power = 3,
            color = 0x66000000,
        },
        blur = {
            enabled = true,
            size = 7,
            passes = 2,
            vibrancy = 0.08,
        },
    },
    animations = { enabled = true },
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
        },
    },
    dwindle = {
        pseudotile = true,
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
})

hl.curve("hyprx", { type = "bezier", points = { {0.22, 1}, {0.36, 1} } })
hl.animation({ leaf = "windows",    enabled = true, speed = 4, bezier = "hyprx", style = "popin 85%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "hyprx", style = "popin 85%" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "hyprx", style = "slide" })
hl.animation({ leaf = "fade",       enabled = true, speed = 3, bezier = "default" })

-- HYPRX:BEGIN
dofile(os.getenv("HOME") .. "/.config/hypr/hyprx/colors.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/hyprx/keybinds.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/hyprx/autostart.lua")
-- HYPRX:END
