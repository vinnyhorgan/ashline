local moonshine = require("moonshine")
local colors = require("colors")
local Sound = require("sound")
local Terminal = require("terminal")
local Game = require("game")
local boot = require("boot")
local commands = require("commands")
local data = require("data")
local Settings = require("settings")

local VIRTUAL_W = 1280
local VIRTUAL_H = 800

local terminal
local game
local sound
local effect
local font
local font_bold
local font_title
local font_large
local settings

local last_w, last_h

local app_state = "title"
local settings_return_state = "title"

local input_text = ""
local input_cursor = 0
local command_history = {}
local history_index = 0

local boot_sequence = {}
local boot_index = 0
local boot_timer = 0
local boot_done = false

local notification_timer = 0
local last_unread = 0

local ending_displayed = false
local ending_done = false

local title_index = 1
local pause_index = 1
local settings_index = 1

local TITLE_OPTIONS = {
    "NEW SESSION",
    "SETTINGS",
    "QUIT",
}

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

local function countTable(t)
    local n = 0
    for _ in pairs(t) do n = n + 1 end
    return n
end

local function resetInputState()
    input_text = ""
    input_cursor = 0
    command_history = {}
    history_index = 0
    last_unread = 0
    notification_timer = 0
end

local function updateInput()
    if not terminal then return end
    terminal:setInput(input_text, input_cursor)
    if game then
        terminal:setGhost(commands.getGhostText(input_text, game))
    else
        terminal:setGhost("")
    end
end

local function ensureEffect()
    local ww, wh = love.graphics.getDimensions()
    last_w, last_h = ww, wh

    effect = moonshine(ww, wh, moonshine.effects.scanlines)
        .chain(moonshine.effects.crt)
        .chain(moonshine.effects.glow)
        .chain(moonshine.effects.vignette)
        .chain(moonshine.effects.filmgrain)

    effect.scanlines.opacity = 0.12
    effect.scanlines.thickness = 0.8
    effect.crt.distortionFactor = {1.03, 1.035}
    effect.crt.feather = 0.02
    effect.glow.min_luma = 0.3
    effect.glow.strength = 3
    effect.vignette.opacity = 0.3
    effect.vignette.softness = 0.8
    effect.filmgrain.opacity = 0.03
    effect.filmgrain.size = 1.5
end

local function saveSettings()
    Settings.save(settings)
end

local function applySettings(persist)
    settings = Settings.clamp(settings)

    if sound then
        sound:setMix(
            settings.master_volume,
            settings.ui_volume,
            settings.ambient_volume,
            settings.tension_volume
        )
    end

    if love.window.getFullscreen() ~= settings.fullscreen then
        love.window.setFullscreen(settings.fullscreen, "desktop")
        local ww, wh = love.graphics.getDimensions()
        if effect then effect.resize(ww, wh) end
        last_w, last_h = ww, wh
    end

    if persist then
        saveSettings()
    end
end

local function toggleFullscreen()
    settings.fullscreen = not settings.fullscreen
    applySettings(true)
end

local function updateHeader()
    if not terminal or not game then return end

    local alert_color = game.alert_count > 0 and colors.amber or colors.dim
    local inbox_color = game:getUnreadCount() > 0 and colors.cyan or colors.dim

    local game_minutes = math.floor(game.game_time * 0.25)
    local hour = (22 + math.floor(game_minutes / 60)) % 24
    local minute = game_minutes % 60
    local time_str = string.format("%02d:%02d", hour, minute)

    terminal:setHeader({
        {text = " ASHLINE", color = colors.bright},
        {text = " | ", color = colors.border},
        {text = "SILO MERIDIAN", color = colors.text},
        {text = " | ", color = colors.border},
        {text = "ARC-7", color = colors.text},
        {text = " | ", color = colors.border},
        {text = "2071.03.14 " .. time_str, color = colors.dim},
        {text = "    ", color = colors.bg},
        {text = "ALERTS:", color = alert_color},
        {text = tostring(game.alert_count), color = alert_color},
        {text = "  ", color = colors.bg},
        {text = "INBOX:", color = inbox_color},
        {text = tostring(game:getUnreadCount()), color = inbox_color},
    })
end

local function updateStatus()
    if not terminal or not game then return end

    local phase_text = "MONITORING"
    local phase_color = colors.bright
    if game.phase == "boot" then
        phase_text = "INITIALIZING"
        phase_color = colors.amber
    elseif game.ending then
        phase_text = "SESSION ENDING"
        phase_color = colors.red
    elseif game.chapter == 1 then
        phase_text = "ANOMALY TRIAGE"
        phase_color = colors.bright
    elseif game.chapter == 2 then
        phase_text = "HIDDEN OCCUPANCY"
        phase_color = colors.cyan
    elseif game.chapter == 3 then
        phase_text = "SUPPRESSION LEDGER"
        phase_color = colors.amber
    elseif game.chapter == 4 then
        phase_text = "BURIED SKY"
        phase_color = colors.amber
    elseif game.chapter == 5 then
        phase_text = "TERMINAL DECISION"
        phase_color = colors.red
    end

    terminal:setStatus({
        {text = " PHASE:", color = colors.dim},
        {text = phase_text, color = phase_color},
        {text = "  |  ", color = colors.border},
        {text = "PROOF:", color = colors.dim},
        {text = tostring(math.floor(game.proof_score)), color = colors.bright},
        {text = "  |  ", color = colors.border},
        {text = "RISK:", color = colors.dim},
        {text = tostring(game.audit_risk), color = game.audit_risk >= 5 and colors.red or colors.amber},
        {text = "  |  ", color = colors.border},
        {text = "STRAIN:", color = colors.dim},
        {text = tostring(game.strain), color = game.strain >= 5 and colors.red or colors.amber},
    })
end

local function startSession()
    resetInputState()
    game = Game.new()

    terminal:clear()
    terminal:showInput(false)
    terminal:setGhost("")
    terminal:setInput("", 0)
    terminal:setTypewriterSpeed(settings.text_speed)

    boot_sequence = boot.getSequence()
    boot_index = 0
    boot_timer = 0
    boot_done = false
    ending_displayed = false
    ending_done = false

    app_state = "boot"
    updateHeader()
    updateStatus()
end

local function returnToTitle()
    app_state = "title"
    title_index = 1
    pause_index = 1
    settings_return_state = "title"
    if terminal then
        terminal:showInput(false)
    end
end

local function openSettings(from_state)
    settings_return_state = from_state or "title"
    settings_index = 1
    app_state = "settings"
end

local function closeSettings()
    app_state = settings_return_state
end

local function drawBackground(w, h)
    love.graphics.setColor(colors.bg)
    love.graphics.rectangle("fill", 0, 0, w, h)

    local t = love.timer.getTime()
    love.graphics.setLineWidth(1)
    love.graphics.setColor(colors.very_dim[1], colors.very_dim[2], colors.very_dim[3], 0.6)

    for i = 0, 14 do
        local y = math.floor(h * 0.1 + i * (h * 0.055))
        local wobble = math.sin(t * 0.4 + i * 0.7) * 18
        love.graphics.line(0, y, w * 0.72 + wobble, y)
    end

    love.graphics.setColor(colors.border[1], colors.border[2], colors.border[3], 0.35)
    love.graphics.rectangle("line", math.floor(w * 0.08), math.floor(h * 0.12), math.floor(w * 0.84), math.floor(h * 0.72))
    love.graphics.rectangle("line", math.floor(w * 0.11), math.floor(h * 0.16), math.floor(w * 0.78), math.floor(h * 0.64))
end

local function drawBox(x, y, w, h)
    love.graphics.setColor(colors.border)
    love.graphics.rectangle("line", x, y, w, h)
    love.graphics.setColor(colors.very_dim[1], colors.very_dim[2], colors.very_dim[3], 0.4)
    love.graphics.rectangle("fill", x + 1, y + 1, w - 2, h - 2)
end

local function drawTitleScreen()
    local w, h = love.graphics.getDimensions()
    drawBackground(w, h)

    local left = math.floor(w * 0.12)
    local top = math.floor(h * 0.14)

    love.graphics.setFont(font_title)
    love.graphics.setColor(colors.bright)
    love.graphics.print("ASHLINE", left, top)

    love.graphics.setFont(font)
    love.graphics.setColor(colors.dim)
    love.graphics.print("A terminal investigation about hidden people, buried doctrine, and the price of truth.", left + 4, top + 58)
    love.graphics.print("Meridian survives by omission. Your shift begins where the lie gets expensive.", left + 4, top + 82)

    local quote_y = top + 150
    love.graphics.setColor(colors.cyan)
    love.graphics.print('"Every buried population eventually learns to count the hands that buried it."', left + 4, quote_y)

    local menu_x = math.floor(w * 0.14)
    local menu_y = math.floor(h * 0.48)
    local menu_w = math.floor(w * 0.32)
    local menu_h = 176
    drawBox(menu_x, menu_y, menu_w, menu_h)

    love.graphics.setFont(font_bold)
    love.graphics.setColor(colors.header)
    love.graphics.print("TERMINAL ACCESS", menu_x + 18, menu_y + 18)

    love.graphics.setFont(font)
    for i, option in ipairs(TITLE_OPTIONS) do
        local selected = i == title_index
        love.graphics.setColor(selected and colors.bright or colors.text)
        love.graphics.print((selected and "> " or "  ") .. option, menu_x + 22, menu_y + 54 + (i - 1) * 30)
    end

    local right_x = math.floor(w * 0.54)
    local right_y = math.floor(h * 0.48)
    drawBox(right_x, right_y, math.floor(w * 0.32), 176)
    love.graphics.setFont(font_bold)
    love.graphics.setColor(colors.header)
    love.graphics.print("RUNTIME NOTES", right_x + 18, right_y + 18)
    love.graphics.setFont(font)
    love.graphics.setColor(colors.text)
    love.graphics.print("Average target length: ~2 hours", right_x + 18, right_y + 54)
    love.graphics.print("Keyboard only. Read closely. Compare often.", right_x + 18, right_y + 82)
    love.graphics.print("Alt+Enter toggles fullscreen at any time.", right_x + 18, right_y + 110)

    love.graphics.setColor(colors.dim)
    love.graphics.print("Up/Down navigate  Enter select", left + 4, h - 48)
end

local function formatSettingValue(option)
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

local function drawSettingsScreen()
    local w, h = love.graphics.getDimensions()
    if settings_return_state == "pause" and terminal and game then
        drawBackground(w, h)
        local scale = math.min(w / VIRTUAL_W, h / VIRTUAL_H)
        local ox = math.floor((w - VIRTUAL_W * scale) / 2)
        local oy = math.floor((h - VIRTUAL_H * scale) / 2)
        love.graphics.push()
        love.graphics.translate(ox, oy)
        love.graphics.scale(scale, scale)
        terminal:render()
        love.graphics.pop()
    else
        drawBackground(w, h)
    end

    local box_x = math.floor(w * 0.18)
    local box_y = math.floor(h * 0.14)
    local box_w = math.floor(w * 0.64)
    local box_h = math.floor(h * 0.7)
    drawBox(box_x, box_y, box_w, box_h)

    love.graphics.setFont(font_title)
    love.graphics.setColor(colors.bright)
    love.graphics.print("SETTINGS", box_x + 26, box_y + 20)

    love.graphics.setFont(font)
    love.graphics.setColor(colors.dim)
    love.graphics.print("Changes apply immediately and persist to disk.", box_x + 28, box_y + 74)

    for i, option in ipairs(SETTINGS_OPTIONS) do
        local y = box_y + 126 + (i - 1) * 36
        local selected = i == settings_index
        love.graphics.setColor(selected and colors.bright or colors.text)
        love.graphics.print((selected and "> " or "  ") .. option.label, box_x + 32, y)

        if option.kind ~= "action" then
            local value = formatSettingValue(option)
            love.graphics.setColor(selected and colors.cyan or colors.dim)
            love.graphics.printf(value, box_x + 32, y, box_w - 64, "right")
        end
    end

    love.graphics.setColor(colors.dim)
    love.graphics.print("Left/Right adjust  Enter toggle/select  Esc back", box_x + 28, box_y + box_h - 42)
end

local function drawPauseOverlay()
    local w, h = love.graphics.getDimensions()
    drawBackground(w, h)

    local scale = math.min(w / VIRTUAL_W, h / VIRTUAL_H)
    local ox = math.floor((w - VIRTUAL_W * scale) / 2)
    local oy = math.floor((h - VIRTUAL_H * scale) / 2)
    love.graphics.push()
    love.graphics.translate(ox, oy)
    love.graphics.scale(scale, scale)
    terminal:render()
    love.graphics.pop()

    love.graphics.setColor(0, 0, 0, 0.45)
    love.graphics.rectangle("fill", 0, 0, w, h)

    local box_x = math.floor(w * 0.35)
    local box_y = math.floor(h * 0.26)
    local box_w = math.floor(w * 0.3)
    local box_h = 210
    drawBox(box_x, box_y, box_w, box_h)

    love.graphics.setFont(font_large)
    love.graphics.setColor(colors.bright)
    love.graphics.print("PAUSED", box_x + 24, box_y + 20)

    love.graphics.setFont(font)
    for i, option in ipairs(PAUSE_OPTIONS) do
        local selected = i == pause_index
        love.graphics.setColor(selected and colors.bright or colors.text)
        love.graphics.print((selected and "> " or "  ") .. option, box_x + 30, box_y + 74 + (i - 1) * 30)
    end
end

local function drawScaledTerminal()
    local w, h = love.graphics.getDimensions()
    local scale = math.min(w / VIRTUAL_W, h / VIRTUAL_H)
    local ox = math.floor((w - VIRTUAL_W * scale) / 2)
    local oy = math.floor((h - VIRTUAL_H * scale) / 2)
    love.graphics.push()
    love.graphics.translate(ox, oy)
    love.graphics.scale(scale, scale)
    terminal:render()
    love.graphics.pop()
end

local function executeCommand()
    local trimmed = input_text:match("^%s*(.-)%s*$")
    if #trimmed == 0 then return end

    terminal:addSegments({
        {text = "> ", color = colors.prompt},
        {text = trimmed, color = colors.input_text},
    }, true)

    table.insert(command_history, trimmed)
    history_index = #command_history + 1

    terminal:setTypewriterSpeed(settings.text_speed)
    local result = commands.execute(game, trimmed)

    if result == "CLEAR" then
        terminal:clear()
        updateHeader()
    elseif result == "LOGOUT" then
        terminal:addBlank()
        terminal:addSegments({{text = "  Session terminated. Goodbye, Operator.", color = colors.dim}}, true)
        terminal:addBlank(true)
        terminal:showInput(false)
        game.phase = "ending"
        ending_displayed = true
        ending_done = true
    elseif type(result) == "table" then
        terminal:addBlank()
        for _, line in ipairs(result) do
            terminal:addSegments(line)
        end
    end

    if game.phase == "ending" and not ending_displayed then
        terminal:showInput(false)
    end

    input_text = ""
    input_cursor = 0
    updateInput()
    updateHeader()
    sound:click()
end

local function adjustSetting(direction)
    local option = SETTINGS_OPTIONS[settings_index]
    if not option or option.kind == "action" then return end

    if option.kind == "bool" then
        settings[option.key] = not settings[option.key]
    elseif option.kind == "number" then
        settings[option.key] = math.min(option.max, math.max(option.min, settings[option.key] + option.step * direction))
    elseif option.kind == "enum" then
        local values = option.values
        local current_index = 1
        for i, value in ipairs(values) do
            if value == settings[option.key] then
                current_index = i
                break
            end
        end
        current_index = current_index + direction
        if current_index < 1 then current_index = #values end
        if current_index > #values then current_index = 1 end
        settings[option.key] = values[current_index]
    end

    applySettings(true)
    sound:click()
end

local function selectTitleOption()
    local option = TITLE_OPTIONS[title_index]
    if option == "NEW SESSION" then
        startSession()
    elseif option == "SETTINGS" then
        openSettings("title")
    elseif option == "QUIT" then
        love.event.quit()
    end
end

local function selectPauseOption()
    local option = PAUSE_OPTIONS[pause_index]
    if option == "RESUME" then
        app_state = "game"
    elseif option == "SETTINGS" then
        openSettings("pause")
    elseif option == "RESTART SESSION" then
        startSession()
    elseif option == "QUIT TO TITLE" then
        returnToTitle()
    end
end

local function selectSettingsOption()
    local option = SETTINGS_OPTIONS[settings_index]
    if option.kind == "action" then
        closeSettings()
    else
        adjustSetting(1)
    end
end

function love.load()
    love.keyboard.setKeyRepeat(true)

    settings = Settings.load()

    font = love.graphics.newFont("ibm_plex_mono/IBMPlexMono-Regular.ttf", 15)
    font_bold = love.graphics.newFont("ibm_plex_mono/IBMPlexMono-Bold.ttf", 15)
    font_large = love.graphics.newFont("ibm_plex_mono/IBMPlexMono-Bold.ttf", 24)
    font_title = love.graphics.newFont("ibm_plex_mono/IBMPlexMono-Bold.ttf", 42)

    terminal = Terminal.new(font, font_bold, VIRTUAL_W, VIRTUAL_H)

    sound = Sound.new()
    sound:load()
    terminal.on_click = function() sound:click() end

    ensureEffect()
    applySettings(false)
    sound:startAmbient()
end

function love.update(dt)
    if app_state == "boot" and game and game.phase == "boot" and not boot_done then
        boot_timer = boot_timer + dt
        while boot_index < #boot_sequence do
            local entry = boot_sequence[boot_index + 1]
            if boot_timer >= entry.delay then
                boot_timer = boot_timer - entry.delay
                boot_index = boot_index + 1
                if #entry.segments > 0 then
                    terminal:addSegments(entry.segments, true)
                    sound:click()
                else
                    terminal:addBlank(true)
                end

                if boot_index >= #boot_sequence then
                    boot_done = true
                    game:start()
                    app_state = "game"
                    terminal:showInput(true)
                    updateHeader()
                    updateStatus()
                    updateInput()
                    break
                end
            else
                break
            end
        end
    end

    if app_state == "game" and game and (game.phase == "main" or game.phase == "ending") then
        local prev_unread = last_unread
        game:update(dt)
        last_unread = game:getUnreadCount()

        if last_unread > prev_unread then
            notification_timer = 4.0
            sound:chime()
            updateHeader()

            local newest = game.inbox[#game.inbox]
            if newest then
                terminal:addBlank()
                terminal:addSegments({{text = "  +===================================================+", color = colors.cyan}}, true)
                terminal:addSegments({
                    {text = "  |  ", color = colors.cyan},
                    {text = "NEW MESSAGE", color = colors.bright},
                    {text = " from ", color = colors.dim},
                    {text = newest.message.from, color = newest.message.from == "UNKNOWN TERMINAL" and colors.amber or colors.text},
                }, true)
                terminal:addSegments({
                    {text = "  |  ", color = colors.cyan},
                    {text = "Subject: ", color = colors.dim},
                    {text = newest.message.subject, color = colors.text},
                }, true)
                terminal:addSegments({
                    {text = "  |  ", color = colors.cyan},
                    {text = "Type INBOX to view. READ MSG " .. #game.inbox .. " to read.", color = colors.dim},
                }, true)
                terminal:addSegments({{text = "  +===================================================+", color = colors.cyan}}, true)
                terminal:addBlank(true)
            end
        end

        if game.phase == "ending" and not ending_displayed and not terminal:isTyping() then
            local ending_data = data.endings[game.ending]
            if ending_data then
                ending_displayed = true
                terminal:addBlank()
                terminal:addBlank()

                terminal:setTypewriterSpeed(math.max(4, math.floor(settings.text_speed / 20)))
                for _, line_data in ipairs(ending_data.lines) do
                    terminal:addSegments({{text = line_data.text, color = line_data.color}})
                end
                terminal:addBlank()
                terminal:addSegments({{text = "  ======================================================", color = colors.border}})
                terminal:addBlank()
                terminal:addSegments({{text = "  ASHLINE", color = colors.bright}})
                terminal:addSegments({{text = "  An archive of pressure, omission, and choice", color = colors.dim}})
                terminal:addBlank()
                terminal:addSegments({{text = '  Ending: "' .. ending_data.title .. '"', color = colors.amber}})
                terminal:addSegments({{text = "  Proof gathered: " .. math.floor(game.proof_score), color = colors.text}})
                terminal:addSegments({{text = "  Audit risk: " .. tostring(game.audit_risk) .. "  |  Silo strain: " .. tostring(game.strain), color = colors.text}})
                terminal:addSegments({{text = "  Records examined: " .. countTable(game.records_read), color = colors.text}})
                terminal:addSegments({{text = "  Personnel reviewed: " .. countTable(game.personnel_viewed), color = colors.text}})
                terminal:addBlank()
                terminal:addSegments({{text = "  Press Escape for the pause menu when you are done reading.", color = colors.dim}})
                terminal:addBlank()
                terminal:addSegments({{text = "  ======================================================", color = colors.border}})

                ending_done = true
                terminal:showInput(false)
                sound:playTension()
            end
        end

        if notification_timer > 0 then
            notification_timer = notification_timer - dt
        end

        terminal:update(dt)
        updateStatus()
    end
end

function love.draw()
    local w, h = love.graphics.getDimensions()
    if w ~= last_w or h ~= last_h then
        if effect then effect.resize(w, h) end
        last_w, last_h = w, h
    end

    local function draw_content()
        if app_state == "title" then
            drawTitleScreen()
        elseif app_state == "settings" then
            drawSettingsScreen()
        elseif app_state == "pause" then
            drawPauseOverlay()
        else
            love.graphics.setColor(colors.bg)
            love.graphics.rectangle("fill", 0, 0, w, h)
            if terminal then
                drawScaledTerminal()
            end
        end
    end

    if settings.post_effects and effect then
        effect(draw_content)
    else
        draw_content()
    end
end

function love.resize(w, h)
    if effect then effect.resize(w, h) end
    last_w, last_h = w, h
end

function love.textinput(text)
    if app_state ~= "game" or not game or game.phase ~= "main" then return end
    if terminal:isTyping() then
        terminal:flushTypewriter()
        return
    end

    input_text = input_text:sub(1, input_cursor) .. text .. input_text:sub(input_cursor + 1)
    input_cursor = input_cursor + #text
    updateInput()
    sound:click()
end

function love.keypressed(key, scancode, isrepeat)
    if not isrepeat and (key == "return" or key == "kpenter") and (love.keyboard.isDown("lalt") or love.keyboard.isDown("ralt")) then
        toggleFullscreen()
        return
    end

    if app_state == "title" then
        if key == "up" and not isrepeat then
            title_index = ((title_index - 2) % #TITLE_OPTIONS) + 1
            sound:click()
        elseif key == "down" and not isrepeat then
            title_index = (title_index % #TITLE_OPTIONS) + 1
            sound:click()
        elseif (key == "return" or key == "kpenter") and not isrepeat then
            sound:click()
            selectTitleOption()
        elseif key == "escape" and not isrepeat then
            love.event.quit()
        end
        return
    end

    if app_state == "settings" then
        if key == "up" and not isrepeat then
            settings_index = ((settings_index - 2) % #SETTINGS_OPTIONS) + 1
            sound:click()
        elseif key == "down" and not isrepeat then
            settings_index = (settings_index % #SETTINGS_OPTIONS) + 1
            sound:click()
        elseif key == "left" and not isrepeat then
            adjustSetting(-1)
        elseif key == "right" and not isrepeat then
            adjustSetting(1)
        elseif (key == "return" or key == "kpenter") and not isrepeat then
            sound:click()
            selectSettingsOption()
        elseif key == "escape" and not isrepeat then
            sound:click()
            closeSettings()
        end
        return
    end

    if app_state == "pause" then
        if key == "up" and not isrepeat then
            pause_index = ((pause_index - 2) % #PAUSE_OPTIONS) + 1
            sound:click()
        elseif key == "down" and not isrepeat then
            pause_index = (pause_index % #PAUSE_OPTIONS) + 1
            sound:click()
        elseif (key == "return" or key == "kpenter") and not isrepeat then
            sound:click()
            selectPauseOption()
        elseif key == "escape" and not isrepeat then
            app_state = "game"
            sound:click()
        end
        return
    end

    if app_state == "boot" then
        if key == "return" or key == "space" then
            while boot_index < #boot_sequence do
                boot_index = boot_index + 1
                local entry = boot_sequence[boot_index]
                if #entry.segments > 0 then
                    terminal:addSegments(entry.segments, true)
                else
                    terminal:addBlank(true)
                end
            end
            boot_done = true
            game:start()
            app_state = "game"
            terminal:showInput(true)
            updateHeader()
            updateStatus()
            updateInput()
        elseif key == "escape" and not isrepeat then
            returnToTitle()
        end
        return
    end

    if app_state ~= "game" or not game then return end

    if game.phase == "ending" then
        if terminal:isTyping() then
            terminal:flushTypewriter()
        elseif key == "escape" and not isrepeat then
            app_state = "pause"
            pause_index = 1
            sound:click()
        end
        return
    end

    if game.phase ~= "main" then return end

    if terminal:isTyping() then
        if key == "return" or key == "space" or key == "escape" then
            terminal:flushTypewriter()
        end
        return
    end

    if key == "return" and not isrepeat then
        executeCommand()
    elseif key == "backspace" then
        if input_cursor > 0 then
            input_text = input_text:sub(1, input_cursor - 1) .. input_text:sub(input_cursor + 1)
            input_cursor = input_cursor - 1
            updateInput()
        end
    elseif key == "delete" then
        if input_cursor < #input_text then
            input_text = input_text:sub(1, input_cursor) .. input_text:sub(input_cursor + 2)
            updateInput()
        end
    elseif key == "left" then
        input_cursor = math.max(0, input_cursor - 1)
        updateInput()
    elseif key == "right" then
        input_cursor = math.min(#input_text, input_cursor + 1)
        updateInput()
    elseif key == "home" then
        input_cursor = 0
        updateInput()
    elseif key == "end" then
        input_cursor = #input_text
        updateInput()
    elseif key == "tab" and not isrepeat then
        local completed = commands.applyCompletion(input_text, game)
        if completed ~= input_text then
            input_text = completed
            input_cursor = #input_text
            updateInput()
            sound:click()
        end
    elseif key == "up" then
        if #command_history > 0 then
            history_index = math.max(1, history_index - 1)
            input_text = command_history[history_index]
            input_cursor = #input_text
            updateInput()
        end
    elseif key == "down" then
        if history_index < #command_history then
            history_index = history_index + 1
            input_text = command_history[history_index]
            input_cursor = #input_text
            updateInput()
        else
            history_index = #command_history + 1
            input_text = ""
            input_cursor = 0
            updateInput()
        end
    elseif key == "pageup" then
        terminal:scrollUp(5)
    elseif key == "pagedown" then
        terminal:scrollDown(5)
    elseif key == "escape" and not isrepeat then
        if #input_text > 0 then
            input_text = ""
            input_cursor = 0
            updateInput()
        else
            app_state = "pause"
            pause_index = 1
            sound:click()
        end
    end
end

function love.wheelmoved(_, y)
    if app_state ~= "game" or not terminal then return end
    if y > 0 then
        terminal:scrollUp(3)
    elseif y < 0 then
        terminal:scrollDown(3)
    end
end

function love.quit()
    saveSettings()
end
