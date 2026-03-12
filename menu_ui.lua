local MenuUI = {}
MenuUI.__index = MenuUI

local MENU_FRAME_INSET = 78
local PANEL_HEADER_H = 38

local PAUSE_OPTIONS = {
    "RESUME",
    "SETTINGS",
    "RESTART SESSION",
    "QUIT TO TITLE",
}

local SETTINGS_OPTIONS = {
    {key = "fullscreen", label = "Fullscreen", kind = "bool"},
    {key = "post_effects", label = "Post Effects", kind = "bool"},
    {key = "master_volume", label = "Master Volume", kind = "number", step = 0.05, min = 0, max = 1},
    {key = "ui_volume", label = "UI Volume", kind = "number", step = 0.05, min = 0, max = 1},
    {key = "ambient_volume", label = "Ambient Volume", kind = "number", step = 0.05, min = 0, max = 1},
    {key = "tension_volume", label = "Tension Volume", kind = "number", step = 0.05, min = 0, max = 1},
    {key = "text_speed", label = "Text Speed", kind = "enum", values = {60, 120, 180, 300, 600}},
    {label = "Back", kind = "action"},
}

local function clamp(value, min_value, max_value)
    return math.max(min_value, math.min(max_value, value))
end

local function smoothToward(current, target, speed, dt)
    if current == target then
        return target
    end
    return current + (target - current) * (1 - math.exp(-speed * dt))
end

local function hitTestItems(x, y, items)
    for i, item in ipairs(items or {}) do
        if x >= item.x and x <= item.x + item.w and y >= item.y and y <= item.y + item.h then
            return i
        end
    end
    return nil
end

local function stackPush(cursor_y, height, gap)
    local y = cursor_y
    return y, cursor_y + height + (gap or 0)
end

function MenuUI.new(opts)
    local self = setmetatable({}, MenuUI)
    self.colors = assert(opts.colors, "colors is required")
    self.Save = assert(opts.Save, "Save is required")
    self.font = assert(opts.font, "font is required")
    self.font_bold = assert(opts.font_bold, "font_bold is required")
    self.font_large = assert(opts.font_large, "font_large is required")
    self.font_title = assert(opts.font_title, "font_title is required")
    self.get_viewport = assert(opts.get_viewport, "get_viewport is required")
    self.get_virtual_size = assert(opts.get_virtual_size, "get_virtual_size is required")
    self.get_settings = assert(opts.get_settings, "get_settings is required")
    self.get_settings_return_state = assert(opts.get_settings_return_state, "get_settings_return_state is required")
    self.get_save_notice = assert(opts.get_save_notice, "get_save_notice is required")
    self.get_save_metadata = assert(opts.get_save_metadata, "get_save_metadata is required")
    self.on_title_select = assert(opts.on_title_select, "on_title_select is required")
    self.on_pause_select = assert(opts.on_pause_select, "on_pause_select is required")
    self.on_adjust_setting = assert(opts.on_adjust_setting, "on_adjust_setting is required")
    self.on_close_settings = assert(opts.on_close_settings, "on_close_settings is required")
    self.on_click = opts.on_click
    self.render_terminal_overlay = opts.render_terminal_overlay

    self.title_index = 1
    self.pause_index = 1
    self.settings_index = 1
    self.menu_hover = {
        title = nil,
        settings = nil,
        pause = nil,
    }
    self.menu_anim = {
        title = {},
        settings = {},
        pause = {},
    }
    self.mouse_state = {
        tracked = false,
        x = 0,
        y = 0,
        inside = false,
    }

    if love and love.mouse then
        self.cursor_arrow = love.mouse.getSystemCursor("arrow")
        self.cursor_hand = love.mouse.getSystemCursor("hand")
        self.cursor_current = self.cursor_arrow
        love.mouse.setCursor(self.cursor_arrow)
    end

    return self
end

function MenuUI:getPauseOptions()
    return PAUSE_OPTIONS
end

function MenuUI:getSettingsOptions()
    return SETTINGS_OPTIONS
end

function MenuUI:getTitleOptions()
    local options = {}
    if self.Save.exists() then
        table.insert(options, "CONTINUE SESSION")
    end
    table.insert(options, "NEW SESSION")
    table.insert(options, "SETTINGS")
    table.insert(options, "QUIT")
    return options
end

function MenuUI:getTitleOptionMeta(option)
    if option == "CONTINUE SESSION" then
        return {
            code = "ROUTE-01",
            title = "Resume recovered session",
            body = "Restore the last validated autosave and return to the active terminal.",
        }
    elseif option == "NEW SESSION" then
        return {
            code = "ROUTE-02",
            title = "Initialize fresh terminal",
            body = "Start from boot and overwrite the current autosave slot.",
        }
    elseif option == "SETTINGS" then
        return {
            code = "ROUTE-03",
            title = "Adjust local runtime",
            body = "Tune fullscreen, effects, audio mix, and text speed.",
        }
    end

    return {
        code = "ROUTE-04",
        title = "Terminate process",
        body = "Close the client and leave the archive sealed until the next shift.",
    }
end

function MenuUI:getRhythmUnit()
    return math.max(6, math.floor(self.font:getHeight() * 0.5))
end

function MenuUI:getTokens()
    local unit = self:getRhythmUnit()
    return {
        unit = unit,
        frame_inset = MENU_FRAME_INSET,
        panel_header_h = PANEL_HEADER_H,
        panel_pad_x = unit * 2 + 2,
        panel_pad_y = unit * 2,
        section_gap = math.floor(unit * 1.8),
        block_gap = math.floor(unit * 1.2),
        line_gap = math.floor(unit * 0.45),
        menu_row_h = self.font:getHeight() + math.floor(unit * 1.15),
        menu_row_gap = self.font:getHeight() + math.floor(unit * 1.55),
        footer_gap = math.floor(unit * 2.4),
    }
end

function MenuUI:measureMaxWidth(items, active_font, value_getter)
    local widest = 0
    for i, item in ipairs(items) do
        local text = value_getter and value_getter(item, i) or item
        widest = math.max(widest, active_font:getWidth(tostring(text or "")))
    end
    return widest
end

function MenuUI:getWrappedTextHeight(active_font, text, width)
    local _, wrapped = active_font:getWrap(text, width)
    return math.max(1, #wrapped) * active_font:getHeight()
end

function MenuUI:buildListLayout(panel_x, panel_y, panel_w, item_count, active_font, opts)
    opts = opts or {}

    local unit = self:getRhythmUnit()
    local header_h = opts.header_h or PANEL_HEADER_H
    local inner_pad_x = opts.inner_pad_x or math.floor(unit * 1.75)
    local top_pad = opts.top_pad or math.floor(unit * 2.25)
    local bottom_pad = opts.bottom_pad or math.floor(unit * 2.25)
    local row_h = opts.row_h or (active_font:getHeight() + math.floor(unit * 1.15))
    local row_gap = opts.row_gap or (row_h + math.floor(unit * 0.85))
    local row_w = panel_w - inner_pad_x * 2
    local start_y = panel_y + header_h + top_pad
    local items = {}

    for i = 1, item_count do
        items[i] = {
            index = i,
            x = panel_x + inner_pad_x,
            y = start_y + (i - 1) * row_gap,
            w = row_w,
            h = row_h,
        }
    end

    local content_h = top_pad + bottom_pad
    if item_count > 0 then
        content_h = content_h + row_h + (item_count - 1) * row_gap
    end

    return {
        panel = {
            x = panel_x,
            y = panel_y,
            w = panel_w,
            h = header_h + content_h,
        },
        items = items,
    }
end

function MenuUI:buildTitleLayout(w, h)
    local t = self:getTokens()
    local unit = t.unit
    local left = t.frame_inset + unit * 4
    local top = t.frame_inset - math.floor(unit * 0.25)
    local title_options = self:getTitleOptions()

    local description_y = top + self.font_title:getHeight() + math.floor(unit * 1.6)
    local description_gap = self.font:getHeight() + math.floor(unit * 0.35)
    local tagline_y = description_y + description_gap * 2 + math.floor(unit * 0.8)
    local access_y = tagline_y + self.font:getHeight() + math.floor(unit * 0.9)
    local separator_y = access_y + self.font:getHeight() + math.floor(unit * 1.2)

    local menu_w = math.max(340, self:measureMaxWidth(title_options, self.font) + unit * 14)
    local menu_y = separator_y + math.floor(unit * 2.4)
    local menu = self:buildListLayout(left, menu_y, menu_w, #title_options, self.font, {
        inner_pad_x = math.floor(unit * 1.4),
        top_pad = math.floor(unit * 2.1),
        bottom_pad = math.floor(unit * 2.1),
        row_h = t.menu_row_h,
        row_gap = t.menu_row_gap,
    })

    local right_x = menu.panel.x + menu.panel.w + math.floor(unit * 2.7)
    local right_w = w - right_x - (t.frame_inset + unit)
    local right_inner_w = right_w - t.panel_pad_x * 2

    local selected_meta = self:getTitleOptionMeta(title_options[1] or "NEW SESSION")
    local body_h = self:getWrappedTextHeight(self.font, selected_meta.body, right_inner_w)
    local runtime_rows_h = self.font:getHeight() * 3 + t.line_gap * 2
    local top_content_h = self.font:getHeight()
        + t.block_gap
        + self.font_large:getHeight()
        + t.block_gap
        + body_h
        + t.section_gap
        + self.font_bold:getHeight()
        + t.block_gap
        + runtime_rows_h

    local session_title_h = self.font_bold:getHeight()
    local session_detail_h = self.font:getHeight()
    local flavor_h = self.font:getHeight() * 2 + t.line_gap
    local bottom_band_h = math.max(session_title_h + t.block_gap + session_detail_h, flavor_h)
    local right_inner_h = t.panel_pad_y * 2 + top_content_h + t.section_gap * 2 + bottom_band_h
    local right_h = math.max(menu.panel.h, PANEL_HEADER_H + right_inner_h)

    local atmosphere_y = math.max(menu.panel.y + menu.panel.h, menu.panel.y + right_h) + math.floor(unit * 2.6)
    local footer_y = h - t.frame_inset + t.footer_gap
    local footer_rule_y = footer_y - math.floor(unit * 2.0)
    local content_top = menu.panel.y + PANEL_HEADER_H + t.panel_pad_y
    local bottom_band_y = menu.panel.y + right_h - t.panel_pad_y - bottom_band_h
    local flavor_w = self.font:getWidth("Compare often.")
    local session_min_w = self.font:getWidth("AUTOSAVE DETECTED") + self.font:getWidth("SESSION") + unit * 4
    local session_w = clamp(right_inner_w - flavor_w - unit * 8, session_min_w, right_inner_w)

    return {
        unit = unit,
        tokens = t,
        left = left,
        top = top,
        description_y = description_y,
        description_gap = description_gap,
        tagline_y = tagline_y,
        access_y = access_y,
        separator_y = separator_y,
        menu = menu,
        right = {
            x = right_x,
            y = menu.panel.y,
            w = right_w,
            h = right_h,
            inner_x = right_x + t.panel_pad_x,
            inner_w = right_inner_w,
            content_top = content_top,
            content_bottom = bottom_band_y - t.section_gap,
            bottom_band_y = bottom_band_y,
            session_w = session_w,
            flavor_w = flavor_w,
        },
        atmosphere_y = atmosphere_y,
        footer_y = footer_y,
        footer_rule_y = footer_rule_y,
    }
end

function MenuUI:buildSettingsLayout(w, h)
    local t = self:getTokens()
    local unit = t.unit
    local widest_label = self:measureMaxWidth(SETTINGS_OPTIONS, self.font, function(option)
        return option.label
    end)
    local widest_value = self:measureMaxWidth({"DELIBERATE", "MEASURED", "STANDARD", "INSTANT", "100%"}, self.font)
    local box_w = math.max(928, widest_label + widest_value + unit * 22)
    local panel_x = math.floor((w - box_w) / 2)
    local hint_block_h = self.font:getHeight() + math.floor(unit * 2.8)
    local list_opts = {
        inner_pad_x = math.floor(unit * 2.3),
        top_pad = self.font_title:getHeight() + self.font:getHeight() + math.floor(unit * 3.5),
        bottom_pad = hint_block_h + math.floor(unit * 1.8),
        row_h = self.font:getHeight() + math.floor(unit * 1.0),
        row_gap = self.font:getHeight() + math.floor(unit * 1.15),
    }
    local preview = self:buildListLayout(0, 0, box_w, #SETTINGS_OPTIONS, self.font, list_opts)
    local panel_y = math.floor((h - preview.panel.h) / 2)
    local list = self:buildListLayout(panel_x, panel_y, box_w, #SETTINGS_OPTIONS, self.font, list_opts)

    return {
        panel = list.panel,
        items = list.items,
        hint_y = list.panel.y + list.panel.h - self.font:getHeight() - math.floor(unit * 1.4),
        title_y = list.panel.y + PANEL_HEADER_H + math.floor(unit * 1.4),
        subtitle_y = list.panel.y + PANEL_HEADER_H + self.font_title:getHeight() + math.floor(unit * 1.8),
        value_pad = math.floor(unit * 2.4),
    }
end

function MenuUI:buildPauseLayout(w, h)
    local t = self:getTokens()
    local unit = t.unit
    local box_w = math.max(420, self:measureMaxWidth(PAUSE_OPTIONS, self.font) + unit * 12)
    local panel_x = math.floor((w - box_w) / 2)
    local list_opts = {
        inner_pad_x = math.floor(unit * 1.9),
        top_pad = self.font_large:getHeight() + math.floor(unit * 2.3),
        bottom_pad = math.floor(unit * 2.1),
        row_h = self.font:getHeight() + math.floor(unit * 1.0),
        row_gap = self.font:getHeight() + math.floor(unit * 1.05),
    }
    local preview = self:buildListLayout(0, 0, box_w, #PAUSE_OPTIONS, self.font, list_opts)
    local panel_y = math.floor((h - preview.panel.h) / 2)
    local list = self:buildListLayout(panel_x, panel_y, box_w, #PAUSE_OPTIONS, self.font, list_opts)

    return {
        panel = list.panel,
        items = list.items,
        title_y = list.panel.y + PANEL_HEADER_H + math.floor(unit * 1.4),
    }
end

function MenuUI:getSurfaceCount(surface)
    if surface == "title" then
        return #self:getTitleOptions()
    elseif surface == "settings" then
        return #SETTINGS_OPTIONS
    elseif surface == "pause" then
        return #PAUSE_OPTIONS
    end
    return 0
end

function MenuUI:getSelectedIndex(surface)
    if surface == "title" then
        return self.title_index
    elseif surface == "settings" then
        return self.settings_index
    elseif surface == "pause" then
        return self.pause_index
    end
    return 0
end

function MenuUI:setSelectedIndex(surface, index)
    if surface == "title" then
        self.title_index = index
    elseif surface == "settings" then
        self.settings_index = index
    elseif surface == "pause" then
        self.pause_index = index
    end
end

function MenuUI:clearHover(surface)
    if surface then
        self.menu_hover[surface] = nil
        return
    end
    self.menu_hover.title = nil
    self.menu_hover.settings = nil
    self.menu_hover.pause = nil
end

function MenuUI:setCursorStyle(interactive)
    if not self.cursor_arrow then
        return
    end
    local next_cursor = interactive and self.cursor_hand or self.cursor_arrow
    if self.cursor_current ~= next_cursor then
        love.mouse.setCursor(next_cursor)
        self.cursor_current = next_cursor
    end
end

function MenuUI:playClick()
    if self.on_click then
        self.on_click()
    end
end

function MenuUI:deactivate()
    self:clearHover()
    self:setCursorStyle(false)
end

function MenuUI:resetTitle()
    self.title_index = 1
    self.pause_index = 1
    self:deactivate()
end

function MenuUI:enterSettings()
    self.settings_index = 1
    self:clearHover("title")
    self:clearHover("pause")
    self:setCursorStyle(false)
end

function MenuUI:enterPause()
    self.pause_index = 1
    self:clearHover("settings")
    self:setCursorStyle(false)
end

function MenuUI:buildActiveMenuLayout(app_state)
    local vw, vh = self.get_virtual_size()
    if app_state == "title" then
        return "title", self:buildTitleLayout(vw, vh).menu.items
    elseif app_state == "settings" then
        return "settings", self:buildSettingsLayout(vw, vh).items
    elseif app_state == "pause" then
        return "pause", self:buildPauseLayout(vw, vh).items
    end
    return nil, nil
end

function MenuUI:screenToVirtual(x, y)
    local _, _, scale, ox, oy = self.get_viewport()
    local vw, vh = self.get_virtual_size()
    local vx = (x - ox) / scale
    local vy = (y - oy) / scale
    local inside = vx >= 0 and vx <= vw and vy >= 0 and vy <= vh
    return vx, vy, inside
end

function MenuUI:recordMousePosition(x, y)
    local vx, vy, inside = self:screenToVirtual(x, y)
    self.mouse_state.tracked = true
    self.mouse_state.x = vx
    self.mouse_state.y = vy
    self.mouse_state.inside = inside
    return vx, vy, inside
end

function MenuUI:syncMenuHover(app_state, vx, vy, play_sound)
    local surface, items = self:buildActiveMenuLayout(app_state)
    if not surface or not items then
        self:setCursorStyle(false)
        return nil
    end

    local hit_index = hitTestItems(vx, vy, items)
    local previous_hover = self.menu_hover[surface]
    self.menu_hover[surface] = hit_index
    self:setCursorStyle(hit_index ~= nil)

    if hit_index and self:getSelectedIndex(surface) ~= hit_index then
        self:setSelectedIndex(surface, hit_index)
        if play_sound then
            self:playClick()
        end
    elseif play_sound and previous_hover ~= hit_index and hit_index then
        self:playClick()
    end

    return hit_index
end

function MenuUI:updateAnimations(dt)
    for _, surface in ipairs({"title", "settings", "pause"}) do
        local count = self:getSurfaceCount(surface)
        local selected_index = self:getSelectedIndex(surface)
        local hover_index = self.menu_hover[surface]
        local states = self.menu_anim[surface]

        for i = 1, count do
            local state = states[i] or {focus = 0, hover = 0, shift = 0}
            local target_focus = (i == selected_index) and 1 or 0
            local target_hover = (i == hover_index) and 1 or 0
            local target_shift = target_focus * 2
            state.focus = smoothToward(state.focus, target_focus, 14, dt)
            if target_hover == 0 then
                state.hover = 0
            else
                state.hover = smoothToward(state.hover, target_hover, 20, dt)
            end
            state.shift = smoothToward(state.shift, target_shift, 12, dt)
            states[i] = state
        end

        for i = #states, count + 1, -1 do
            states[i] = nil
        end
    end
end

function MenuUI:update(app_state, dt)
    self:updateAnimations(dt)
    if app_state ~= "title" and app_state ~= "settings" and app_state ~= "pause" then
        self:setCursorStyle(false)
    end
end

function MenuUI:formatSettingValue(option)
    local settings = self.get_settings()
    if option.kind == "bool" then
        return settings[option.key] and "ON" or "OFF"
    elseif option.kind == "number" then
        return tostring(math.floor(settings[option.key] * 100 + 0.5)) .. "%"
    elseif option.kind == "enum" then
        local value = settings[option.key]
        if value == 60 then return "DELIBERATE" end
        if value == 120 then return "MEASURED" end
        if value == 180 then return "STANDARD" end
        if value == 300 then return "FAST" end
        if value == 600 then return "INSTANT" end
        return tostring(value)
    end
    return ""
end

function MenuUI:drawBackground(w, h)
    local colors = self.colors
    love.graphics.setColor(colors.bg)
    love.graphics.rectangle("fill", 0, 0, w, h)

    local t = love.timer.getTime()
    love.graphics.setLineWidth(1)

    love.graphics.setColor(colors.very_dim[1], colors.very_dim[2], colors.very_dim[3], 0.15)
    for gx = 96, w - 96, 48 do
        for gy = 96, h - 96, 48 do
            love.graphics.circle("fill", gx, gy, 1)
        end
    end

    for i = 0, 17 do
        local y = 86 + i * 38
        local wobble = math.sin(t * 0.35 + i * 0.8) * 18
        local a = 0.12 + 0.08 * math.sin(t * 0.6 + i * 1.1)
        love.graphics.setColor(colors.very_dim[1], colors.very_dim[2], colors.very_dim[3], a)
        love.graphics.line(78, y, w * 0.72 + wobble, y)
    end

    love.graphics.setColor(colors.border[1], colors.border[2], colors.border[3], 0.10)
    for x = 96, w - 96, 96 do
        love.graphics.line(x, 64, x, h - 64)
    end

    love.graphics.setColor(colors.border[1], colors.border[2], colors.border[3], 0.45)
    love.graphics.rectangle("line", 52, 52, w - 104, h - 104)

    love.graphics.setColor(colors.border[1], colors.border[2], colors.border[3], 0.15)
    love.graphics.rectangle("line", 78, 78, w - 156, h - 156)

    local cl = 30
    love.graphics.setLineWidth(2)
    love.graphics.setColor(colors.cyan[1], colors.cyan[2], colors.cyan[3], 0.5)
    love.graphics.line(40, 40, 40 + cl, 40)
    love.graphics.line(40, 40, 40, 40 + cl)
    love.graphics.line(w - 40, 40, w - 40 - cl, 40)
    love.graphics.line(w - 40, 40, w - 40, 40 + cl)
    love.graphics.line(40, h - 40, 40 + cl, h - 40)
    love.graphics.line(40, h - 40, 40, h - 40 - cl)
    love.graphics.line(w - 40, h - 40, w - 40 - cl, h - 40)
    love.graphics.line(w - 40, h - 40, w - 40, h - 40 - cl)
    love.graphics.setLineWidth(1)

    love.graphics.setColor(colors.cyan[1], colors.cyan[2], colors.cyan[3], 0.06)
    love.graphics.rectangle("fill", 63, 52, 3, h - 104)
    love.graphics.rectangle("fill", w - 66, 52, 3, h - 104)

    love.graphics.setColor(colors.cyan[1], colors.cyan[2], colors.cyan[3], 0.35 + 0.25 * math.sin(t * 3.0))
    love.graphics.circle("fill", 72, 60, 3)
    love.graphics.setColor(colors.header[1], colors.header[2], colors.header[3], 0.35 + 0.2 * math.sin(t * 2.2 + 1.0))
    love.graphics.circle("fill", 84, 60, 3)
    love.graphics.setColor(colors.cyan[1], colors.cyan[2], colors.cyan[3], 0.35 + 0.2 * math.sin(t * 2.7 + 2.0))
    love.graphics.circle("fill", w - 72, 60, 3)

    love.graphics.setFont(self.font)
    local hex = "0123456789ABCDEF"
    for i = 0, 13 do
        local y = 100 + i * 44
        local idx = (math.floor(t * 2.0 + i * 3.7) % 16) + 1
        local ch = hex:sub(idx, idx)
        local a2 = 0.08 + 0.05 * math.sin(t * 1.8 + i * 2.3)
        love.graphics.setColor(colors.dim[1], colors.dim[2], colors.dim[3], a2)
        love.graphics.print(ch, 58, y)
    end

    for i = 0, 13 do
        local y = 100 + i * 44
        local idx = (math.floor(t * 1.3 + i * 5.1) % 16) + 1
        local ch = hex:sub(idx, idx)
        local a2 = 0.06 + 0.04 * math.sin(t * 2.1 + i * 1.7)
        love.graphics.setColor(self.colors.dim[1], self.colors.dim[2], self.colors.dim[3], a2)
        love.graphics.print(ch, w - 78, y)
    end
end

function MenuUI:drawBox(x, y, w, h)
    love.graphics.setColor(self.colors.very_dim[1], self.colors.very_dim[2], self.colors.very_dim[3], 0.35)
    love.graphics.rectangle("fill", x + 1, y + 1, w - 2, h - 2)
    love.graphics.setColor(self.colors.border)
    love.graphics.rectangle("line", x, y, w, h)

    local tick = 8
    love.graphics.setColor(self.colors.cyan[1], self.colors.cyan[2], self.colors.cyan[3], 0.45)
    love.graphics.line(x, y, x + tick, y)
    love.graphics.line(x, y, x, y + tick)
    love.graphics.line(x + w, y, x + w - tick, y)
    love.graphics.line(x + w, y, x + w, y + tick)
    love.graphics.line(x, y + h, x + tick, y + h)
    love.graphics.line(x, y + h, x, y + h - tick)
    love.graphics.line(x + w, y + h, x + w - tick, y + h)
    love.graphics.line(x + w, y + h, x + w, y + h - tick)
end

function MenuUI:drawPanel(x, y, w, h, title, accent)
    self:drawBox(x, y, w, h)
    local unit = self:getRhythmUnit()
    local header_text_y = y + math.floor((PANEL_HEADER_H - self.font_bold:getHeight()) * 0.5) - 1
    local t = love.timer.getTime()
    local pulse = 0.05 + 0.03 * (0.5 + 0.5 * math.sin(t * 1.8 + x * 0.01))

    love.graphics.setColor(self.colors.very_dim[1], self.colors.very_dim[2], self.colors.very_dim[3], 0.6)
    love.graphics.rectangle("fill", x + 1, y + 1, w - 2, PANEL_HEADER_H - 2)

    local ac = accent or self.colors.header
    love.graphics.setColor(ac)
    love.graphics.rectangle("fill", x + 1, y + 1, 3, PANEL_HEADER_H - 2)

    love.graphics.setColor(ac[1], ac[2], ac[3], 0.08)
    love.graphics.rectangle("fill", x + 4, y + 1, math.floor(w * 0.34), PANEL_HEADER_H - 2)

    love.graphics.setFont(self.font_bold)
    local title_x = x + unit * 2
    local title_w = self.font_bold:getWidth(title)
    love.graphics.setColor(ac[1], ac[2], ac[3], 0.10 + pulse)
    love.graphics.print(title, title_x + 1, header_text_y + 1)
    love.graphics.setColor(accent == self.colors.amber and self.colors.amber or self.colors.cyan)
    love.graphics.print(title, title_x, header_text_y)

    love.graphics.setColor(self.colors.border)
    love.graphics.rectangle("fill", x + 1, y + PANEL_HEADER_H - 1, w - 2, 1)

    love.graphics.setColor(self.colors.very_dim[1], self.colors.very_dim[2], self.colors.very_dim[3], 0.22)
    love.graphics.rectangle("fill", x + 1, y + PANEL_HEADER_H, w - 2, unit * 2)
    love.graphics.setColor(ac[1], ac[2], ac[3], pulse)
    love.graphics.rectangle("fill", x + 1, y + PANEL_HEADER_H, w - 2, 1)

    local underline_y = y + PANEL_HEADER_H - 4
    local underline_w = title_w + unit * 2
    local sweep_x = title_x + ((t * 36) % math.max(18, underline_w))
    love.graphics.setColor(ac[1], ac[2], ac[3], 0.18)
    love.graphics.rectangle("fill", title_x, underline_y, underline_w, 1)
    love.graphics.setColor(ac[1], ac[2], ac[3], 0.38)
    love.graphics.rectangle("fill", sweep_x, underline_y, math.min(unit * 2, title_x + underline_w - sweep_x), 1)

    local beacon_x = x + w - unit * 2
    love.graphics.setColor(ac[1], ac[2], ac[3], 0.25 + pulse)
    love.graphics.circle("fill", beacon_x, y + math.floor(PANEL_HEADER_H * 0.5), 2)
end

function MenuUI:drawInlineSegments(x, y, segments, active_font)
    local cursor_x = x
    for _, segment in ipairs(segments) do
        love.graphics.setColor(segment.color)
        love.graphics.print(segment.text, cursor_x, y)
        cursor_x = cursor_x + active_font:getWidth(segment.text)
    end
end

function MenuUI:drawInteractiveRow(item, selected, hovered, anim, accent)
    local focus = anim and anim.focus or (selected and 1 or 0)
    local hover = anim and anim.hover or (hovered and 1 or 0)
    local shift = anim and anim.shift or 0
    local ac = accent or self.colors.cyan
    local pulse = 0.5 + 0.5 * math.sin(love.timer.getTime() * 3.2 + item.y * 0.03)
    local row_fill = 0.03 + hover * 0.04 + focus * (0.08 + 0.04 * pulse)

    if row_fill > 0.01 then
        love.graphics.setColor(ac[1], ac[2], ac[3], row_fill)
        love.graphics.rectangle("fill", item.x, item.y, item.w, item.h)

        love.graphics.setColor(ac[1], ac[2], ac[3], 0.04 + focus * 0.08)
        love.graphics.rectangle("fill", item.x + 4, item.y + 4, item.w - 8, item.h - 8)

        love.graphics.setColor(ac[1], ac[2], ac[3], 0.22 + focus * 0.35)
        love.graphics.rectangle("fill", item.x, item.y, 3, item.h)

        love.graphics.setColor(ac[1], ac[2], ac[3], 0.12 + focus * 0.18)
        love.graphics.rectangle("fill", item.x + item.w - 2, item.y, 2, item.h)

        love.graphics.setColor(ac[1], ac[2], ac[3], 0.10 + focus * 0.16 + hover * 0.08)
        love.graphics.rectangle("fill", item.x + 3, item.y + item.h - 2, item.w - 5, 1)
    end

    if hover > 0.01 and not selected then
        love.graphics.setColor(ac[1], ac[2], ac[3], 0.15 * hover)
        love.graphics.rectangle("line", item.x + 1, item.y + 1, item.w - 2, item.h - 2)
    end

    return shift
end

function MenuUI:drawMenuOption(item, label, selected, hovered, anim, accent)
    local text_y = item.y + math.floor((item.h - self.font:getHeight()) * 0.5) - 1
    local prompt_x = item.x + math.floor(self:getRhythmUnit() * 1.75)
    local label_x = prompt_x + self.font:getWidth(">  ")
    local shift = self:drawInteractiveRow(item, selected, hovered, anim, accent)

    if selected then
        love.graphics.setColor(self.colors.cyan[1], self.colors.cyan[2], self.colors.cyan[3], 0.18)
        love.graphics.print(">", prompt_x + shift + 1, text_y + 1)
        love.graphics.setColor(self.colors.bright)
        love.graphics.print(">", prompt_x + shift, text_y)
    end

    love.graphics.setColor(selected and self.colors.bright or (hovered and self.colors.header or self.colors.text))
    love.graphics.print(label, label_x + shift, text_y)
end

function MenuUI:drawTitleScreen(w, h)
    self:drawBackground(w, h)

    local t = love.timer.getTime()
    local layout = self:buildTitleLayout(w, h)
    local left = layout.left
    local top = layout.top
    local unit = layout.unit
    local tokens = layout.tokens
    local panel_pad = tokens.panel_pad_x
    local title_options = self:getTitleOptions()
    local selected_index = math.max(1, math.min(self.title_index, #title_options))
    self.title_index = selected_index
    local selected_option = title_options[selected_index]
    local selected_meta = self:getTitleOptionMeta(selected_option)

    love.graphics.setFont(self.font_bold)
    love.graphics.setColor(self.colors.cyan)
    love.graphics.print("MERIDIAN INTERNAL SYSTEM / NIGHT SHIFT", left + 4, top - math.floor(unit * 2.0))

    love.graphics.setFont(self.font_title)
    local title_text = "ASHLINE"
    local glitch_cycle = 4.2
    local glitch_phase = t % glitch_cycle
    if glitch_phase < 0.1 then
        local glitch_chars = "!@#$%&*<>{}|/~+="
        local pos = (math.floor(t * 17.3) % #title_text) + 1
        local chars = {}
        for ci = 1, #title_text do
            if ci == pos then
                local gi = (math.floor(t * 53.7) % #glitch_chars) + 1
                chars[ci] = glitch_chars:sub(gi, gi)
            else
                chars[ci] = title_text:sub(ci, ci)
            end
        end
        title_text = table.concat(chars)
    end

    love.graphics.setColor(self.colors.bright[1], self.colors.bright[2], self.colors.bright[3], 0.12)
    love.graphics.print(title_text, left + 2, top + 2)
    love.graphics.print(title_text, left - 1, top)
    love.graphics.setColor(self.colors.cyan[1], self.colors.cyan[2], self.colors.cyan[3], 0.08 + 0.04 * (0.5 + 0.5 * math.sin(t * 2.2)))
    love.graphics.print(title_text, left + 1, top + 1)
    love.graphics.setColor(self.colors.bright)
    love.graphics.print(title_text, left, top + 1)

    love.graphics.setFont(self.font)
    love.graphics.setColor(self.colors.dim)
    love.graphics.print("A terminal investigation about hidden people, buried doctrine,", left + 4, layout.description_y)
    love.graphics.print("and the price of truth.", left + 4, layout.description_y + layout.description_gap)

    love.graphics.setColor(self.colors.very_dim)
    love.graphics.print("Meridian survives by omission.", left + 4, layout.tagline_y)

    love.graphics.setColor(self.colors.cyan)
    love.graphics.print("Night shift access point / operator handoff required", left + 4, layout.access_y)

    love.graphics.setColor(self.colors.border[1], self.colors.border[2], self.colors.border[3], 0.5)
    love.graphics.rectangle("fill", left, layout.separator_y, 440, 1)
    love.graphics.setColor(self.colors.cyan[1], self.colors.cyan[2], self.colors.cyan[3], 0.2)
    love.graphics.rectangle("fill", left, layout.separator_y + 1, 280 + math.floor(unit * 1.5), 1)

    love.graphics.setFont(self.font)
    local signal_text = "SIGNAL LOCKED"
    local signal_x = w - MENU_FRAME_INSET - unit * 3 - self.font:getWidth(signal_text)
    love.graphics.setColor(self.colors.dim)
    love.graphics.print(signal_text, signal_x, top - math.floor(unit * 2.0))
    local blink = math.sin(t * 4) > 0 and 0.8 or 0.2
    love.graphics.setColor(self.colors.cyan[1], self.colors.cyan[2], self.colors.cyan[3], blink)
    love.graphics.circle("fill", signal_x - unit * 1.8, top - unit, 4)

    love.graphics.setColor(self.colors.very_dim)
    love.graphics.print(os.date("%H:%M:%S"), signal_x, top + math.floor(unit * 0.2))

    self:drawPanel(layout.menu.panel.x, layout.menu.panel.y, layout.menu.panel.w, layout.menu.panel.h, "TERMINAL ACCESS", self.colors.header)

    love.graphics.setFont(self.font)
    for i, option in ipairs(title_options) do
        local item = layout.menu.items[i]
        self:drawMenuOption(item, option, i == self.title_index, self.menu_hover.title == i, self.menu_anim.title[i], self.colors.cyan)
    end

    local right_x = layout.right.x
    local right_y = layout.right.y
    local right_w = layout.right.w
    local right_h = layout.right.h
    self:drawPanel(right_x, right_y, right_w, right_h, "SELECTION DOSSIER", self.colors.amber)
    local inner_x = layout.right.inner_x
    local inner_w = layout.right.inner_w
    local content_y = layout.right.content_top
    local route_y
    local hero_y
    local body_y
    local separator_y
    local runtime_heading_y

    route_y, content_y = stackPush(content_y, self.font:getHeight(), tokens.block_gap)
    hero_y, content_y = stackPush(content_y, self.font_large:getHeight(), tokens.block_gap)
    local body_h = self:getWrappedTextHeight(self.font, selected_meta.body, inner_w)
    body_y, content_y = stackPush(content_y, body_h, tokens.section_gap)
    separator_y, content_y = stackPush(content_y, 1, tokens.section_gap)
    runtime_heading_y, content_y = stackPush(content_y, self.font_bold:getHeight(), tokens.block_gap)

    love.graphics.setFont(self.font)
    love.graphics.setColor(self.colors.amber)
    love.graphics.print(selected_meta.code, inner_x, route_y)
    love.graphics.setColor(self.colors.cyan)
    love.graphics.print("TARGET: " .. selected_option, inner_x + self.font:getWidth(selected_meta.code) + unit * 2, route_y)

    love.graphics.setFont(self.font_large)
    love.graphics.setColor(self.colors.bright)
    love.graphics.print(selected_meta.title, inner_x, hero_y)

    love.graphics.setFont(self.font)
    love.graphics.setColor(self.colors.text)
    love.graphics.printf(selected_meta.body, inner_x, body_y, inner_w)

    local pulse = 0.16 + 0.04 * (0.5 + 0.5 * math.sin(t * 2.4))
    love.graphics.setColor(self.colors.cyan[1], self.colors.cyan[2], self.colors.cyan[3], pulse)
    love.graphics.rectangle("fill", inner_x, separator_y, inner_w, 1)

    love.graphics.setFont(self.font_bold)
    love.graphics.setColor(self.colors.text)
    love.graphics.print("RUNTIME", inner_x, runtime_heading_y)
    love.graphics.setFont(self.font)

    local info_items = {
        {"Length", "~2 hours"},
        {"Input", "Keyboard only"},
        {"Display", "Alt+Enter fullscreen"},
    }
    local info_label_w = self:measureMaxWidth(info_items, self.font, function(item)
        return item[1]
    end)
    local info_value_x = inner_x + info_label_w + unit * 8
    local info_y = content_y
    for _, item in ipairs(info_items) do
        love.graphics.setColor(self.colors.dim)
        love.graphics.print(item[1], inner_x, info_y)
        love.graphics.setColor(self.colors.dim[1], self.colors.dim[2], self.colors.dim[3], 0.5)
        local dots_x = inner_x + info_label_w + unit * 1.5
        local dot_count = math.max(6, math.floor((info_value_x - dots_x - unit) / self.font:getWidth(".")))
        love.graphics.print(("."):rep(dot_count), dots_x, info_y)
        love.graphics.setColor(self.colors.bright)
        love.graphics.print(item[2], info_value_x, info_y)
        info_y = info_y + self.font:getHeight() + tokens.line_gap
    end

    local session_x = inner_x
    local session_y = layout.right.bottom_band_y
    local session_w = layout.right.session_w
    local flavor_x = right_x + right_w - panel_pad - layout.right.flavor_w
    local flavor_y = right_y + right_h - tokens.panel_pad_y - (self.font:getHeight() * 2 + tokens.line_gap)

    love.graphics.setColor(self.colors.border)
    love.graphics.rectangle("fill", session_x, session_y, session_w, 1)
    love.graphics.setFont(self.font_bold)
    love.graphics.setColor(self.colors.header)
    local session_title_y = session_y + tokens.block_gap
    love.graphics.print("SESSION", session_x, session_title_y)

    local meta = self.get_save_metadata()
    if meta then
        love.graphics.setColor(self.colors.cyan)
        love.graphics.print("AUTOSAVE DETECTED", session_x + self.font_bold:getWidth("SESSION") + unit * 3, session_title_y)
        love.graphics.setFont(self.font)
        love.graphics.setColor(self.colors.text)
        local session_detail_y = session_title_y + self.font_bold:getHeight() + tokens.block_gap
        local saved_at = tostring(meta.saved_at or "UNKNOWN")
        love.graphics.print(saved_at, session_x, session_detail_y)
        love.graphics.setColor(self.colors.dim)
        love.graphics.printf("CHAPTER " .. tostring(meta.chapter or "UNKNOWN"), session_x, session_detail_y, session_w, "right")
    else
        love.graphics.setFont(self.font)
        love.graphics.setColor(self.colors.dim)
        love.graphics.print("No autosave present.", session_x + self.font_bold:getWidth("SESSION") + unit * 3, session_title_y)
    end

    love.graphics.setColor(self.colors.dim)
    love.graphics.print("Read closely.", flavor_x, flavor_y)
    love.graphics.print("Compare often.", flavor_x, flavor_y + self.font:getHeight() + tokens.line_gap)

    local footer_y = layout.footer_y
    local footer_rule_y = layout.footer_rule_y
    love.graphics.setColor(self.colors.border[1], self.colors.border[2], self.colors.border[3], 0.35)
    love.graphics.rectangle("fill", MENU_FRAME_INSET, footer_rule_y, w - MENU_FRAME_INSET * 2, 1)

    love.graphics.setFont(self.font)
    local footer_left_x = MENU_FRAME_INSET + unit
    local footer_right_x = w - MENU_FRAME_INSET - unit
    local footer_gap = unit * 4
    local credit = "made with <3 by vinny"
    local credit_w = self.font:getWidth(credit)
    local help_segments = {
        {text = "Up/Down", color = self.colors.text},
        {text = " move", color = self.colors.dim},
        {text = "  |  ", color = self.colors.border},
        {text = "Enter", color = self.colors.text},
        {text = " select", color = self.colors.dim},
        {text = "  |  ", color = self.colors.border},
        {text = "Mouse", color = self.colors.text},
        {text = " choose", color = self.colors.dim},
        {text = "  |  ", color = self.colors.border},
        {text = "Esc", color = self.colors.text},
        {text = " back", color = self.colors.dim},
    }
    local help_w = 0
    for _, segment in ipairs(help_segments) do
        help_w = help_w + self.font:getWidth(segment.text)
    end
    local help_x = footer_left_x
    local help_max_right = footer_right_x - credit_w - footer_gap
    if help_x + help_w > help_max_right then
        help_x = math.max(footer_left_x, help_max_right - help_w)
    end

    self:drawInlineSegments(help_x, footer_y, help_segments, self.font)

    love.graphics.setColor(self.colors.dim)
    love.graphics.print(credit, footer_right_x - credit_w, footer_y)

    local save_notice = self.get_save_notice()
    if save_notice and #save_notice > 0 then
        love.graphics.setColor(self.colors.amber)
        love.graphics.print(save_notice, left + 4, footer_rule_y - unit * 2)
    end
end

function MenuUI:drawSettingsScreen(w, h)
    if self.get_settings_return_state() == "pause" and self.render_terminal_overlay then
        self.render_terminal_overlay(w, h, 0.62)
    else
        self:drawBackground(w, h)
    end

    local layout = self:buildSettingsLayout(w, h)
    local unit = self:getRhythmUnit()
    local box_x = layout.panel.x
    local box_y = layout.panel.y
    local box_w = layout.panel.w
    local box_h = layout.panel.h
    self:drawPanel(box_x, box_y, box_w, box_h, "SETTINGS", self.colors.header)

    love.graphics.setFont(self.font_title)
    love.graphics.setColor(self.colors.bright)
    love.graphics.print("SETTINGS", box_x + unit * 2 + 6, layout.title_y)

    love.graphics.setFont(self.font)
    love.graphics.setColor(self.colors.dim)
    love.graphics.print("Changes apply immediately and persist as JSON.", box_x + unit * 2 + 10, layout.subtitle_y)

    for i, option in ipairs(SETTINGS_OPTIONS) do
        local item = layout.items[i]
        local selected = i == self.settings_index
        local hovered = self.menu_hover.settings == i
        local anim = self.menu_anim.settings[i]
        local text_y = item.y + math.floor((item.h - self.font:getHeight()) * 0.5) - 1
        local shift = self:drawInteractiveRow(item, selected, hovered, anim, self.colors.cyan)
        local prompt_x = item.x + math.floor(unit * 1.5)
        local label_x = prompt_x + self.font:getWidth(">  ")

        if selected then
            love.graphics.setColor(self.colors.bright)
            love.graphics.print(">", prompt_x + shift, text_y)
        end

        love.graphics.setColor(selected and self.colors.bright or (hovered and self.colors.header or self.colors.text))
        love.graphics.print(option.label, label_x + shift, text_y)

        if option.kind ~= "action" then
            love.graphics.setColor(selected and self.colors.cyan or self.colors.dim)
            love.graphics.printf(self:formatSettingValue(option), item.x, text_y, item.w - layout.value_pad, "right")
        end
    end

    love.graphics.setColor(self.colors.dim)
    love.graphics.print("Left/Right adjust  Enter toggle/select  Mouse wheel adjust  Esc back", box_x + unit * 2 + 10, layout.hint_y)
end

function MenuUI:drawPauseOverlay(w, h)
    if self.render_terminal_overlay then
        self.render_terminal_overlay(w, h, 0.52)
    end

    local layout = self:buildPauseLayout(w, h)
    local unit = self:getRhythmUnit()
    local box_x = layout.panel.x
    local box_y = layout.panel.y
    local box_w = layout.panel.w
    local box_h = layout.panel.h
    self:drawPanel(box_x, box_y, box_w, box_h, "SESSION PAUSED", self.colors.amber)

    love.graphics.setFont(self.font_large)
    love.graphics.setColor(self.colors.bright)
    love.graphics.print("PAUSED", box_x + unit * 2 + 6, layout.title_y)

    love.graphics.setFont(self.font)
    for i, option in ipairs(PAUSE_OPTIONS) do
        self:drawMenuOption(layout.items[i], option, i == self.pause_index, self.menu_hover.pause == i, self.menu_anim.pause[i], self.colors.amber)
    end
end

function MenuUI:draw(app_state, w, h)
    if app_state == "title" then
        self:drawTitleScreen(w, h)
        return true
    elseif app_state == "settings" then
        self:drawSettingsScreen(w, h)
        return true
    elseif app_state == "pause" then
        self:drawPauseOverlay(w, h)
        return true
    end
    return false
end

function MenuUI:keypressed(app_state, key, isrepeat)
    if app_state == "title" then
        local title_options = self:getTitleOptions()
        if key == "up" and not isrepeat then
            self:clearHover("title")
            self.title_index = ((self.title_index - 2) % #title_options) + 1
            self:playClick()
        elseif key == "down" and not isrepeat then
            self:clearHover("title")
            self.title_index = (self.title_index % #title_options) + 1
            self:playClick()
        elseif (key == "return" or key == "kpenter") and not isrepeat then
            self:playClick()
            self.on_title_select(title_options[self.title_index])
        elseif key == "escape" and not isrepeat then
            self.on_title_select("QUIT")
        else
            return false
        end
        return true
    elseif app_state == "settings" then
        if key == "up" and not isrepeat then
            self:clearHover("settings")
            self.settings_index = ((self.settings_index - 2) % #SETTINGS_OPTIONS) + 1
            self:playClick()
        elseif key == "down" and not isrepeat then
            self:clearHover("settings")
            self.settings_index = (self.settings_index % #SETTINGS_OPTIONS) + 1
            self:playClick()
        elseif key == "left" and not isrepeat then
            self:clearHover("settings")
            self.on_adjust_setting(SETTINGS_OPTIONS[self.settings_index], -1)
        elseif key == "right" and not isrepeat then
            self:clearHover("settings")
            self.on_adjust_setting(SETTINGS_OPTIONS[self.settings_index], 1)
        elseif (key == "return" or key == "kpenter") and not isrepeat then
            self:playClick()
            local option = SETTINGS_OPTIONS[self.settings_index]
            if option.kind == "action" then
                self.on_close_settings()
            else
                self.on_adjust_setting(option, 1)
            end
        elseif key == "escape" and not isrepeat then
            self:playClick()
            self.on_close_settings()
        else
            return false
        end
        return true
    elseif app_state == "pause" then
        if key == "up" and not isrepeat then
            self:clearHover("pause")
            self.pause_index = ((self.pause_index - 2) % #PAUSE_OPTIONS) + 1
            self:playClick()
        elseif key == "down" and not isrepeat then
            self:clearHover("pause")
            self.pause_index = (self.pause_index % #PAUSE_OPTIONS) + 1
            self:playClick()
        elseif (key == "return" or key == "kpenter") and not isrepeat then
            self:playClick()
            self.on_pause_select(PAUSE_OPTIONS[self.pause_index])
        elseif key == "escape" and not isrepeat then
            self:playClick()
            self.on_pause_select("RESUME")
        else
            return false
        end
        return true
    end
    return false
end

function MenuUI:mousemoved(app_state, x, y)
    local _, _, inside = self:recordMousePosition(x, y)
    if not inside then
        if app_state == "title" or app_state == "settings" or app_state == "pause" then
            self:clearHover(app_state)
        end
        self:setCursorStyle(false)
        return false
    end

    if app_state == "title" or app_state == "settings" or app_state == "pause" then
        self:syncMenuHover(app_state, self.mouse_state.x, self.mouse_state.y, true)
        return true
    end
    return false
end

function MenuUI:mousepressed(app_state, x, y, button)
    if button ~= 1 then
        return false
    end

    local vx, vy, inside = self:recordMousePosition(x, y)
    if not inside then
        return false
    end

    local hit_index = self:syncMenuHover(app_state, vx, vy, false)
    if not hit_index then
        return false
    end

    if app_state == "title" then
        self:playClick()
        self.on_title_select(self:getTitleOptions()[self.title_index])
    elseif app_state == "settings" then
        local option = SETTINGS_OPTIONS[self.settings_index]
        if option.kind == "action" then
            self:playClick()
            self.on_close_settings()
        else
            self.on_adjust_setting(option, 1)
        end
    elseif app_state == "pause" then
        self:playClick()
        self.on_pause_select(PAUSE_OPTIONS[self.pause_index])
    else
        return false
    end

    return true
end

function MenuUI:wheelmoved(app_state, y)
    if app_state ~= "settings" or y == 0 then
        return false
    end

    local target_index = self.menu_hover.settings or self.settings_index
    local option = SETTINGS_OPTIONS[target_index]
    if option and option.kind ~= "action" then
        self.settings_index = target_index
        self.on_adjust_setting(option, y > 0 and 1 or -1)
        return true
    end

    return false
end

return MenuUI
