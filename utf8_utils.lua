local utf8 = require("utf8")

local M = {}

function M.len(s)
    if not s then return 0 end
    local ok, len = pcall(utf8.len, s)
    if ok then return len end
    return #s
end

function M.sub(s, i, j)
    s = s or ""
    i = math.max(1, i or 1)

    local start_byte = utf8.offset(s, i)
    if not start_byte then return "" end

    local end_byte
    if j then
        if j < i then return "" end
        end_byte = utf8.offset(s, j + 1)
        if end_byte then end_byte = end_byte - 1 else end_byte = #s end
    else
        end_byte = #s
    end

    return s:sub(start_byte, end_byte)
end

return M
