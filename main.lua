love.filesystem.setRequirePath("lib/?.lua;lib/?/init.lua;" .. love.filesystem.getRequirePath())

local moonshine = require("moonshine")
local colors = require("colors")
local Display = require("display")
local Sound = require("sound")
local Terminal = require("terminal")
local Game = require("game")
local MenuUI = require("menu_ui")
local boot = require("boot")
local commands = require("commands")
local data = require("data")
local Settings = require("settings")
local Save = require("save")
local utf8_utils = require("utf8_utils")
local locale = require("locale")

local VIRTUAL_W = Display.virtual_w
local VIRTUAL_H = Display.virtual_h

local terminal
local game
local sound
local effect
local menu_ui
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

local save_notice = ""
local save_notice_timer = 0

local getViewport

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

local function utf8_len(text)
    return utf8_utils.len(text)
end

local function utf8_sub(text, i, j)
    return utf8_utils.sub(text, i, j)
end

local function clampInputCursor(text, cursor)
    return math.max(0, math.min(utf8_len(text), cursor or utf8_len(text)))
end

local function boxLineSegments(segments, total_width, border_color)
    local len = 0
    for _, seg in ipairs(segments) do
        len = len + utf8_len(seg.text or "")
    end
    local result = {}
    for _, seg in ipairs(segments) do
        table.insert(result, seg)
    end
    local pad = total_width - len - 1
    if pad > 0 then
        table.insert(result, {text = string.rep(" ", pad), color = border_color})
    end
    table.insert(result, {text = "|", color = border_color})
    return result
end

local function setSaveNotice(text, duration)
    save_notice = text or ""
    save_notice_timer = duration or 4.0
end

local function buildSavePayload()
    local saved_at = os.date and os.date("%Y-%m-%d %H:%M:%S") or "UNKNOWN"
    return {
        saved_at = saved_at,
        app = {
            input_text = input_text,
            input_cursor = input_cursor,
            command_history = command_history,
            history_index = history_index,
        },
        game = game and game:serialize() or nil,
    }
end

local function autosaveGame()
    if not game or (game.phase ~= "main" and game.phase ~= "ending") then
        return false
    end

    local ok, err = Save.save(nil, buildSavePayload())
    if not ok then
        setSaveNotice("SAVE FAILED: " .. tostring(err), 5.0)
        return false
    end
    return true
end

local function restoreTerminalForSession(message)
    terminal:clear()
    terminal:setGhost("")
    terminal:setTypewriterSpeed(settings.text_speed)
    terminal:addBlank(true)
    terminal:addSegments({{text = "  +===================================================+", color = colors.cyan}}, true)
    terminal:addSegments({{text = "  |  " .. message, color = colors.bright}}, true)
    terminal:addSegments({{text = "  |  Type TASKS to reorient. INBOX shows pending threads.", color = colors.dim}}, true)
    terminal:addSegments({{text = "  +===================================================+", color = colors.cyan}}, true)
    terminal:addBlank(true)
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

local function buildEffectChain(width, height)
    local chain = moonshine(width, height, moonshine.effects.scanlines)
        .chain(moonshine.effects.crt)
        .chain(moonshine.effects.glow)
        .chain(moonshine.effects.vignette)
        .chain(moonshine.effects.filmgrain)

    chain.scanlines.opacity = 0.12
    chain.scanlines.thickness = 0.8
    chain.crt.distortionFactor = {1.03, 1.035}
    chain.crt.feather = 0.02
    chain.glow.min_luma = 0.3
    chain.glow.strength = 3
    chain.vignette.opacity = 0.3
    chain.vignette.softness = 0.8
    chain.filmgrain.opacity = 0.03
    chain.filmgrain.size = 1.5

    return chain
end

local function syncEffectState(force_rebuild)
    local ww, wh = love.graphics.getDimensions()
    last_w, last_h = ww, wh

    if not settings or not settings.post_effects then
        effect = nil
        return
    end

    if force_rebuild or not effect then
        effect = buildEffectChain(ww, wh)
    else
        effect.resize(ww, wh)
    end
end

local function saveSettings()
    Settings.save(settings)
end

local function applySettings(persist)
    settings = Settings.clamp(settings)
    local fullscreen_changed = false
    local effects_were_enabled = effect ~= nil

    locale.setLanguage(settings.language or "en")
    data.applyLanguage(settings.language or "en")

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
        fullscreen_changed = true
    end

    if settings.post_effects then
        syncEffectState(fullscreen_changed or not effects_were_enabled)
    else
        effect = nil
        last_w, last_h = love.graphics.getDimensions()
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
        {text = locale.t("hdr_alerts") .. ":", color = alert_color},
        {text = tostring(game.alert_count), color = alert_color},
        {text = "  ", color = colors.bg},
        {text = locale.t("hdr_inbox") .. ":", color = inbox_color},
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
    Save.delete()
    game = Game.new()
    if menu_ui then
        menu_ui:deactivate()
    end

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

local function continueSession()
    local payload, source = Save.load()
    if not payload or not payload.game then
        setSaveNotice("No valid save could be restored.", 5.0)
        return
    end

    resetInputState()
    game = Game.fromSnapshot(payload.game)
    if menu_ui then
        menu_ui:deactivate()
    end

    if payload.app then
        command_history = payload.app.command_history or {}
        history_index = payload.app.history_index or (#command_history + 1)
        history_index = math.max(1, math.min(#command_history + 1, history_index))
        input_text = payload.app.input_text or ""
        input_cursor = clampInputCursor(input_text, payload.app.input_cursor)
    else
        history_index = #command_history + 1
        input_text = ""
        input_cursor = 0
    end

    boot_done = true
    boot_index = #boot_sequence
    boot_timer = 0
    ending_displayed = false
    ending_done = false
    app_state = "game"

    terminal:showInput(game.phase == "main")
    restoreTerminalForSession(source == "backup" and "SESSION RESTORED FROM BACKUP SAVE" or "SESSION RESTORED")
    updateHeader()
    updateStatus()
    updateInput()
    setSaveNotice(source == "backup" and "Primary save was damaged. Backup restored." or "Session restored.", 4.0)
end

local function returnToTitle()
    autosaveGame()
    app_state = "title"
    settings_return_state = "title"
    if menu_ui then
        menu_ui:resetTitle()
    end
    if terminal then
        terminal:showInput(false)
    end
end

local function openSettings(from_state)
    settings_return_state = from_state or "title"
    if menu_ui then
        menu_ui:enterSettings()
    end
    app_state = "settings"
end

local function closeSettings()
    if menu_ui then
        menu_ui:deactivate()
    end
    app_state = settings_return_state
end

getViewport = function()
    local w, h = love.graphics.getDimensions()
    local scale = math.min(w / VIRTUAL_W, h / VIRTUAL_H)
    local ox = math.floor((w - VIRTUAL_W * scale) * 0.5)
    local oy = math.floor((h - VIRTUAL_H * scale) * 0.5)
    return w, h, scale, ox, oy
end

local function renderVirtual(draw_fn)
    local _, _, scale, ox, oy = getViewport()
    love.graphics.push()
    love.graphics.translate(ox, oy)
    love.graphics.scale(scale, scale)
    draw_fn(VIRTUAL_W, VIRTUAL_H)
    love.graphics.pop()
end

local function drawScaledTerminal()
    terminal:render()
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
    autosaveGame()
    sound:click()
end

local function adjustSetting(option, direction)
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

function love.load()
    love.keyboard.setKeyRepeat(true)

    settings = Settings.load()
    last_w, last_h = love.graphics.getDimensions()

    font = love.graphics.newFont("assets/fonts/IBMPlexMono-Regular.ttf", 18)
    font_bold = love.graphics.newFont("assets/fonts/IBMPlexMono-Bold.ttf", 18)
    font_large = love.graphics.newFont("assets/fonts/IBMPlexMono-Bold.ttf", 24)
    font_title = love.graphics.newFont("assets/fonts/IBMPlexMono-Bold.ttf", 42)

    -- Size virtual resolution to fit a 110-column terminal
    local term_cw = font:getWidth("A")
    local term_w = 110 * term_cw + 40

    local term_pad_y = 24
    local term_h = VIRTUAL_H - term_pad_y * 2
    terminal = Terminal.new(font, font_bold, term_w, term_h)
    terminal.offset_x = math.floor((VIRTUAL_W - term_w) / 2)
    terminal.offset_y = term_pad_y

    sound = Sound.new()
    sound:load()
    terminal.on_click = function() sound:click() end

    menu_ui = MenuUI.new({
        colors = colors,
        Save = Save,
        font = font,
        font_bold = font_bold,
        font_large = font_large,
        font_title = font_title,
        get_viewport = getViewport,
        get_virtual_size = function()
            return VIRTUAL_W, VIRTUAL_H
        end,
        get_settings = function()
            return settings
        end,
        get_settings_return_state = function()
            return settings_return_state
        end,
        get_save_notice = function()
            if save_notice_timer > 0 then
                return save_notice
            end
            return ""
        end,
        get_save_metadata = function()
            return Save.getMetadata()
        end,
        on_title_select = function(option)
            if option == "CONTINUE SESSION" then
                continueSession()
            elseif option == "NEW SESSION" then
                startSession()
            elseif option == "SETTINGS" then
                menu_ui:requestTransition(function()
                    openSettings("title")
                end)
            elseif option == "QUIT" then
                love.event.quit()
            end
        end,
        on_pause_select = function(option)
            if option == "RESUME" then
                menu_ui:requestTransition(function()
                    if menu_ui then
                        menu_ui:deactivate()
                    end
                    app_state = "game"
                end, 0.18)
            elseif option == "RESTART SESSION" then
                menu_ui:requestTransition(function()
                    startSession()
                end)
            elseif option == "QUIT TO TITLE" then
                menu_ui:requestTransition(function()
                    returnToTitle()
                end)
            end
        end,
        on_adjust_setting = function(option, direction)
            adjustSetting(option, direction)
        end,
        on_close_settings = function()
            menu_ui:requestTransition(function()
                closeSettings()
            end)
        end,
        on_click = function()
            sound:click()
        end,
    })

    applySettings(false)
    sound:startAmbient()
    boot_sequence = boot.getSequence()
end

function love.update(dt)
    if menu_ui then
        menu_ui:update(app_state, dt)
    end

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
                    autosaveGame()
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
            autosaveGame()

            local newest = game.inbox[#game.inbox]
            if newest then
                local BOX_W = 68
                local box_border = "  +" .. string.rep("=", BOX_W - 4) .. "+"
                terminal:addBlank()
                terminal:addSegments({{text = box_border, color = colors.cyan}}, true)
                terminal:addSegments(boxLineSegments({
                    {text = "  |  ", color = colors.cyan},
                    {text = locale.t("notification_new_message"), color = colors.bright},
                    {text = locale.t("notification_from"), color = colors.dim},
                    {text = newest.message.from, color = newest.message.from == "UNKNOWN TERMINAL" and colors.amber or colors.text},
                }, BOX_W, colors.cyan), true)
                terminal:addSegments(boxLineSegments({
                    {text = "  |  ", color = colors.cyan},
                    {text = locale.t("notification_subject"), color = colors.dim},
                    {text = newest.message.subject, color = colors.text},
                }, BOX_W, colors.cyan), true)
                terminal:addSegments(boxLineSegments({
                    {text = "  |  ", color = colors.cyan},
                    {text = string.format(locale.t("notification_read"), #game.inbox), color = colors.dim},
                }, BOX_W, colors.cyan), true)
                terminal:addSegments({{text = box_border, color = colors.cyan}}, true)
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
                autosaveGame()
            end
        end

        if notification_timer > 0 then
            notification_timer = notification_timer - dt
        end
        if save_notice_timer > 0 then
            save_notice_timer = math.max(0, save_notice_timer - dt)
        end

        terminal:update(dt)
        updateHeader()
        updateStatus()
    elseif save_notice_timer > 0 then
        save_notice_timer = math.max(0, save_notice_timer - dt)
    end
end

function love.draw()
    local w, h = love.graphics.getDimensions()
    if w ~= last_w or h ~= last_h then
        if settings and settings.post_effects then
            syncEffectState(false)
        else
            last_w, last_h = w, h
        end
    end

    local function draw_content()
        love.graphics.setColor(colors.bg)
        love.graphics.rectangle("fill", 0, 0, w, h)

        renderVirtual(function(vw, vh)
            local in_game = game and (app_state == "game" or app_state == "boot" or app_state == "pause")
            if in_game and terminal then
                drawScaledTerminal()
            end
            if menu_ui then
                menu_ui:draw(app_state, vw, vh)
            end
        end)
    end

    if settings.post_effects and effect then
        love.graphics.setColor(1, 1, 1, 1)
        effect(draw_content)
        love.graphics.setColor(1, 1, 1, 1)
    else
        love.graphics.setColor(1, 1, 1, 1)
        draw_content()
    end
end

function love.resize(w, h)
    last_w, last_h = w, h
    if settings and settings.post_effects then
        syncEffectState(true)
    end
end

function love.textinput(text)
    if app_state ~= "game" or not game or game.phase ~= "main" then return end
    if terminal:isTyping() then
        terminal:flushTypewriter()
        return
    end

    input_text = utf8_sub(input_text, 1, input_cursor) .. text .. utf8_sub(input_text, input_cursor + 1)
    input_cursor = input_cursor + utf8_len(text)
    updateInput()
    sound:click()
end

function love.keypressed(key, scancode, isrepeat)
    if not isrepeat and (key == "return" or key == "kpenter") and (love.keyboard.isDown("lalt") or love.keyboard.isDown("ralt")) then
        toggleFullscreen()
        return
    end

    if menu_ui and menu_ui:keypressed(app_state, key, isrepeat) then
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
            autosaveGame()
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
            if menu_ui then
                menu_ui:enterPause()
            end
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
            input_text = utf8_sub(input_text, 1, input_cursor - 1) .. utf8_sub(input_text, input_cursor + 1)
            input_cursor = input_cursor - 1
            updateInput()
        end
    elseif key == "delete" then
        if input_cursor < utf8_len(input_text) then
            input_text = utf8_sub(input_text, 1, input_cursor) .. utf8_sub(input_text, input_cursor + 2)
            updateInput()
        end
    elseif key == "left" then
        input_cursor = math.max(0, input_cursor - 1)
        updateInput()
    elseif key == "right" then
        input_cursor = math.min(utf8_len(input_text), input_cursor + 1)
        updateInput()
    elseif key == "home" then
        input_cursor = 0
        updateInput()
    elseif key == "end" then
        input_cursor = utf8_len(input_text)
        updateInput()
    elseif key == "tab" and not isrepeat then
        local completed = commands.applyCompletion(input_text, game)
        if completed ~= input_text then
            input_text = completed
            input_cursor = utf8_len(input_text)
            updateInput()
            sound:click()
        end
    elseif key == "up" then
        if #command_history > 0 then
            history_index = math.max(1, history_index - 1)
            input_text = command_history[history_index]
            input_cursor = utf8_len(input_text)
            updateInput()
        end
    elseif key == "down" then
        if history_index < #command_history then
            history_index = history_index + 1
            input_text = command_history[history_index]
            input_cursor = utf8_len(input_text)
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
            if menu_ui then
                menu_ui:enterPause()
            end
            sound:click()
        end
    end
end

function love.mousemoved(x, y)
    if menu_ui and menu_ui:mousemoved(app_state, x, y) then
        return
    end
end

function love.mousepressed(x, y, button)
    if menu_ui and menu_ui:mousepressed(app_state, x, y, button) then
        return
    end
end

function love.wheelmoved(_, y)
    if menu_ui and menu_ui:wheelmoved(app_state, y) then
        return
    end

    if app_state ~= "game" or not terminal then return end
    if y > 0 then
        terminal:scrollUp(3)
    elseif y < 0 then
        terminal:scrollDown(3)
    end
end

function love.quit()
    autosaveGame()
    saveSettings()
end
