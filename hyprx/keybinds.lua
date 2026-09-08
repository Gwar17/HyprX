
local exec = hl.dsp.exec_cmd

-- Core
hl.bind('SUPER + RETURN', exec('kitty'))
hl.bind('SUPER + Q', hl.dsp.window.close())

--HyprX
hl.bind('SUPER + A', exec('qs -c hyprx ipc call hyprx launcher'))
hl.bind('SUPER + X', exec('qs -c hyprx ipc call hyprx control'))
hl.bind('SUPER + F', exec('qs -c hyprx ipc call hyprx files'))
hl.bind('SUPER + V', exec('qs -c hyprx ipc call hyprx clipboard'))
hl.bind('SUPER + N', exec('qs -c hyprx ipc call hyprx notifications'))
hl.bind('SUPER + W', exec('qs -c hyprx ipc call hyprx wallpaper'))

--Wallpaper
hl.bind('SUPER + SHIFT + W', exec('hyprx-wallpaper --random'))

--Media
hl.bind('XF86AudioRaiseVolume', exec('wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%+'), { locked=true, repeating=true })
hl.bind('XF86AudioLowerVolume', exec('wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-'), { locked=true, repeating=true })
hl.bind('XF86AudioMute', exec('wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'), { locked=true })
hl.bind('XF86MonBrightnessUp', exec('brightnessctl set +5%'), { locked=true, repeating=true })
hl.bind('XF86MonBrightnessDown', exec('brightnessctl set 5%-'), { locked=true, repeating=true })

