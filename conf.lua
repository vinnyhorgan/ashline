function love.conf(t)
    local Display = require("display")

    t.identity = "ashline"
    t.version = "11.5"
    t.console = false

    t.window.title = "ASHLINE"
    t.window.width = Display.window_w
    t.window.height = Display.window_h
    t.window.minwidth = Display.min_window_w
    t.window.minheight = Display.min_window_h
    t.window.resizable = true
    t.window.vsync = 1

    t.modules.audio = true
    t.modules.event = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.joystick = false
    t.modules.keyboard = true
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = false
    t.modules.sound = true
    t.modules.system = true
    t.modules.timer = true
    t.modules.window = true
    t.modules.thread = true
end
