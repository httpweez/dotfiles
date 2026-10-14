-- Keyboard layout override
hl.config({
    input = {
        kb_layout = "br",
        kb_model = "abnt2",
        numlock_by_default = true,
        repeat_delay = 250,
        repeat_rate = 35,

        follow_mouse = 1,
        off_window_axis_events = 2,

        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
            clickfinger_behavior = true,
            scroll_factor = 0.7
        }
    }
})

-- Transparency (opacity) for windows
hl.config({
    decoration = {
        active_opacity = 0.92,
        inactive_opacity = 0.77,
        blur = {
            enabled = true,
            xray = true,
            size = 6,
            passes = 2,
            noise = 0.03,
            contrast = 0.89,
            vibrancy = 0.3
        }
    }
})