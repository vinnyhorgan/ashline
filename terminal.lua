local colors = require("colors")

local Terminal = {}
Terminal.__index = Terminal

local MARGIN_X = 20
local MARGIN_Y = 12
local HEADER_LINES = 2
local STATUS_LINES = 1
local INPUT_LINES = 1

local utf8 = require("utf8")

local function utf8_sub(s, i, j)
    local start_byte = utf8.offset(s, i)
    if not start_byte then return "" end
    local end_byte
    if j then
        end_byte = utf8.offset(s, j + 1)
        if end_byte then end_byte = end_byte - 1 else end_byte = #s end
    else
        end_byte = #s
    end
    return s:sub(start_byte, end_byte)
end

local function utf8_len(s)
    local ok, len = pcall(utf8.len, s)
    if ok then return len end
    return #s
end

local function wrap_segments(segments, cols)
    local lines = {}
    local current_line = {}
    local current_col = 0

    for _, seg in ipairs(segments) do
        local text = seg.text or ""
        local color = seg.color or colors.text
        local remaining = text

        while utf8_len(remaining) > 0 do
            local space_left = cols - current_col
            if space_left <= 0 then
                table.insert(lines, current_line)
                current_line = {}
                current_col = 0
                space_left = cols
            end

            local rem_len = utf8_len(remaining)
            local chunk, rest
            if rem_len <= space_left then
                chunk = remaining
                rest = ""
            else
                chunk = utf8_sub(remaining, 1, space_left)
                rest = utf8_sub(remaining, space_left + 1)
            end

            if utf8_len(rest) > 0 then
                local wrap_at = chunk:match(".*() ")
                local chunk_len = utf8_len(chunk)
                if wrap_at then
                    local char_wrap = utf8_len(chunk:sub(1, wrap_at))
                    if char_wrap < chunk_len and char_wrap > math.floor(space_left * 0.3) then
                        rest = utf8_sub(chunk, char_wrap + 1) .. rest
                        chunk = utf8_sub(chunk, 1, char_wrap)
                    end
                end
            end

            table.insert(current_line, {text = chunk, color = color})
            current_col = current_col + utf8_len(chunk)
            remaining = rest
        end
    end

    if #current_line > 0 or #lines == 0 then
        table.insert(lines, current_line)
    end

    return lines
end

function Terminal.new(font, font_bold)
    local self = setmetatable({}, Terminal)
    self.font = font
    self.font_bold = font_bold or font
    self.char_w = font:getWidth("A")
    self.char_h = font:getHeight()

    local ww, wh = love.graphics.getDimensions()
    self.width = ww
    self.height = wh
    self:recalcLayout()

    self.displayed_raw = {}
    self.output = {}
    self.scroll_offset = 0
    self.header_segments = {}
    self.status_segments = {}
    self.input_text = ""
    self.input_cursor = 0
    self.ghost_text = ""
    self.cursor_visible = true
    self.cursor_timer = 0
    self.show_input = false

    self.typewriter_queue = {}
    self.typewriter_speed = 1200
    self.typewriter_acc = 0
    self.typewriter_sound_interval = 4
    self.typewriter_sound_counter = 0
    self.on_click = nil
    self.skip_typewriter = false

    return self
end

function Terminal:recalcLayout()
    self.cols = math.floor((self.width - MARGIN_X * 2) / self.char_w)
    self.total_rows = math.floor((self.height - MARGIN_Y * 2) / self.char_h)
    self.content_rows = self.total_rows - HEADER_LINES - STATUS_LINES - INPUT_LINES - 3
    if self.content_rows < 1 then self.content_rows = 1 end
end

function Terminal:resize(w, h)
    self.width = w
    self.height = h
    local old_cols = self.cols
    self:recalcLayout()
    if self.cols ~= old_cols then
        self:rewrap()
    end
end

function Terminal:rewrap()
    self.output = {}
    for _, raw in ipairs(self.displayed_raw) do
        if raw.is_blank then
            table.insert(self.output, {})
        else
            local wrapped = wrap_segments(raw.segments, self.cols)
            for _, line in ipairs(wrapped) do
                table.insert(self.output, line)
            end
        end
    end
    self.scroll_offset = 0
end

function Terminal:getCols()
    return self.cols
end

function Terminal:setHeader(segments)
    self.header_segments = segments
end

function Terminal:setStatus(segments)
    self.status_segments = segments
end

function Terminal:setInput(text, cursor_pos)
    self.input_text = text
    self.input_cursor = cursor_pos or #text
end

function Terminal:setGhost(text)
    self.ghost_text = text or ""
end

function Terminal:showInput(show)
    self.show_input = show
end

function Terminal:setTypewriterSpeed(cps)
    self.typewriter_speed = cps
end

function Terminal:addSegments(segments, instant)
    local entry = {segments = segments, is_blank = false}
    if instant or self.skip_typewriter then
        table.insert(self.displayed_raw, entry)
        local wrapped = wrap_segments(segments, self.cols)
        for _, line in ipairs(wrapped) do
            table.insert(self.output, line)
        end
        self:scrollToBottom()
    else
        table.insert(self.typewriter_queue, entry)
    end
end

function Terminal:addLine(text, color, instant)
    self:addSegments({{text = text or "", color = color or colors.text}}, instant)
end

function Terminal:addBlank(instant)
    local entry = {is_blank = true}
    if instant or self.skip_typewriter then
        table.insert(self.displayed_raw, entry)
        table.insert(self.output, {})
        self:scrollToBottom()
    else
        table.insert(self.typewriter_queue, entry)
    end
end

function Terminal:isTyping()
    return #self.typewriter_queue > 0
end

function Terminal:flushTypewriter()
    for _, raw in ipairs(self.typewriter_queue) do
        table.insert(self.displayed_raw, raw)
        if raw.is_blank then
            table.insert(self.output, {})
        else
            local wrapped = wrap_segments(raw.segments, self.cols)
            for _, line in ipairs(wrapped) do
                table.insert(self.output, line)
            end
        end
    end
    self.typewriter_queue = {}
    self:scrollToBottom()
end

function Terminal:clear()
    self.displayed_raw = {}
    self.output = {}
    self.typewriter_queue = {}
    self.scroll_offset = 0
end

function Terminal:scrollUp(amount)
    amount = amount or 3
    local max_scroll = math.max(0, #self.output - self.content_rows)
    self.scroll_offset = math.min(self.scroll_offset + amount, max_scroll)
end

function Terminal:scrollDown(amount)
    amount = amount or 3
    self.scroll_offset = math.max(0, self.scroll_offset - amount)
end

function Terminal:scrollToBottom()
    self.scroll_offset = 0
end

function Terminal:update(dt)
    self.cursor_timer = self.cursor_timer + dt
    if self.cursor_timer >= 0.53 then
        self.cursor_timer = self.cursor_timer - 0.53
        self.cursor_visible = not self.cursor_visible
    end

    if #self.typewriter_queue > 0 then
        self.typewriter_acc = self.typewriter_acc + self.typewriter_speed * dt
        while self.typewriter_acc >= 1 and #self.typewriter_queue > 0 do
            self.typewriter_acc = self.typewriter_acc - 1
            local raw = table.remove(self.typewriter_queue, 1)
            table.insert(self.displayed_raw, raw)

            if raw.is_blank then
                table.insert(self.output, {})
            else
                local wrapped = wrap_segments(raw.segments, self.cols)
                for _, line in ipairs(wrapped) do
                    table.insert(self.output, line)
                end
            end
            self:scrollToBottom()

            self.typewriter_sound_counter = self.typewriter_sound_counter + 1
            if self.typewriter_sound_counter >= self.typewriter_sound_interval then
                self.typewriter_sound_counter = 0
                if self.on_click then
                    local has_text = false
                    if not raw.is_blank and raw.segments then
                        for _, seg in ipairs(raw.segments) do
                            if seg.text and #seg.text > 0 and seg.text:match("%S") then
                                has_text = true
                                break
                            end
                        end
                    end
                    if has_text then self.on_click() end
                end
            end
        end
    end
end

local function draw_segments(segments, x, y, font)
    local cx = x
    for _, seg in ipairs(segments) do
        love.graphics.setColor(seg.color or colors.text)
        love.graphics.print(seg.text or "", font, cx, y)
        cx = cx + font:getWidth(seg.text or "")
    end
end

function Terminal:render()
    love.graphics.setFont(self.font)

    love.graphics.setColor(colors.bg)
    love.graphics.rectangle("fill", 0, 0, self.width, self.height)

    local x0 = MARGIN_X
    local y = MARGIN_Y

    -- header
    if #self.header_segments > 0 then
        draw_segments(self.header_segments, x0, y, self.font)
    end
    y = y + self.char_h * HEADER_LINES

    -- separator after header
    love.graphics.setColor(colors.border)
    local sep_str = string.rep("─", self.cols)
    love.graphics.print(sep_str, self.font, x0, y)
    y = y + self.char_h

    -- content area
    local content_start_y = y
    local visible_start = math.max(1, #self.output - self.content_rows - self.scroll_offset + 1)
    local visible_end = math.min(#self.output, visible_start + self.content_rows - 1)

    for i = visible_start, visible_end do
        local line = self.output[i]
        if line and #line > 0 then
            draw_segments(line, x0, y, self.font)
        end
        y = y + self.char_h
    end

    -- scroll indicator
    if self.scroll_offset > 0 then
        local ind_y = content_start_y + (self.content_rows - 1) * self.char_h
        love.graphics.setColor(colors.bg)
        love.graphics.rectangle("fill", x0, ind_y, self.width - MARGIN_X * 2, self.char_h)
        love.graphics.setColor(colors.amber)
        local indicator = string.format("v %d more lines below v  (Page Down / Scroll)", self.scroll_offset)
        love.graphics.print(indicator, self.font, x0, ind_y)
    end

    -- separator before status
    local status_y = content_start_y + self.content_rows * self.char_h
    love.graphics.setColor(colors.border)
    love.graphics.print(sep_str, self.font, x0, status_y)
    status_y = status_y + self.char_h

    -- status bar
    if #self.status_segments > 0 then
        draw_segments(self.status_segments, x0, status_y, self.font)
    end
    status_y = status_y + self.char_h

    -- separator before input
    love.graphics.setColor(colors.border)
    love.graphics.print(sep_str, self.font, x0, status_y)
    status_y = status_y + self.char_h

    -- input line
    if self.show_input then
        love.graphics.setColor(colors.prompt)
        love.graphics.print("> ", self.font, x0, status_y)
        local input_x = x0 + self.char_w * 2

        love.graphics.setColor(colors.input_text)
        love.graphics.print(self.input_text, self.font, input_x, status_y)

        -- ghost autocomplete
        if #self.ghost_text > 0 and #self.input_text > 0 then
            local ghost_x = input_x + self.font:getWidth(self.input_text)
            love.graphics.setColor(colors.ghost)
            love.graphics.print(self.ghost_text, self.font, ghost_x, status_y)
        end

        -- cursor
        if self.cursor_visible then
            local cursor_x = input_x + self.font:getWidth(self.input_text:sub(1, self.input_cursor))
            love.graphics.setColor(colors.bright)
            love.graphics.rectangle("fill", cursor_x, status_y, self.char_w * 0.8, self.char_h)
        end
    end
end

return Terminal
