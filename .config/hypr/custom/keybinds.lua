hl.bind("CTRL+SUPER+ALT+Slash", hl.dsp.exec_cmd("xdg-open ~/.config/hypr/custom/keybinds.lua"), {description = "Edit user keybinds"} )


-- Screenshots (grim + slurp)
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'), {description = "Screenshot region to clipboard"})
hl.bind("SHIFT + Print", hl.dsp.exec_cmd('grim ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png'), {description = "Screenshot full screen to file"})
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png'), {description = "Screenshot region to file"})