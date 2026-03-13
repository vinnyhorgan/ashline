local colors = require("colors")

local utf8_utils = require("utf8_utils")
local utf8_sub = utf8_utils.sub
local utf8_len = utf8_utils.len

local Terminal = {}
Terminal.__index = Terminal

local MARGIN_X = 20
local MARGIN_Y = 12
local HEADER_LINES = 2
local STATUS_LINES = 1
local INPUT_LINES = 1

local function wrap_segments(segments, cols)
    if cols <= 0 then return {{}} end
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

function Terminal.new(font, font_bold, width, height)
    local self = setmetatable({}, Terminal)
    self.font = font
    self.font_bold = font_bold or font
    self.char_w = math.max(1, font:getWidth("A"))
    self.char_h = math.max(1, font:getHeight())

    self.width = width or love.graphics.getWidth()
    self.height = height or love.graphics.getHeight()
    self.offset_x = 0
    self.offset_y = 0
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
    self.typewriter_queue_head = 1
    self.typewriter_queue_tail = 0
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
    if self.cols > 110 then self.cols = 110 end
    self.total_rows = math.floor((self.height - MARGIN_Y * 2) / self.char_h)
    self.content_rows = self.total_rows - HEADER_LINES - STATUS_LINES - INPUT_LINES - 3
    if self.content_rows > 24 then self.content_rows = 24 end
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
    self.input_cursor = cursor_pos or utf8_len(text)
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
        self.typewriter_queue_tail = self.typewriter_queue_tail + 1
        self.typewriter_queue[self.typewriter_queue_tail] = entry
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
        self.typewriter_queue_tail = self.typewriter_queue_tail + 1
        self.typewriter_queue[self.typewriter_queue_tail] = entry
    end
end

function Terminal:isTyping()
    return self.typewriter_queue_head <= self.typewriter_queue_tail
end

function Terminal:flushTypewriter()
    for i = self.typewriter_queue_head, self.typewriter_queue_tail do
        local raw = self.typewriter_queue[i]
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
    self.typewriter_queue_head = 1
    self.typewriter_queue_tail = 0
    self:scrollToBottom()
end

function Terminal:clear()
    self.displayed_raw = {}
    self.output = {}
    self.typewriter_queue = {}
    self.typewriter_queue_head = 1
    self.typewriter_queue_tail = 0
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

    if self.typewriter_queue_head <= self.typewriter_queue_tail then
        self.typewriter_acc = self.typewriter_acc + self.typewriter_speed * dt
        while self.typewriter_acc >= 1 and self.typewriter_queue_head <= self.typewriter_queue_tail do
            self.typewriter_acc = self.typewriter_acc - 1
            local raw = self.typewriter_queue[self.typewriter_queue_head]
            self.typewriter_queue[self.typewriter_queue_head] = nil
            self.typewriter_queue_head = self.typewriter_queue_head + 1
            if self.typewriter_queue_head > self.typewriter_queue_tail then
                self.typewriter_queue_head = 1
                self.typewriter_queue_tail = 0
            end
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
    love.graphics.push()
    love.graphics.translate(self.offset_x, self.offset_y)
    love.graphics.setFont(self.font)

    local t = love.timer.getTime()
    local w = self.width
    local h = self.height
    local x0 = MARGIN_X
    local breathe = 1.0 + 0.06 * math.sin(t * 1.0)
    local sep_w = w - MARGIN_X * 2

    -- Background
    love.graphics.setColor(colors.bg)
    love.graphics.rectangle("fill", 0, 0, w, h)

    -- === FRAME ===
    -- Outer border
    love.graphics.setColor(colors.border[1], colors.border[2], colors.border[3], 0.35 * breathe)
    love.graphics.rectangle("line", 0, 0, w, h)
    -- Inner border (subtle double-line)
    love.graphics.setColor(colors.border[1], colors.border[2], colors.border[3], 0.12 * breathe)
    love.graphics.rectangle("line", 3, 3, w - 6, h - 6)

    -- Corner brackets
    local cl = 18
    love.graphics.setLineWidth(2)
    love.graphics.setColor(colors.cyan[1], colors.cyan[2], colors.cyan[3], 0.45 * breathe)
    love.graphics.line(0, 0, cl, 0)
    love.graphics.line(0, 0, 0, cl)
    love.graphics.line(w, 0, w - cl, 0)
    love.graphics.line(w, 0, w, cl)
    love.graphics.line(0, h, cl, h)
    love.graphics.line(0, h, 0, h - cl)
    love.graphics.line(w, h, w - cl, h)
    love.graphics.line(w, h, w, h - cl)
    love.graphics.setLineWidth(1)

    -- Vertical rail accents
    love.graphics.setColor(colors.cyan[1], colors.cyan[2], colors.cyan[3], 0.035)
    love.graphics.rectangle("fill", 4, cl, 2, h - cl * 2)
    love.graphics.rectangle("fill", w - 6, cl, 2, h - cl * 2)

    -- Beacon dots
    local bp = 0.35 + 0.3 * math.sin(t * 2.5)
    love.graphics.setColor(colors.cyan[1], colors.cyan[2], colors.cyan[3], bp)
    love.graphics.circle("fill", 9, 9, 2.5)
    love.graphics.setColor(colors.header[1], colors.header[2], colors.header[3], 0.3 + 0.2 * math.sin(t * 2.1 + 1))
    love.graphics.circle("fill", 17, 9, 2.5)

    -- === HEADER SECTION ===
    local y = MARGIN_Y
    local header_h = self.char_h * HEADER_LINES

    -- Header background fill
    love.graphics.setColor(colors.very_dim[1], colors.very_dim[2], colors.very_dim[3], 0.18)
    love.graphics.rectangle("fill", 1, 1, w - 2, MARGIN_Y + header_h)
    -- Header left accent bar
    love.graphics.setColor(colors.cyan[1], colors.cyan[2], colors.cyan[3], 0.55)
    love.graphics.rectangle("fill", 1, 1, 3, MARGIN_Y + header_h)
    -- Header gradient overlay
    love.graphics.setColor(colors.cyan[1], colors.cyan[2], colors.cyan[3], 0.025)
    love.graphics.rectangle("fill", 4, 1, math.floor(w * 0.3), MARGIN_Y + header_h)

    if #self.header_segments > 0 then
        draw_segments(self.header_segments, x0, y, self.font)
    end
    y = y + header_h

    -- Header separator with animated sweep
    local sep_y = y + math.floor(self.char_h / 2)
    love.graphics.setColor(colors.border)
    love.graphics.rectangle("fill", x0, sep_y, sep_w, 1)
    local sweep_x = (t * 45) % math.max(1, sep_w)
    love.graphics.setColor(colors.cyan[1], colors.cyan[2], colors.cyan[3], 0.18)
    love.graphics.rectangle("fill", x0 + sweep_x, sep_y, math.min(35, sep_w - sweep_x), 1)
    love.graphics.setColor(colors.cyan[1], colors.cyan[2], colors.cyan[3], 0.05)
    love.graphics.rectangle("fill", x0, sep_y + 1, math.floor(sep_w * 0.4), 1)
    y = y + self.char_h

    -- === CONTENT AREA ===
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
        love.graphics.rectangle("fill", x0, ind_y, sep_w, self.char_h)
        local scroll_pulse = 0.7 + 0.3 * math.sin(t * 2.5)
        love.graphics.setColor(colors.amber[1], colors.amber[2], colors.amber[3], scroll_pulse)
        local indicator = string.format("v %d more lines below v  (Page Down / Scroll)", self.scroll_offset)
        love.graphics.print(indicator, self.font, x0, ind_y)
    end

    -- === STATUS BAR ===
    local status_y = content_start_y + self.content_rows * self.char_h

    -- Status separator with sweep
    local sep2_y = status_y + math.floor(self.char_h / 2)
    love.graphics.setColor(colors.border)
    love.graphics.rectangle("fill", x0, sep2_y, sep_w, 1)
    local sweep2_x = ((t * 35 + 200) % math.max(1, sep_w))
    love.graphics.setColor(colors.cyan[1], colors.cyan[2], colors.cyan[3], 0.15)
    love.graphics.rectangle("fill", x0 + sweep2_x, sep2_y, math.min(30, sep_w - sweep2_x), 1)
    love.graphics.setColor(colors.cyan[1], colors.cyan[2], colors.cyan[3], 0.05)
    love.graphics.rectangle("fill", x0, sep2_y + 1, math.floor(sep_w * 0.4), 1)
    status_y = status_y + self.char_h

    -- Status bar background
    love.graphics.setColor(colors.very_dim[1], colors.very_dim[2], colors.very_dim[3], 0.12)
    love.graphics.rectangle("fill", 1, status_y - 3, w - 2, self.char_h + 6)
    -- Status left accent bar (amber)
    love.graphics.setColor(colors.amber[1], colors.amber[2], colors.amber[3], 0.4)
    love.graphics.rectangle("fill", 1, status_y - 3, 3, self.char_h + 6)

    if #self.status_segments > 0 then
        draw_segments(self.status_segments, x0, status_y, self.font)
    end
    status_y = status_y + self.char_h

    -- Input separator
    local sep3_y = status_y + math.floor(self.char_h / 2)
    love.graphics.setColor(colors.border)
    love.graphics.rectangle("fill", x0, sep3_y, sep_w, 1)
    love.graphics.setColor(colors.cyan[1], colors.cyan[2], colors.cyan[3], 0.05)
    love.graphics.rectangle("fill", x0, sep3_y + 1, math.floor(sep_w * 0.4), 1)
    status_y = status_y + self.char_h

    -- === INPUT LINE ===
    if self.show_input then
        -- Input area background
        love.graphics.setColor(colors.very_dim[1], colors.very_dim[2], colors.very_dim[3], 0.06)
        love.graphics.rectangle("fill", 1, status_y - 2, w - 2, self.char_h + 4)

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

        -- cursor with glow
        if self.cursor_visible then
            local cursor_x = input_x + self.font:getWidth(utf8_sub(self.input_text, 1, self.input_cursor))
            love.graphics.setColor(colors.bright[1], colors.bright[2], colors.bright[3], 0.08)
            love.graphics.rectangle("fill", cursor_x - 3, status_y - 2, self.char_w * 0.8 + 6, self.char_h + 4)
            love.graphics.setColor(colors.bright)
            love.graphics.rectangle("fill", cursor_x, status_y, self.char_w * 0.8, self.char_h)
        end
    end

    -- === AMBIENT SCAN LINE (full terminal height) ===
    local total_h = h - MARGIN_Y * 2
    if total_h > 0 then
        local scan_period = 6.0
        local scan_progress = (t % scan_period) / scan_period
        local scan_line_y = MARGIN_Y + total_h * scan_progress
        love.graphics.setColor(colors.text[1], colors.text[2], colors.text[3], 0.02)
        love.graphics.rectangle("fill", 1, scan_line_y, w - 2, 1)
        love.graphics.setColor(colors.text[1], colors.text[2], colors.text[3], 0.01)
        love.graphics.rectangle("fill", 1, scan_line_y - 4, w - 2, 8)
    end

    love.graphics.pop()
end

return Terminal
