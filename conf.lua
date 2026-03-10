function love.conf(t)
    t.identity = "ashline"
    t.version = "11.4"
    t.console = false

    t.window.title = "ASHLINE"
    t.window.width = 1280
    t.window.height = 800
    t.window.minwidth = 800
    t.window.minheight = 500
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
