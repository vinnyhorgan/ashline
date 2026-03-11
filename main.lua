local moonshine = require("moonshine")
local colors = require("colors")
local Sound = require("sound")
local Terminal = require("terminal")
local Game = require("game")
local boot = require("boot")
local commands = require("commands")
local data = require("data")

local VIRTUAL_W = 1280
local VIRTUAL_H = 800

local terminal
local game
local sound
local effect
local render_canvas
local font, font_bold

local input_text = ""
local input_cursor = 0
local command_history = {}
local history_index = 0

-- boot sequence state
local boot_sequence = {}
local boot_index = 0
local boot_timer = 0
local boot_done = false

-- message notification
local notification_timer = 0
local notification_text = ""
local last_unread = 0

-- ending display
local ending_displayed = false
local ending_done = false

local function countTable(t)
    local n = 0
    for _ in pairs(t) do n = n + 1 end
    return n
end

function love.load()
    love.keyboard.setKeyRepeat(true)

    font = love.graphics.newFont("ibm_plex_mono/IBMPlexMono-Regular.ttf", 15)
    font_bold = love.graphics.newFont("ibm_plex_mono/IBMPlexMono-Bold.ttf", 15)

    terminal = Terminal.new(font, font_bold, VIRTUAL_W, VIRTUAL_H)

    game = Game.new()

    sound = Sound.new()
    sound:load()
    sound:startAmbient()

    terminal.on_click = function() sound:click() end

    render_canvas = love.graphics.newCanvas(VIRTUAL_W, VIRTUAL_H)

    effect = moonshine(VIRTUAL_W, VIRTUAL_H, moonshine.effects.scanlines)
        .chain(moonshine.effects.crt)
        .chain(moonshine.effects.glow)
        .chain(moonshine.effects.vignette)
        .chain(moonshine.effects.filmgrain)

    effect.scanlines.opacity = 0.25
    effect.scanlines.thickness = 0.8
    effect.crt.distortionFactor = {1.03, 1.035}
    effect.crt.feather = 0.02
    effect.glow.min_luma = 0.25
    effect.glow.strength = 3
    effect.vignette.opacity = 0.35
    effect.vignette.softness = 0.8
    effect.filmgrain.opacity = 0.03
    effect.filmgrain.size = 1.5

    boot_sequence = boot.getSequence()
    boot_index = 0
    boot_timer = 0

    updateHeader()
    updateStatus()
end

function updateHeader()
    local alert_color = game.alert_count > 0 and colors.amber or colors.dim
    local inbox_color = game:getUnreadCount() > 0 and colors.cyan or colors.dim

    -- game clock: shift starts at 22:00, 1 real sec = 15 game seconds
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

function updateStatus()
    local phase_text = "MONITORING"
    local phase_color = colors.bright
    if game.phase == "boot" then
        phase_text = "INITIALIZING"
        phase_color = colors.amber
    elseif game.ending then
        phase_text = "SESSION ENDING"
        phase_color = colors.red
    end

    terminal:setStatus({
        {text = " STATUS:", color = colors.dim},
        {text = phase_text, color = phase_color},
        {text = "  |  ", color = colors.border},
        {text = "OPERATOR:", color = colors.dim},
        {text = "CIV-0031", color = colors.text},
        {text = "  |  ", color = colors.border},
        {text = "CLEARANCE:", color = colors.dim},
        {text = "LV-2", color = colors.text},
        {text = "  |  ", color = colors.border},
        {text = "SCORE:", color = colors.dim},
        {text = tostring(math.floor(game.investigation_score)), color = colors.bright},
    })
end

function love.update(dt)
    -- boot phase
    if game.phase == "boot" and not boot_done then
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
                    terminal:showInput(true)
                    updateHeader()
                    updateStatus()
                    break
                end
            else
                break
            end
        end
    end

    -- game update
    if game.phase == "main" or game.phase == "ending" then
        local prev_unread = last_unread
        game:update(dt)
        last_unread = game:getUnreadCount()

        if last_unread > prev_unread then
            notification_timer = 4.0
            notification_text = "NEW MESSAGE"
            sound:chime()
            updateHeader()

            local newest = game.inbox[#game.inbox]
            if newest then
                terminal:addBlank()
                terminal:addSegments({
                    {text = "  +===================================================+", color = colors.cyan},
                }, true)
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
                terminal:addSegments({
                    {text = "  +===================================================+", color = colors.cyan},
                }, true)
                terminal:addBlank(true)
            end
        end
    end

    -- ending sequence
    if game.phase == "ending" and not ending_displayed and not terminal:isTyping() then
        local ending_data = data.endings[game.ending]
        if ending_data then
            ending_displayed = true
            terminal:addBlank()
            terminal:addBlank()

            terminal:setTypewriterSpeed(4)
            for _, line_data in ipairs(ending_data.lines) do
                terminal:addSegments({{text = line_data.text, color = line_data.color}})
            end
            terminal:addBlank()
            terminal:addSegments({{text = "  ======================================================", color = colors.border}})
            terminal:addBlank()
            terminal:addSegments({{text = "  ASHLINE", color = colors.bright}})
            terminal:addSegments({{text = "  A terminal narrative by Copilot & You", color = colors.dim}})
            terminal:addBlank()
            terminal:addSegments({{text = '  Ending: "' .. ending_data.title .. '"', color = colors.amber}})
            terminal:addSegments({{text = "  Investigation score: " .. math.floor(game.investigation_score), color = colors.text}})
            terminal:addSegments({{text = "  Records examined: " .. countTable(game.records_read), color = colors.text}})
            terminal:addSegments({{text = "  Personnel reviewed: " .. countTable(game.personnel_viewed), color = colors.text}})
            terminal:addBlank()
            terminal:addSegments({{text = "  Thank you for playing.", color = colors.bright}})
            terminal:addBlank()
            terminal:addSegments({{text = "  ======================================================", color = colors.border}})

            ending_done = true
            terminal:showInput(false)
            sound:playTension()
        end
    end

    -- notification fade
    if notification_timer > 0 then
        notification_timer = notification_timer - dt
    end

    terminal:update(dt)
    updateStatus()
end

function love.draw()
    -- render at virtual resolution to canvas
    love.graphics.setCanvas(render_canvas)
    love.graphics.clear()
    effect(function()
        terminal:render()
    end)
    love.graphics.setCanvas()

    -- scale canvas to fill window
    local w, h = love.graphics.getDimensions()
    local sx = w / VIRTUAL_W
    local sy = h / VIRTUAL_H
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(render_canvas, 0, 0, 0, sx, sy)
end

function love.resize(w, h)
    -- nothing to do: virtual resolution stays fixed
end

function love.textinput(text)
    if game.phase ~= "main" then return end
    if terminal:isTyping() then
        terminal:flushTypewriter()
        return
    end

    input_text = input_text:sub(1, input_cursor) .. text .. input_text:sub(input_cursor + 1)
    input_cursor = input_cursor + #text
    updateInput()
    sound:click()
end

function love.keypressed(key)
    if game.phase == "boot" then
        if key == "return" or key == "space" then
            -- skip boot
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
            terminal:showInput(true)
            updateHeader()
            updateStatus()
        end
        return
    end

    if game.phase == "ending" then
        if terminal:isTyping() then
            terminal:flushTypewriter()
        end
        return
    end

    if game.phase ~= "main" then return end

    -- skip typewriter
    if terminal:isTyping() then
        if key == "return" or key == "space" or key == "escape" then
            terminal:flushTypewriter()
        end
        return
    end

    if key == "return" then
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
    elseif key == "tab" then
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
    elseif key == "escape" then
        input_text = ""
        input_cursor = 0
        updateInput()
    end
end

function love.wheelmoved(x, y)
    if y > 0 then
        terminal:scrollUp(3)
    elseif y < 0 then
        terminal:scrollDown(3)
    end
end

function updateInput()
    terminal:setInput(input_text, input_cursor)
    local ghost = commands.getGhostText(input_text, game)
    terminal:setGhost(ghost)
end

function executeCommand()
    local trimmed = input_text:match("^%s*(.-)%s*$")
    if #trimmed == 0 then return end

    -- echo command
    terminal:addSegments({
        {text = "> ", color = colors.prompt},
        {text = trimmed, color = colors.input_text},
    }, true)

    -- add to history
    table.insert(command_history, trimmed)
    history_index = #command_history + 1

    -- execute
    terminal:setTypewriterSpeed(1200)
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

    -- check for phase change after command
    if game.phase == "ending" and not ending_displayed then
        terminal:showInput(false)
    end

    -- clear input
    input_text = ""
    input_cursor = 0
    updateInput()
    updateHeader()

    sound:click()
end
