hl.config({
    animations = {
        enabled = true,
    },
})

hl.curve("hyprx", {
    type = "bezier",
    points = {
        { 0.22, 1 },
        { 0.36, 1 },
    },
})

hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "hyprx", style = "popin 85%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "hyprx", style = "popin 85%" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "hyprx", style = "slide" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "default" })
