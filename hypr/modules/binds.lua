local exec = HyprXPrograms.exec
local app = HyprXPrograms.app

-- Core applications.
hl.bind("SUPER + RETURN", app("kitty"))
hl.bind("SUPER + E", app("dolphin"))
hl.bind("SUPER + R", app([[rofi -show drun -run-command "uwsm app -- {cmd}"]]))

hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind("SUPER + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + SHIFT + C", exec("hyprpicker -a"))

-- HyprX island modes.
hl.bind("SUPER + SPACE", exec("qs -c hyprx ipc call hyprx launcher"))
hl.bind("SUPER + A", exec("qs -c hyprx ipc call hyprx launcher"))
hl.bind("SUPER + X", exec("qs -c hyprx ipc call hyprx control"))
hl.bind("SUPER + N", exec("qs -c hyprx ipc call hyprx notifications"))
hl.bind("SUPER + W", exec("qs -c hyprx ipc call hyprx wallpaper"))
hl.bind("SUPER + T", exec("qs -c hyprx ipc call hyprx theme"))
hl.bind("SUPER + M", exec("qs -c hyprx ipc call hyprx media"))
hl.bind("SUPER + SHIFT + P", exec("qs -c hyprx ipc call hyprx power"))

-- Window and workspace controls.
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + SHIFT + W", exec("hyprx-wallpaper --random"))

for i = 1, 9 do
    hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Hardware controls.
hl.bind("XF86AudioRaiseVolume", exec("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 3%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", exec("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", exec("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", exec("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", exec("playerctl previous"), { locked = true })
