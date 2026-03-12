local Sound = {}
Sound.__index = Sound

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
    self.loaded = false
    return self
end

function Sound:applyVolumes()
    if not self.loaded then return end
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

function Sound:load()
    local dir = "assets/sounds/"
    for i = 1, 27 do
        local name = string.format("UI_Terminal_Click_%02d.wav", i)
        local src = love.audio.newSource(dir .. name, "static")
        src:setVolume(self.ui_volume * self.master_volume)
        table.insert(self.clicks, src)
    end
    for i = 1, 15 do
        local name = string.format("UI_Error_Harsh_%02d.wav", i)
        local src = love.audio.newSource(dir .. name, "static")
        src:setVolume(self.ui_volume * self.master_volume)
        table.insert(self.errors, src)
    end
    for i = 1, 16 do
        local name = string.format("UI_Success_Chime_%02d.wav", i)
        local src = love.audio.newSource(dir .. name, "static")
        src:setVolume(self.ui_volume * self.master_volume * 0.7)
        table.insert(self.success, src)
    end
    for i = 1, 6 do
        local name = string.format("Terminal_Hum_Loop_%02d.wav", i)
        local src = love.audio.newSource(dir .. name, "stream")
        src:setLooping(true)
        src:setVolume(self.ambient_volume * self.master_volume)
        table.insert(self.hums, src)
    end
    for i = 1, 5 do
        local name = string.format("Hacking_Tension_Pulse_%02d.wav", i)
        local src = love.audio.newSource(dir .. name, "stream")
        src:setVolume(self.tension_volume * self.master_volume)
        table.insert(self.tension, src)
    end
    self.loaded = true
end

local function play_random(list)
    if #list == 0 then return end
    local src = list[love.math.random(#list)]
    src:stop()
    src:play()
    return src
end

function Sound:click()
    if not self.loaded then return end
    play_random(self.clicks)
end

function Sound:error()
    if not self.loaded then return end
    play_random(self.errors)
end

function Sound:chime()
    if not self.loaded then return end
    play_random(self.success)
end

function Sound:startAmbient()
    if not self.loaded then return end
    if self.ambient_source then self.ambient_source:stop() end
    self.ambient_source = self.hums[love.math.random(#self.hums)]
    self.ambient_source:setVolume(self.ambient_volume * self.master_volume)
    self.ambient_source:play()
end

function Sound:stopAmbient()
    if self.ambient_source then
        self.ambient_source:stop()
        self.ambient_source = nil
    end
end

function Sound:playTension()
    if not self.loaded then return end
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
