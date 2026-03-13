local Display = {}

Display.virtual_w = 1440
Display.virtual_h = 800

Display.min_scale = 0.85
Display.min_window_w = math.floor(Display.virtual_w * Display.min_scale + 0.5)
Display.min_window_h = math.floor(Display.virtual_h * Display.min_scale + 0.5)
Display.window_w = Display.min_window_w
Display.window_h = Display.min_window_h

return Display
