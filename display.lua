local Display = {}

Display.virtual_w = 1440
Display.virtual_h = 800

Display.window_w = Display.virtual_w
Display.window_h = Display.virtual_h

Display.min_window_h = 500
Display.min_window_w = math.floor(Display.min_window_h * (Display.virtual_w / Display.virtual_h) + 0.5)

return Display
