local Sound = {}
Sound.__index = Sound

local STARTUP_BATCH_SIZE = 5
local UPDATE_BATCH_SIZE = 3

function Sound.new()
    local self = setmetatable({}, Sound)
    self.clicks = {}
    self.errors = {}
    self.success = {}
    self.hums = {}
    self.tension = {}
    self.ambient_source = nil
    self.master_volume = 0.7
    self.ui_volume = 0.3
    self.ambient_volume = 0.15
    self.tension_volume = 0.25
    self.load_queue = {}
    self.pending_ambient_start = false
    self.loaded = false
    return self
end

function Sound:applyVolumes()
    for _, src in ipairs(self.clicks) do
        src:setVolume(self.ui_volume * self.master_volume)
    end
    for _, src in ipairs(self.errors) do
        src:setVolume(self.ui_volume * self.master_volume)
    end
    for _, src in ipairs(self.success) do
        src:setVolume(self.ui_volume * self.master_volume * 0.7)
    end
    for _, src in ipairs(self.hums) do
        src:setVolume(self.ambient_volume * self.master_volume)
    end
    for _, src in ipairs(self.tension) do
        src:setVolume(self.tension_volume * self.master_volume)
    end
    if self.ambient_source then
        self.ambient_source:setVolume(self.ambient_volume * self.master_volume)
    end
end

function Sound:setMix(master, ui, ambient, tension)
    if master ~= nil then self.master_volume = master end
    if ui ~= nil then self.ui_volume = ui end
    if ambient ~= nil then self.ambient_volume = ambient end
    if tension ~= nil then self.tension_volume = tension end
    self:applyVolumes()
end

local function queue_source(self, target, path, kind, opts)
    table.insert(self.load_queue, {
        target = target,
        path = path,
        kind = kind,
        looping = opts and opts.looping or false,
        volume = opts and opts.volume or function(sound)
            return sound.master_volume
        end,
    })
end

function Sound:beginLoad()
    if #self.load_queue > 0 or self.loaded then
        return
    end

    local dir = "assets/sounds/"

    for i = 1, 4 do
        queue_source(self, self.clicks, dir .. string.format("UI_Terminal_Click_%02d.wav", i), "static", {
            volume = function(sound)
                return sound.ui_volume * sound.master_volume
            end,
        })
    end

    queue_source(self, self.hums, dir .. "Terminal_Hum_Loop_01.wav", "stream", {
        looping = true,
        volume = function(sound)
            return sound.ambient_volume * sound.master_volume
        end,
    })

    for i = 5, 27 do
        queue_source(self, self.clicks, dir .. string.format("UI_Terminal_Click_%02d.wav", i), "static", {
            volume = function(sound)
                return sound.ui_volume * sound.master_volume
            end,
        })
    end
    for i = 2, 6 do
        queue_source(self, self.hums, dir .. string.format("Terminal_Hum_Loop_%02d.wav", i), "stream", {
            looping = true,
            volume = function(sound)
                return sound.ambient_volume * sound.master_volume
            end,
        })
    end
    for i = 1, 16 do
        queue_source(self, self.success, dir .. string.format("UI_Success_Chime_%02d.wav", i), "static", {
            volume = function(sound)
                return sound.ui_volume * sound.master_volume * 0.7
            end,
        })
    end
    for i = 1, 15 do
        queue_source(self, self.errors, dir .. string.format("UI_Error_Harsh_%02d.wav", i), "static", {
            volume = function(sound)
                return sound.ui_volume * sound.master_volume
            end,
        })
    end
    for i = 1, 5 do
        queue_source(self, self.tension, dir .. string.format("Hacking_Tension_Pulse_%02d.wav", i), "stream", {
            volume = function(sound)
                return sound.tension_volume * sound.master_volume
            end,
        })
    end
end

function Sound:loadBatch(count)
    local remaining = count or 1
    while remaining > 0 and #self.load_queue > 0 do
        local item = table.remove(self.load_queue, 1)
        local src = love.audio.newSource(item.path, item.kind)
        src:setVolume(item.volume(self))
        if item.looping then
            src:setLooping(true)
        end
        table.insert(item.target, src)
        remaining = remaining - 1
    end

    self.loaded = #self.load_queue == 0
    if self.pending_ambient_start and not self.ambient_source and #self.hums > 0 then
        self:startAmbient()
    end
end

function Sound:updateLoading()
    if #self.load_queue == 0 then
        self.loaded = true
        return
    end

    self:loadBatch(UPDATE_BATCH_SIZE)
end

function Sound:load()
    self:beginLoad()
    self:loadBatch(#self.load_queue > 0 and #self.load_queue or STARTUP_BATCH_SIZE)
end

local function play_random(list)
    if #list == 0 then return end
    local src = list[love.math.random(#list)]
    src:stop()
    src:play()
    return src
end

function Sound:click()
    play_random(self.clicks)
end

function Sound:error()
    play_random(self.errors)
end

function Sound:chime()
    play_random(self.success)
end

function Sound:startAmbient()
    if #self.hums == 0 then
        self.pending_ambient_start = true
        return
    end

    self.pending_ambient_start = false
    if self.ambient_source then self.ambient_source:stop() end
    self.ambient_source = self.hums[love.math.random(#self.hums)]
    self.ambient_source:setVolume(self.ambient_volume * self.master_volume)
    self.ambient_source:play()
end

function Sound:stopAmbient()
    self.pending_ambient_start = false
    if self.ambient_source then
        self.ambient_source:stop()
        self.ambient_source = nil
    end
end

function Sound:playTension()
    play_random(self.tension)
end

function Sound:stopAll()
    self:stopAmbient()
    for _, src in ipairs(self.clicks) do src:stop() end
    for _, src in ipairs(self.errors) do src:stop() end
    for _, src in ipairs(self.success) do src:stop() end
    for _, src in ipairs(self.tension) do src:stop() end
end

return Sound
