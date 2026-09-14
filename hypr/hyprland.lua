-- HyprX Hyprland configuration.
-- Current Lua architecture; each module owns one configuration concern.

local modules = os.getenv("HOME") .. "/.config/hypr/modules/"

dofile(modules .. "env.lua")
dofile(modules .. "monitors.lua")
dofile(modules .. "input.lua")
dofile(modules .. "layout.lua")
dofile(modules .. "decorations.lua")
dofile(modules .. "animations.lua")
dofile(modules .. "misc.lua")
dofile(modules .. "colors.lua")
dofile(modules .. "windowrules.lua")
dofile(modules .. "programs.lua")
dofile(modules .. "binds.lua")
dofile(modules .. "autostart.lua")
