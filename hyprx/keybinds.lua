local exec = hl.dsp.exec_cmd

-- Core applications
hl.bind('SUPER + RETURN', exec('kitty'))
hl.bind('SUPER + E', exec('dolphin'))
hl.bind('SUPER + R', exec('rofi -show drun'))
hl.bind('SUPER + Q', hl.dsp.window.close())
hl.bind('SUPER + F', exec('hyprctl dispatch fullscreen 1'))
hl.bind('SUPER + SHIFT + SPACE', exec('hyprctl dispatch togglefloating'))
hl.bind('SUPER + SHIFT + C', exec("hyprpicker -a"))

-- HyprX island modes
hl.bind('SUPER + SPACE', exec('qs -c hyprx ipc call hyprx launcher'))
hl.bind('SUPER + A', exec('qs -c hyprx ipc call hyprx launcher'))
hl.bind('SUPER + X', exec('qs -c hyprx ipc call hyprx control'))
hl.bind('SUPER + N', exec('qs -c hyprx ipc call hyprx notifications'))
hl.bind('SUPER + W', exec('qs -c hyprx ipc call hyprx wallpaper'))
hl.bind('SUPER + T', exec('qs -c hyprx ipc call hyprx theme'))
hl.bind('SUPER + M', exec('qs -c hyprx ipc call hyprx media'))
hl.bind('SUPER + SHIFT + P', exec('qs -c hyprx ipc call hyprx power'))

-- Wallpaper convenience
hl.bind('SUPER + SHIFT + W', exec('hyprx-wallpaper --random'))

-- Workspaces
for i = 1, 9 do
    hl.bind('SUPER + ' .. i, exec('hyprctl dispatch workspace ' .. i))
    hl.bind('SUPER + SHIFT + ' .. i, exec('hyprctl dispatch movetoworkspace ' .. i))
end

-- Hardware controls
hl.bind('XF86AudioRaiseVolume', exec('wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 3%+'), { locked=true, repeating=true })
hl.bind('XF86AudioLowerVolume', exec('wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-'), { locked=true, repeating=true })
hl.bind('XF86AudioMute', exec('wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'), { locked=true })
hl.bind('XF86MonBrightnessUp', exec('brightnessctl set +5%'), { locked=true, repeating=true })
hl.bind('XF86MonBrightnessDown', exec('brightnessctl set 5%-'), { locked=true, repeating=true })
