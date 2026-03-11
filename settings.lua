local Settings = {}

Settings.defaults = {
    fullscreen = false,
    post_effects = true,
    master_volume = 0.7,
    ui_volume = 0.3,
    ambient_volume = 0.15,
    tension_volume = 0.25,
    text_speed = 180,
}

local FILE_NAME = "settings.cfg"

local function clone_defaults()
    local copy = {}
    for key, value in pairs(Settings.defaults) do
        copy[key] = value
    end
    return copy
end

local function parse_value(raw, default)
    if type(default) == "boolean" then
        return raw == "true"
    end
    if type(default) == "number" then
        local num = tonumber(raw)
        return num or default
    end
    return raw
end

function Settings.clamp(values)
    values.master_volume = math.min(1, math.max(0, values.master_volume or Settings.defaults.master_volume))
    values.ui_volume = math.min(1, math.max(0, values.ui_volume or Settings.defaults.ui_volume))
    values.ambient_volume = math.min(1, math.max(0, values.ambient_volume or Settings.defaults.ambient_volume))
    values.tension_volume = math.min(1, math.max(0, values.tension_volume or Settings.defaults.tension_volume))

    local speeds = {60, 120, 180, 300, 600}
    local chosen = speeds[3]
    local target = values.text_speed or Settings.defaults.text_speed
    local best_diff = math.huge
    for _, speed in ipairs(speeds) do
        local diff = math.abs(speed - target)
        if diff < best_diff then
            best_diff = diff
            chosen = speed
        end
    end
    values.text_speed = chosen

    if values.fullscreen == nil then values.fullscreen = Settings.defaults.fullscreen end
    if values.post_effects == nil then values.post_effects = Settings.defaults.post_effects end

    return values
end

function Settings.load()
    local values = clone_defaults()
    if not love or not love.filesystem then
        return values
    end

    local info = love.filesystem.getInfo(FILE_NAME)
    if not info then
        return values
    end

    local raw = love.filesystem.read(FILE_NAME)
    if not raw then
        return values
    end

    for line in raw:gmatch("[^\r\n]+") do
        local key, value = line:match("^([%w_]+)=(.+)$")
        if key and Settings.defaults[key] ~= nil then
            values[key] = parse_value(value, Settings.defaults[key])
        end
    end

    return Settings.clamp(values)
end

function Settings.save(values)
    if not love or not love.filesystem then
        return false
    end

    values = Settings.clamp(values)
    local lines = {}
    for key in pairs(Settings.defaults) do
        table.insert(lines, key .. "=" .. tostring(values[key]))
    end
    table.sort(lines)
    return love.filesystem.write(FILE_NAME, table.concat(lines, "\n"))
end

return Settings
