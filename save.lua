local json = require("json")

local Save = {}

Save.FORMAT = "ASHLINE_SAVE"
Save.VERSION = 1
Save.SLOT = "autosave"

local function adler32(str)
    local mod = 65521
    local a = 1
    local b = 0
    for i = 1, #str do
        a = (a + str:byte(i)) % mod
        b = (b + a) % mod
    end
    return string.format("%08x", b * 65536 + a)
end

local function love_fs()
    if not love or not love.filesystem then
        return nil
    end

    return {
        read = function(path)
            return love.filesystem.read(path)
        end,
        write = function(path, content)
            return love.filesystem.write(path, content)
        end,
        exists = function(path)
            return love.filesystem.getInfo(path) ~= nil
        end,
        remove = function(path)
            if love.filesystem.getInfo(path) then
                return love.filesystem.remove(path)
            end
            return true
        end,
    }
end

local function native_fs()
    return {
        read = function(path)
            local file = io.open(path, "rb")
            if not file then return nil end
            local content = file:read("*a")
            file:close()
            return content
        end,
        write = function(path, content)
            local file = io.open(path, "wb")
            if not file then return false end
            local ok = file:write(content)
            file:close()
            return ok ~= nil
        end,
        exists = function(path)
            local file = io.open(path, "rb")
            if file then
                file:close()
                return true
            end
            return false
        end,
        remove = function(path)
            os.remove(path)
            return true
        end,
    }
end

local function get_fs(custom_fs)
    return custom_fs or love_fs() or native_fs()
end

local function paths(slot)
    slot = slot or Save.SLOT
    return {
        current = slot .. ".save.json",
        backup = slot .. ".save.bak",
        temp = slot .. ".save.tmp",
    }
end

local function pack(payload)
    local payload_json = json.encode(payload)
    local wrapper = {
        format = Save.FORMAT,
        version = Save.VERSION,
        checksum = adler32(payload_json),
        payload = payload_json,
    }
    return json.encode(wrapper)
end

local function unpack_blob(blob)
    local ok, wrapper = pcall(json.decode, blob)
    if not ok or type(wrapper) ~= "table" then
        return nil, "Invalid save wrapper."
    end
    if wrapper.format ~= Save.FORMAT then
        return nil, "Unexpected save format."
    end
    if wrapper.version ~= Save.VERSION then
        return nil, "Unsupported save version."
    end
    if type(wrapper.payload) ~= "string" then
        return nil, "Malformed save payload."
    end
    if wrapper.checksum ~= adler32(wrapper.payload) then
        return nil, "Save checksum mismatch."
    end

    local payload_ok, payload = pcall(json.decode, wrapper.payload)
    if not payload_ok or type(payload) ~= "table" then
        return nil, "Invalid save payload."
    end
    return payload
end

local function read_valid(path, fs)
    local blob = fs.read(path)
    if not blob then
        return nil, "Missing save."
    end
    return unpack_blob(blob)
end

function Save.exists(slot, custom_fs)
    local fs = get_fs(custom_fs)
    local p = paths(slot)
    return fs.exists(p.current) or fs.exists(p.backup)
end

function Save.getMetadata(slot, custom_fs)
    local fs = get_fs(custom_fs)
    local p = paths(slot)

    local payload = read_valid(p.current, fs)
    if payload then
        return {
            source = "current",
            saved_at = payload.saved_at,
            chapter = payload.game and payload.game.chapter,
        }
    end

    payload = read_valid(p.backup, fs)
    if payload then
        return {
            source = "backup",
            saved_at = payload.saved_at,
            chapter = payload.game and payload.game.chapter,
        }
    end

    return nil
end

function Save.save(slot, payload, custom_fs)
    local fs = get_fs(custom_fs)
    local p = paths(slot)
    local wrapped = pack(payload)

    if not fs.write(p.temp, wrapped) then
        return false, "Failed to write temporary save file."
    end

    local temp_payload, temp_err = read_valid(p.temp, fs)
    if not temp_payload then
        fs.remove(p.temp)
        return false, "Temporary save verification failed: " .. temp_err
    end

    if fs.exists(p.current) then
        local current_blob = fs.read(p.current)
        if current_blob then
            fs.write(p.backup, current_blob)
        end
    end

    if not fs.write(p.current, wrapped) then
        fs.remove(p.temp)
        return false, "Failed to write primary save file."
    end

    local current_payload, current_err = read_valid(p.current, fs)
    if not current_payload then
        fs.remove(p.temp)
        return false, "Primary save verification failed: " .. current_err
    end

    fs.remove(p.temp)
    return true
end

function Save.load(slot, custom_fs)
    local fs = get_fs(custom_fs)
    local p = paths(slot)

    local payload, err = read_valid(p.current, fs)
    if payload then
        return payload, "current"
    end

    local backup_payload, backup_err = read_valid(p.backup, fs)
    if backup_payload then
        local wrapped = pack(backup_payload)
        fs.write(p.current, wrapped)
        return backup_payload, "backup"
    end

    return nil, err or backup_err or "No save available."
end

function Save.delete(slot, custom_fs)
    local fs = get_fs(custom_fs)
    local p = paths(slot)
    fs.remove(p.current)
    fs.remove(p.backup)
    fs.remove(p.temp)
    return true
end

return Save
