local json = require("json")

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

local FILE_NAME = "settings.json"
local LEGACY_FILE_NAME = "settings.cfg"

local function clone_defaults()
    local copy = {}
    for key, value in pairs(Settings.defaults) do
        copy[key] = value
    end
    return copy
end

local function merge_known_keys(values)
    local merged = clone_defaults()
    if type(values) ~= "table" then
        return merged
    end

    for key in pairs(Settings.defaults) do
        if values[key] ~= nil then
            merged[key] = values[key]
        end
    end
    return merged
end

local function parse_legacy(raw)
    local values = clone_defaults()
    for line in (raw or ""):gmatch("[^\r\n]+") do
        local key, value = line:match("^([%w_]+)=(.+)$")
        if key and Settings.defaults[key] ~= nil then
            local default = Settings.defaults[key]
            if type(default) == "boolean" then
                values[key] = (value == "true")
            elseif type(default) == "number" then
                values[key] = tonumber(value) or default
            else
                values[key] = value
            end
        end
    end
    return values
end

function Settings.clamp(values)
    values = merge_known_keys(values)

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
    if info then
        local raw = love.filesystem.read(FILE_NAME)
        if raw then
            local ok, decoded = pcall(json.decode, raw)
            if ok and type(decoded) == "table" then
                return Settings.clamp(decoded)
            end
        end
        return values
    end

    local legacy_info = love.filesystem.getInfo(LEGACY_FILE_NAME)
    if not legacy_info then
        return values
    end

    local raw = love.filesystem.read(LEGACY_FILE_NAME)
    if not raw then
        return values
    end

    values = Settings.clamp(parse_legacy(raw))
    Settings.save(values)
    love.filesystem.remove(LEGACY_FILE_NAME)
    return values
end

function Settings.save(values)
    if not love or not love.filesystem then
        return false
    end

    values = Settings.clamp(values)
    local encoded = json.encode(values)
    local ok = love.filesystem.write(FILE_NAME, encoded)
    if not ok then
        return false
    end

    local raw = love.filesystem.read(FILE_NAME)
    if not raw then
        return false
    end

    local decoded_ok, decoded = pcall(json.decode, raw)
    if not decoded_ok or type(decoded) ~= "table" then
        return false
    end

    return true
end

return Settings
