local colors = require("colors")
local data = require("data")

local commands = {}

local COMMAND_LIST = {
    "HELP", "TASKS", "ACTIONS", "STATUS", "ALERTS", "READ", "SEARCH", "LIST",
    "PERSONNEL", "COMPARE", "INSPECT", "TRACE", "OVERRIDE", "AUTHORIZE",
    "DENY", "INBOX", "CLEAR", "LOGOUT",
}

local RECORD_IDS = {}
for id in pairs(data.records) do
    table.insert(RECORD_IDS, id)
end
table.sort(RECORD_IDS)

local PERSONNEL_IDS = {}
for id in pairs(data.personnel) do
    table.insert(PERSONNEL_IDS, id)
end
table.sort(PERSONNEL_IDS)

local OVERRIDE_TOKENS = {}
for token in pairs(data.overrides) do
    table.insert(OVERRIDE_TOKENS, token)
end
table.sort(OVERRIDE_TOKENS)

local SYSTEM_NAMES = {"WATER", "POWER", "AIR", "POPULATION", "EXTERNAL"}
local LIST_CATEGORIES = {"INCIDENTS", "MAINTENANCE", "DIRECTIVES", "WITNESS", "ALL"}

local function seg(text, color)
    return {text = text, color = color or colors.text}
end

local function line(text, color)
    return {seg(text, color)}
end

local function blank()
    return {seg("")}
end

local function header_line(text)
    return {seg(text, colors.header)}
end

local function dim_line(text)
    return {seg(text, colors.dim)}
end

local function separator()
    return {seg("============================================================", colors.border)}
end

local function format_record_header(id, record)
    local lines = {}
    table.insert(lines, separator())
    table.insert(lines, {
        seg("  " .. record.type:upper() .. ": ", colors.dim),
        seg(id, colors.bright),
    })
    table.insert(lines, {seg("  " .. record.title, colors.header)})
    table.insert(lines, separator())
    table.insert(lines, {
        seg("  Classification: ", colors.dim),
        seg(record.classification, record.classification:find("BLACK VAULT") and colors.classified or colors.text),
    })
    table.insert(lines, {
        seg("  Date:           ", colors.dim),
        seg(record.date, colors.text),
    })
    table.insert(lines, {
        seg("  Filed by:       ", colors.dim),
        seg(record.filed_by, colors.text),
    })
    table.insert(lines, {
        seg("  Sector:         ", colors.dim),
        seg(record.sector, colors.text),
    })
    table.insert(lines, separator())
    return lines
end

local function format_record_content(record)
    local lines = {}
    for _, text in ipairs(record.content) do
        if text == "" then
            table.insert(lines, blank())
        elseif text:find("^%s*>") or text:find("WARNING") or text:find("ALERT") then
            table.insert(lines, {seg("  " .. text, colors.amber)})
        elseif text:find("^%s*NOTE") or text:find("^%s*RECOMMENDATION") or text:find("^%s*Directive note") then
            table.insert(lines, {seg("  " .. text, colors.cyan)})
        elseif text:find("OVERRIDE CODE") or text:find("BLACK VAULT") then
            table.insert(lines, {seg("  " .. text, colors.classified)})
        elseif text:find("^%s*Q:") then
            table.insert(lines, {seg("  " .. text, colors.dim)})
        elseif text:find("^%s*A:") then
            table.insert(lines, {seg("  " .. text, colors.text)})
        elseif text:find("Cross%-reference") then
            table.insert(lines, {seg("  " .. text, colors.cyan)})
        else
            table.insert(lines, {seg("  " .. text, colors.text)})
        end
    end
    return lines
end

local function format_record_footer(record)
    local lines = {}
    if record.related and #record.related > 0 then
        table.insert(lines, blank())
        table.insert(lines, {
            seg("  Related: ", colors.dim),
            seg(table.concat(record.related, ", "), colors.cyan),
        })
    end
    table.insert(lines, separator())
    return lines
end

local handlers = {}

function handlers.HELP(_game, _args)
    local out = {}
    table.insert(out, separator())
    table.insert(out, header_line("  AVAILABLE COMMANDS"))
    table.insert(out, separator())
    table.insert(out, blank())

    local cmds = {
        {"HELP",                "Show this help screen"},
        {"TASKS",               "List current investigation objectives"},
        {"ACTIONS",             "Show currently available authorizations"},
        {"STATUS",              "Display system overview and pressure metrics"},
        {"ALERTS",              "Show the active anomaly queue"},
        {"INBOX",               "View messages"},
        {"READ <id>",           "Read a record (for example READ INC-7301)"},
        {"READ MSG <n>",        "Read message number n from inbox"},
        {"SEARCH <keyword>",    "Search records by keyword"},
        {"LIST [category]",     "List records by type"},
        {"PERSONNEL <id>",      "View a personnel file"},
        {"COMPARE <id1> <id2>", "Compare two records"},
        {"INSPECT <system>",    "Inspect water, power, air, population, or external"},
        {"TRACE <resource>",    "Trace water, power, air, population, or external flow"},
        {"OVERRIDE <token>",    "Use a discovered override token"},
        {"AUTHORIZE <act-id>",  "Execute an available action"},
        {"DENY <act-id>",       "Deny an action without executing it"},
        {"CLEAR",               "Clear the terminal screen"},
        {"LOGOUT",              "End the session"},
    }

    for _, cmd in ipairs(cmds) do
        table.insert(out, {
            seg("  " .. string.format("%-24s", cmd[1]), colors.bright),
            seg(cmd[2], colors.dim),
        })
    end

    table.insert(out, blank())
    table.insert(out, dim_line("  Use Tab for autocomplete. Up/Down for history. Page Up/Down to scroll."))
    table.insert(out, separator())
    return out
end

function handlers.TASKS(game, _args)
    local out = {}
    table.insert(out, separator())
    table.insert(out, header_line("  CURRENT OBJECTIVES"))
    table.insert(out, separator())
    table.insert(out, blank())

    for _, objective in ipairs(game:getObjectives()) do
        table.insert(out, {
            seg("  > ", colors.cyan),
            seg(objective, colors.text),
        })
    end

    table.insert(out, blank())
    table.insert(out, separator())
    return out
end

function handlers.ACTIONS(game, _args)
    local out = {}
    local actions = game:getAvailableActions()

    table.insert(out, separator())
    table.insert(out, header_line("  AVAILABLE AUTHORIZATIONS"))
    table.insert(out, separator())
    table.insert(out, blank())

    if #actions == 0 then
        table.insert(out, dim_line("  No actions are currently available."))
    else
        for _, entry in ipairs(actions) do
            local action = entry.action
            table.insert(out, {
                seg("  " .. entry.id, colors.bright),
                seg(action.ending and "  [FINAL]" or "  [OPERATIONAL]", action.ending and colors.red or colors.cyan),
            })
            table.insert(out, {seg("     " .. action.title, colors.header)})
            table.insert(out, {seg("     " .. action.description, colors.dim)})
            table.insert(out, blank())
        end
    end

    table.insert(out, separator())
    return out
end

function handlers.STATUS(game, _args)
    local out = {}
    local stats = game:getStats()

    table.insert(out, separator())
    table.insert(out, header_line("  SILO MERIDIAN - OPERATOR STATUS"))
    table.insert(out, separator())
    table.insert(out, blank())

    local systems = {"water", "power", "air", "population", "external"}
    for _, key in ipairs(systems) do
        local sys = data.systems[key]
        local status_color = colors.bright
        if sys.status == "CAUTION" then status_color = colors.amber end
        if sys.status == "CRITICAL" then status_color = colors.red end
        table.insert(out, {
            seg("  > ", colors.dim),
            seg(string.format("%-34s", sys.name), colors.text),
            seg("[", colors.dim),
            seg(sys.status, status_color),
            seg("]", colors.dim),
        })
    end

    table.insert(out, blank())
    table.insert(out, {seg("  Proof gathered:      ", colors.dim), seg(tostring(stats.proof), colors.bright)})
    table.insert(out, {seg("  Audit risk:          ", colors.dim), seg(tostring(stats.risk), stats.risk >= 5 and colors.red or colors.amber)})
    table.insert(out, {seg("  Silo strain:         ", colors.dim), seg(tostring(stats.strain), stats.strain >= 5 and colors.red or colors.amber)})
    table.insert(out, {seg("  Mercy score:         ", colors.dim), seg(tostring(stats.mercy), colors.text)})
    table.insert(out, {seg("  Complicity score:    ", colors.dim), seg(tostring(stats.complicity), colors.text)})
    table.insert(out, {seg("  Records examined:    ", colors.dim), seg(tostring(stats.records), colors.text)})
    table.insert(out, {seg("  Unread messages:     ", colors.dim), seg(tostring(game:getUnreadCount()), game:getUnreadCount() > 0 and colors.cyan or colors.dim)})
    table.insert(out, blank())
    table.insert(out, dim_line("  Use TASKS when the thread of the investigation gets messy."))
    table.insert(out, separator())
    return out
end

function handlers.ALERTS(game, _args)
    local out = {}
    table.insert(out, separator())
    table.insert(out, header_line("  ACTIVE ALERTS"))
    table.insert(out, separator())
    table.insert(out, blank())

    local alerts = {
        {"INC-7301", "Unmetered water draw on retired branch A-17", "PRIORITY-2"},
    }
    if game.records_read["INC-7290"] then
        table.insert(alerts, {"INC-7290", "Pediatric antibiotic variance tied to retired nursery code", "PRIORITY-2"})
    end
    if game.records_read["INC-7288"] then
        table.insert(alerts, {"INC-7288", "Population checksum mismatch in hidden LANTERN branch", "PRIORITY-3"})
    end
    if game.records_read["INC-7021"] then
        table.insert(alerts, {"INC-7021", "Dormant air branch consuming live scrubber mass", "PRIORITY-2"})
    end
    if game.records_read["INC-7322"] then
        table.insert(alerts, {"INC-7322", "External mast reporting clean interval before forced suppression", "PRIORITY-2"})
    end
    if game.flags["annex_vault_unlocked"] then
        table.insert(alerts, {"DIR-8890", "Annex occupancy suppression order confirmed", "DIRECTIVE BREACH"})
    end
    if game.flags["dawn_vault_unlocked"] then
        table.insert(alerts, {"DIR-8700", "Surface-fatality narrative confirmed as partial lie", "DIRECTIVE BREACH"})
    end
    if game.decisions_unlocked then
        table.insert(alerts, {"FINAL", "A terminal decision is now available", "IMMEDIATE"})
    end

    for _, alert in ipairs(alerts) do
        local pri_color = colors.amber
        if alert[3] == "IMMEDIATE" or alert[3] == "DIRECTIVE BREACH" then
            pri_color = colors.red
        end
        table.insert(out, {
            seg("  [" .. alert[3] .. "] ", pri_color),
            seg(alert[1], colors.bright),
            seg(": " .. alert[2], colors.text),
        })
    end

    table.insert(out, blank())
    table.insert(out, separator())
    return out
end

function handlers.READ(game, args)
    if not args or #args == 0 then
        return {line("  ERROR: Usage: READ <record-id> or READ MSG <number>", colors.red)}
    end

    if args[1]:upper() == "MSG" then
        if not args[2] then
            return {line("  ERROR: Usage: READ MSG <number>", colors.red)}
        end
        local n = tonumber(args[2])
        if not n or n < 1 or n > #game.inbox then
            return {line("  ERROR: Invalid message number. Use INBOX to inspect the list.", colors.red)}
        end

        local entry = game.inbox[n]
        local msg = entry.message
        game:markMessageRead(n)

        if msg.on_read_flags then
            for _, flag in ipairs(msg.on_read_flags) do
                game.flags[flag] = true
            end
        end
        game:checkTriggers("message:" .. entry.id)

        local out = {}
        table.insert(out, separator())
        table.insert(out, {seg("  MESSAGE: ", colors.dim), seg(entry.id, colors.bright)})
        table.insert(out, {seg("  From:    ", colors.dim), seg(msg.from, msg.from == "UNKNOWN TERMINAL" and colors.amber or colors.text)})
        table.insert(out, {seg("  Subject: ", colors.dim), seg(msg.subject, colors.header)})
        table.insert(out, {seg("  Priority:", colors.dim), seg(" " .. msg.priority, (msg.priority == "PRIORITY-1" or msg.priority == "URGENT") and colors.red or colors.text)})
        table.insert(out, separator())
        table.insert(out, blank())

        for _, text in ipairs(msg.content) do
            if text == "" then
                table.insert(out, blank())
            elseif text:find("^%s*>") then
                table.insert(out, {seg("  " .. text, colors.amber)})
            elseif text:find("ACT%-") then
                table.insert(out, {seg("  " .. text, colors.cyan)})
            elseif text:find("OVERRIDE CODE") then
                table.insert(out, {seg("  " .. text, colors.classified)})
            else
                table.insert(out, {seg("  " .. text, colors.text)})
            end
        end

        table.insert(out, blank())
        table.insert(out, separator())
        return out
    end

    local id = args[1]:upper()
    local record = data.records[id]
    if not record then
        return {line("  ERROR: Record '" .. id .. "' not found. Use LIST or SEARCH.", colors.red)}
    end

    if not game:canAccessRecord(id) then
        local out = {}
        table.insert(out, separator())
        table.insert(out, {seg("  ACCESS DENIED", colors.red)})
        table.insert(out, blank())
        table.insert(out, {seg(record.lock_reason or "  Record is locked behind a higher classification gate.", colors.amber)})
        table.insert(out, blank())
        table.insert(out, {seg("  Continue investigating. Search for override tokens or related files.", colors.dim)})
        table.insert(out, separator())
        return out
    end

    local out = {}
    for _, item in ipairs(format_record_header(id, record)) do table.insert(out, item) end
    table.insert(out, blank())
    for _, item in ipairs(format_record_content(record)) do table.insert(out, item) end
    for _, item in ipairs(format_record_footer(record)) do table.insert(out, item) end

    game:onRecordRead(id)
    return out
end

function handlers.SEARCH(game, args)
    if not args or #args == 0 then
        return {line("  ERROR: Usage: SEARCH <keyword>", colors.red)}
    end

    local keyword = table.concat(args, " ")
    local results = data.search(keyword)
    game:onSearchPerformed(keyword)

    local out = {}
    table.insert(out, separator())
    table.insert(out, {
        seg("  SEARCH RESULTS: ", colors.dim),
        seg('"' .. keyword .. '"', colors.bright),
        seg("  (" .. #results .. " found)", colors.dim),
    })
    table.insert(out, separator())

    if #results == 0 then
        table.insert(out, blank())
        table.insert(out, dim_line("  No records matched your search."))
    else
        table.insert(out, blank())
        for _, result in ipairs(results) do
            local access_ok = game:canAccessRecord(result.id)
            if access_ok then
                table.insert(out, {
                    seg("  " .. string.format("%-16s", result.id), colors.bright),
                    seg(result.record.title, colors.text),
                })
                table.insert(out, {
                    seg("                  ", colors.dim),
                    seg(result.record.type:upper() .. " | " .. result.record.date .. " | " .. result.record.classification, colors.dim),
                })
            else
                table.insert(out, {
                    seg("  " .. string.format("%-16s", result.id), colors.classified),
                    seg("[LOCKED - OVERRIDE REQUIRED]", colors.classified),
                })
            end
            table.insert(out, blank())
        end
    end

    table.insert(out, separator())
    return out
end

function handlers.LIST(game, args)
    local category = (args and #args > 0) and args[1]:upper() or "ALL"
    local type_filter = nil

    if category == "INCIDENTS" then type_filter = "incident"
    elseif category == "MAINTENANCE" then type_filter = "maintenance"
    elseif category == "DIRECTIVES" then type_filter = "directive"
    elseif category == "WITNESS" then type_filter = "witness"
    elseif category ~= "ALL" then
        return {
            line("  ERROR: Unknown category '" .. category .. "'.", colors.red),
            line("  Available: incidents, maintenance, directives, witness, all", colors.dim),
        }
    end

    local results = {}
    for id, record in pairs(data.records) do
        if not type_filter or record.type == type_filter then
            table.insert(results, {id = id, record = record})
        end
    end
    table.sort(results, function(a, b) return a.id < b.id end)

    local out = {}
    table.insert(out, separator())
    table.insert(out, {
        seg("  RECORD INDEX", colors.header),
        seg(type_filter and ("  [" .. type_filter:upper() .. "]") or "  [ALL]", colors.dim),
        seg("  (" .. #results .. " records)", colors.dim),
    })
    table.insert(out, separator())
    table.insert(out, blank())

    for _, result in ipairs(results) do
        local access_ok = game:canAccessRecord(result.id)
        local read_marker = game.records_read[result.id] and "  " or "* "
        local marker_color = game.records_read[result.id] and colors.dim or colors.cyan
        if access_ok then
            table.insert(out, {
                seg("  " .. read_marker, marker_color),
                seg(string.format("%-16s", result.id), colors.bright),
                seg(result.record.title, colors.text),
            })
        else
            table.insert(out, {
                seg("  " .. read_marker, colors.classified),
                seg(string.format("%-16s", result.id), colors.classified),
                seg("[LOCKED]", colors.classified),
            })
        end
    end

    table.insert(out, blank())
    table.insert(out, dim_line("  * = unread  |  Use READ <id> to view a record"))
    table.insert(out, separator())
    return out
end

function handlers.PERSONNEL(game, args)
    if not args or #args == 0 then
        return {line("  ERROR: Usage: PERSONNEL <id> (for example PERSONNEL CIV-0119)", colors.red)}
    end

    local id = args[1]:upper()
    local person = data.personnel[id]
    if not person then
        local results = data.searchPersonnel(table.concat(args, " "))
        if #results == 0 then
            return {line("  ERROR: Personnel '" .. id .. "' not found.", colors.red)}
        elseif #results == 1 then
            id = results[1].id
            person = results[1].person
        else
            local out = {}
            table.insert(out, line("  Multiple matches found:", colors.amber))
            for _, result in ipairs(results) do
                table.insert(out, {
                    seg("  " .. string.format("%-12s", result.id), colors.bright),
                    seg(result.person.name, colors.text),
                })
            end
            return out
        end
    end

    local out = {}
    table.insert(out, separator())
    table.insert(out, {seg("  PERSONNEL FILE: ", colors.dim), seg(id, colors.bright)})
    table.insert(out, separator())
    table.insert(out, {seg("  Name:       ", colors.dim), seg(person.name, colors.header)})
    table.insert(out, {seg("  Role:       ", colors.dim), seg(person.role, colors.text)})
    table.insert(out, {seg("  Sector:     ", colors.dim), seg(person.sector, colors.text)})
    table.insert(out, {seg("  Clearance:  ", colors.dim), seg("Level " .. person.clearance, colors.text)})
    table.insert(out, {seg("  Status:     ", colors.dim), seg(person.status, person.status == "ACTIVE" and colors.bright or colors.red)})
    table.insert(out, separator())
    table.insert(out, blank())
    for _, note in ipairs(person.notes) do
        table.insert(out, {seg("  > " .. note, colors.text)})
    end
    table.insert(out, blank())
    table.insert(out, separator())

    game:onPersonnelViewed(id)
    return out
end

function handlers.COMPARE(game, args)
    if not args or #args < 2 then
        return {line("  ERROR: Usage: COMPARE <id1> <id2>", colors.red)}
    end

    local id1 = args[1]:upper()
    local id2 = args[2]:upper()
    local r1 = data.records[id1]
    local r2 = data.records[id2]

    if not r1 then return {line("  ERROR: Record '" .. id1 .. "' not found.", colors.red)} end
    if not r2 then return {line("  ERROR: Record '" .. id2 .. "' not found.", colors.red)} end
    if not game:canAccessRecord(id1) then return {line("  ERROR: Access denied to " .. id1, colors.red)} end
    if not game:canAccessRecord(id2) then return {line("  ERROR: Access denied to " .. id2, colors.red)} end

    local out = {}
    table.insert(out, separator())
    table.insert(out, {
        seg("  COMPARISON: ", colors.dim),
        seg(id1, colors.bright),
        seg(" vs ", colors.dim),
        seg(id2, colors.bright),
    })
    table.insert(out, separator())
    table.insert(out, blank())

    table.insert(out, {seg("  +-- " .. id1 .. " -----------------------------------", colors.cyan)})
    table.insert(out, {seg("  | " .. r1.title, colors.header)})
    table.insert(out, {seg("  | Date: " .. r1.date .. "  |  By: " .. r1.filed_by, colors.dim)})
    for _, text in ipairs(r1.content) do
        table.insert(out, {seg(text == "" and "  |" or ("  | " .. text), colors.text)})
    end
    table.insert(out, {seg("  +----------------------------------------------", colors.cyan)})
    table.insert(out, blank())

    table.insert(out, {seg("  +-- " .. id2 .. " -----------------------------------", colors.amber)})
    table.insert(out, {seg("  | " .. r2.title, colors.header)})
    table.insert(out, {seg("  | Date: " .. r2.date .. "  |  By: " .. r2.filed_by, colors.dim)})
    for _, text in ipairs(r2.content) do
        table.insert(out, {seg(text == "" and "  |" or ("  | " .. text), colors.text)})
    end
    table.insert(out, {seg("  +----------------------------------------------", colors.amber)})
    table.insert(out, blank())

    local analysis = commands.getComparisonAnalysis(id1, id2)
    if analysis then
        table.insert(out, {seg("  +== DISCREPANCY ANALYSIS ===========================", colors.classified)})
        for _, text in ipairs(analysis) do
            table.insert(out, {seg("  | " .. text, colors.amber)})
        end
        table.insert(out, {seg("  +=================================================", colors.classified)})
    end

    table.insert(out, separator())
    game:onComparisonMade(id1, id2)
    return out
end

function handlers.INSPECT(_game, args)
    if not args or #args == 0 then
        return {line("  ERROR: Usage: INSPECT <system> (water/power/air/population/external)", colors.red)}
    end

    local key = args[1]:lower()
    local sys = data.systems[key]
    if not sys then
        return {line("  ERROR: Unknown system '" .. args[1] .. "'. Available: water, power, air, population, external", colors.red)}
    end

    local out = {}
    table.insert(out, separator())
    table.insert(out, header_line("  " .. sys.name))
    table.insert(out, {
        seg("  Sector: ", colors.dim),
        seg(sys.sector, colors.text),
        seg("  |  Status: ", colors.dim),
        seg(sys.status, sys.status == "NOMINAL" and colors.bright or colors.amber),
    })
    table.insert(out, separator())
    table.insert(out, blank())
    for _, text in ipairs(sys.details) do
        if text == "" then
            table.insert(out, blank())
        elseif text:find(">") or text:find("WARNING") or text:find("ALERT") then
            table.insert(out, {seg("  " .. text, colors.amber)})
        else
            table.insert(out, {seg("  " .. text, colors.text)})
        end
    end
    table.insert(out, blank())
    table.insert(out, separator())
    return out
end

function handlers.TRACE(game, args)
    if not args or #args == 0 then
        return {line("  ERROR: Usage: TRACE <resource> (water/power/air/population/external)", colors.red)}
    end

    local resource = args[1]:lower()
    local out = {}

    if resource == "water" or resource == "wtr" then
        table.insert(out, separator())
        table.insert(out, header_line("  WATER DISTRIBUTION TRACE"))
        table.insert(out, separator())
        table.insert(out, blank())
        table.insert(out, {seg("  Source: Primary Aquifer / Sector 6", colors.text)})
        table.insert(out, {seg("  Total output: 11,940 L/day", colors.text)})
        table.insert(out, blank())
        table.insert(out, {seg("  |-- Public sectors: 11,102 L/day", colors.text)})
        table.insert(out, {seg("  |-- Known reserve:    226 L/day", colors.text)})
        table.insert(out, {seg("  |-- Retired branch A-17:", colors.cyan)})
        table.insert(out, {seg("  |   +-- 612.4 L/day [UNDECLARED DRAW]", colors.red)})
        table.insert(out, {seg("  |   +-- Curve smoothing indicates human interference", colors.amber)})
        table.insert(out, blank())
        game:onSearchPerformed("trace water")
    elseif resource == "power" or resource == "pwr" then
        table.insert(out, separator())
        table.insert(out, header_line("  POWER DISTRIBUTION TRACE"))
        table.insert(out, separator())
        table.insert(out, blank())
        table.insert(out, {seg("  Source: Geothermal Stack / Sector 7", colors.text)})
        table.insert(out, {seg("  Public load: 2,203 kWh/day", colors.text)})
        table.insert(out, {seg("  Legacy annex feeder loss: 41 kWh/day", colors.amber)})
        table.insert(out, blank())
        game:onSearchPerformed("trace power")
    elseif resource == "air" then
        table.insert(out, separator())
        table.insert(out, header_line("  AIR CIRCULATION TRACE"))
        table.insert(out, separator())
        table.insert(out, blank())
        table.insert(out, {seg("  Main scrubber loop nominal across public sectors.", colors.text)})
        table.insert(out, {seg("  Branch AF-A17 tagged DORMANT but continues media consumption.", colors.amber)})
        table.insert(out, {seg("  Residue profile: cloth, skin, candle carbon, cooked starch.", colors.text)})
        table.insert(out, blank())
        game:onSearchPerformed("trace air")
    elseif resource == "population" or resource == "pop" then
        table.insert(out, separator())
        table.insert(out, header_line("  POPULATION TRACE"))
        table.insert(out, separator())
        table.insert(out, blank())
        table.insert(out, {seg("  Public ledger total: 2,146", colors.text)})
        table.insert(out, {seg("  Hidden mirror leaves: 64", colors.red)})
        table.insert(out, {seg("  Branch tag recovered: LANTERN", colors.amber)})
        table.insert(out, blank())
        game:onSearchPerformed("trace population")
    elseif resource == "external" or resource == "ext" or resource == "surface" then
        table.insert(out, separator())
        table.insert(out, header_line("  EXTERNAL ACCESS TRACE"))
        table.insert(out, separator())
        table.insert(out, blank())
        table.insert(out, {seg("  West Mast 4: dormant on public maps, heartbeat current on hidden line", colors.text)})
        table.insert(out, {seg("  Suppressor mask: D-DAWN-4", colors.amber)})
        table.insert(out, {seg("  Recent event: clean-signal interval detected before forced channel closure", colors.text)})
        table.insert(out, {seg("  Shaft servo: maintained despite retirement order", colors.text)})
        table.insert(out, blank())
        game:onSearchPerformed("trace external")
    else
        return {line("  ERROR: Unknown resource. Available: water, power, air, population, external", colors.red)}
    end

    table.insert(out, separator())
    return out
end

function handlers.OVERRIDE(game, args)
    if not args or #args == 0 then
        return {line("  ERROR: Usage: OVERRIDE <token>", colors.red)}
    end

    local token = table.concat(args, " ")
    local result = game:unlockOverride(token)
    local out = {}

    table.insert(out, separator())
    table.insert(out, {seg("  OVERRIDE TOKEN: ", colors.dim), seg(token:upper(), colors.classified)})
    table.insert(out, separator())
    table.insert(out, blank())

    if not result.ok then
        table.insert(out, {seg("  ACCESS REJECTED", colors.red)})
        table.insert(out, {seg("  " .. result.message, colors.amber)})
        table.insert(out, blank())
        table.insert(out, separator())
        return out
    end

    if result.already then
        table.insert(out, {seg("  TOKEN ALREADY APPLIED", colors.amber)})
        table.insert(out, {seg("  The associated branch is already open on this terminal.", colors.text)})
        table.insert(out, blank())
        table.insert(out, separator())
        return out
    end

    table.insert(out, {seg("  OVERRIDE ACCEPTED", colors.bright)})
    table.insert(out, {seg("  " .. result.entry.title, colors.header)})
    table.insert(out, {seg("  " .. result.entry.description, colors.text)})
    table.insert(out, blank())
    table.insert(out, {seg("  Unlocked records:", colors.dim)})
    for _, record_id in ipairs(result.entry.unlocks or {}) do
        table.insert(out, {seg("    " .. record_id, colors.cyan)})
    end
    table.insert(out, blank())
    table.insert(out, separator())
    return out
end

function handlers.INBOX(game, _args)
    local out = {}
    table.insert(out, separator())
    table.insert(out, {
        seg("  INBOX", colors.header),
        seg("  (" .. #game.inbox .. " messages, " .. game:getUnreadCount() .. " unread)", colors.dim),
    })
    table.insert(out, separator())
    table.insert(out, blank())

    if #game.inbox == 0 then
        table.insert(out, dim_line("  No messages."))
    else
        for i, entry in ipairs(game.inbox) do
            local msg = entry.message
            local marker = entry.read and "  " or "* "
            local pri_color = colors.text
            if msg.priority == "PRIORITY-1" or msg.priority == "URGENT" then pri_color = colors.red end
            if msg.priority == "PRIORITY-2" then pri_color = colors.amber end
            local from_color = msg.from == "UNKNOWN TERMINAL" and colors.amber or colors.text

            table.insert(out, {
                seg("  " .. marker, entry.read and colors.dim or colors.cyan),
                seg(string.format("%-4d", i), colors.bright),
                seg(string.format("%-20s", msg.from), from_color),
                seg(msg.subject, colors.text),
            })
            table.insert(out, {
                seg("        ", colors.dim),
                seg("[" .. msg.priority .. "]", pri_color),
            })
        end
    end

    table.insert(out, blank())
    table.insert(out, dim_line("  * = unread  |  Use READ MSG <number> to open a message"))
    table.insert(out, separator())
    return out
end

function handlers.AUTHORIZE(game, args)
    if not args or #args == 0 then
        return {line("  ERROR: Usage: AUTHORIZE <action-id>", colors.red)}
    end

    local id = args[1]:upper()
    local action = data.actions[id]
    if not action then
        return {line("  ERROR: Unknown action '" .. id .. "'. Use ACTIONS to inspect the live set.", colors.red)}
    end

    if not game:isActionAvailable(id) then
        return {line("  ERROR: Action " .. id .. " is not currently available.", colors.amber)}
    end

    local result = game:executeAction(id)
    if not result then
        return {line("  ERROR: Failed to execute action " .. id .. ".", colors.red)}
    end

    local out = {}
    table.insert(out, separator())
    table.insert(out, {seg("  AUTHORIZATION REQUEST: ", colors.amber), seg(id, colors.bright)})
    table.insert(out, separator())
    table.insert(out, blank())
    table.insert(out, {seg("  " .. action.title, colors.header)})
    table.insert(out, {seg("  " .. action.description, colors.text)})
    table.insert(out, blank())
    table.insert(out, {seg("  PROCESSING...", colors.amber)})
    table.insert(out, blank())

    for _, text in ipairs(result.notes or {}) do
        table.insert(out, {seg("  " .. text, colors.text)})
    end

    if result.ending then
        table.insert(out, blank())
        table.insert(out, {seg("  === AUTHORIZATION CONFIRMED ===", colors.bright)})
    end

    table.insert(out, separator())
    return out
end

function handlers.DENY(_game, args)
    if not args or #args == 0 then
        return {line("  ERROR: Usage: DENY <action-id>", colors.red)}
    end
    local id = args[1]:upper()
    if not data.actions[id] then
        return {line("  ERROR: Unknown action '" .. id .. "'.", colors.red)}
    end
    return {line("  Action " .. id .. " denied. Nothing changed.", colors.text)}
end

function handlers.CLEAR(_game, _args)
    return "CLEAR"
end

function handlers.LOGOUT(_game, _args)
    return "LOGOUT"
end

function commands.getComparisonAnalysis(id1, id2)
    local key = id1 .. ":" .. id2
    local rkey = id2 .. ":" .. id1

    local analyses = {
        ["INC-7301:MLOG-WTR-4408"] = {
            "The incident log says retired branch A-17 should be dry.",
            "The maintenance log says the branch required hand-shaped pressure smoothing.",
            "",
            "That is not leak behavior. That is concealment.",
        },
        ["INC-7290:MLOG-MED-1220"] = {
            "Medical stock vanished into a retired nursery code.",
            "The restock log shows collection by Elsa Kell's badge years after her reported death.",
            "",
            "Either the badge is cloned or Elsa Kell was never where the registry says she was.",
        },
        ["INC-7288:WIT-177-A"] = {
            "Registry automation found 64 hidden hashes.",
            "Jonas Bell's memo says the branch is being actively gardened and reaped.",
            "",
            "This is not corruption. It is maintenance of a lie.",
        },
        ["INC-6550:INC-6130"] = {
            "The disturbance report frames Lantern as destabilizers.",
            "The sabotage summary cannot actually prove a mass-casualty plan.",
            "",
            "Emergency powers appear to have been justified on incomplete evidence.",
        },
        ["INC-6402:DIR-8890"] = {
            "INC-6402 describes a 48-hour fire-isolation relocation.",
            "DIR-8890 converts the same people into a permanent hidden population.",
            "",
            "The temporary emergency was always intended to become disappearance.",
        },
        ["DIR-4980:WIT-084-A"] = {
            "Directive language calls calm-ash exposure acceptable in minors.",
            "Dr. Sera describes the result as developmental damage and loss of time sense.",
            "",
            "The policy is clinical euphemism wrapped around child harm.",
        },
        ["MLOG-ANN-0007:WIT-777-A"] = {
            "The ingress power test records 64 bunks and a classroom strip.",
            "The slate transcript proves the classroom is real and active right now.",
            "",
            "A-17 is not a remnant. It is a living annex with children in it.",
        },
        ["DIR-4012:INC-7316"] = {
            "The triage ladder denies standing to unregistered people.",
            "The winter model shows that honoring them anyway kills others later by attrition.",
            "",
            "Policy and compassion both carry bodies. The difference is where they are counted.",
        },
        ["WIT-308-A:INC-6402"] = {
            "Elsa Kell asked why alphabet cards and nursery supplies were sent to a 48-hour isolation.",
            "The relocation file never answers because it was never a 48-hour isolation.",
            "",
            "The nursery aide understood the lie on the night it began.",
        },
        ["WIT-621-A:DIR-8890"] = {
            "Security testimony admits the terrorism claim was overstated.",
            "DIR-8890 still uses that framing to justify permanent disappearance.",
            "",
            "A weak threat became a durable doctrine because fear was useful.",
        },
        ["INC-6117:DIR-8700"] = {
            "Team Kestrel found a brief breathable interval on the surface.",
            "DIR-8700 orders the public to be told the surface is uniformly fatal.",
            "",
            "The lie is strategic, not evidentiary.",
        },
        ["DIR-9408:WIT-940-A"] = {
            "DIR-9408 treats annex children as a future obedient surface cohort.",
            "Lio Venn's lesson slate tries to prepare them for truth instead of obedience.",
            "",
            "The Directorate saw inventory. The teacher saw people.",
        },
        ["INC-7322:MLOG-EXT-4401"] = {
            "The incident file catches a clean interval at West Mast 4.",
            "The maintenance log shows the mast asking for power repeatedly.",
            "",
            "Dead infrastructure does not time its own heartbeat.",
        },
        ["INC-6117:WIT-412-A"] = {
            "The formal loss report measures a breathable interval and buries it in classification.",
            "Mara Quill's voice packet says outright that the surface is 'not dead all the time.'",
            "",
            "Telemetry became doctrine only after the dangerous part was removed: hope.",
        },
        ["DIR-8700:DIR-9408"] = {
            "DIR-8700 suppresses knowledge of the sky to prevent public ascent pressure.",
            "DIR-9408 quietly reserves a future ascent option for annex children only.",
            "",
            "The regime did not reject the sky. It privatized it.",
        },
    }

    return analyses[key] or analyses[rkey]
end

function commands.getCompletions(input, game)
    input = input:upper()
    local parts = {}
    for word in input:gmatch("%S+") do
        table.insert(parts, word)
    end

    if #parts == 0 then return {} end

    if #parts == 1 and not input:find("%s$") then
        local matches = {}
        for _, cmd in ipairs(COMMAND_LIST) do
            if cmd:sub(1, #parts[1]) == parts[1] and cmd ~= parts[1] then
                table.insert(matches, cmd)
            end
        end
        return matches
    end

    local cmd = parts[1]

    if cmd == "READ" and #parts == 2 and not input:find("%s$") then
        local matches = {}
        local partial = parts[2]
        if partial == "M" or partial == "MS" or partial == "MSG" then
            table.insert(matches, "MSG")
        end
        for _, id in ipairs(RECORD_IDS) do
            if id:sub(1, #partial) == partial and id ~= partial then
                table.insert(matches, id)
            end
        end
        return matches
    end

    if cmd == "PERSONNEL" and #parts == 2 and not input:find("%s$") then
        local matches = {}
        local partial = parts[2]
        for _, id in ipairs(PERSONNEL_IDS) do
            if id:sub(1, #partial) == partial and id ~= partial then
                table.insert(matches, id)
            end
        end
        return matches
    end

    if cmd == "COMPARE" then
        local arg_index = input:find("%s$") and (#parts + 1) or #parts
        if arg_index == 2 or arg_index == 3 then
            local matches = {}
            local partial = (arg_index <= #parts) and parts[arg_index] or ""
            for _, id in ipairs(RECORD_IDS) do
                if (#partial == 0 or id:sub(1, #partial) == partial) and id ~= partial then
                    table.insert(matches, id)
                end
            end
            return matches
        end
    end

    if cmd == "INSPECT" and (#parts == 1 or (#parts == 2 and not input:find("%s$"))) then
        local matches = {}
        local partial = #parts >= 2 and parts[2] or ""
        for _, name in ipairs(SYSTEM_NAMES) do
            if #partial == 0 or name:sub(1, #partial) == partial then
                table.insert(matches, name)
            end
        end
        return matches
    end

    if cmd == "TRACE" and (#parts == 1 or (#parts == 2 and not input:find("%s$"))) then
        local matches = {}
        local partial = #parts >= 2 and parts[2] or ""
        for _, name in ipairs(SYSTEM_NAMES) do
            if #partial == 0 or name:sub(1, #partial) == partial then
                table.insert(matches, name)
            end
        end
        return matches
    end

    if cmd == "LIST" and (#parts == 1 or (#parts == 2 and not input:find("%s$"))) then
        local matches = {}
        local partial = #parts >= 2 and parts[2] or ""
        for _, category in ipairs(LIST_CATEGORIES) do
            if #partial == 0 or category:sub(1, #partial) == partial then
                table.insert(matches, category)
            end
        end
        return matches
    end

    if cmd == "OVERRIDE" and (#parts == 1 or (#parts == 2 and not input:find("%s$"))) then
        local matches = {}
        local partial = #parts >= 2 and parts[2] or ""
        for _, token in ipairs(OVERRIDE_TOKENS) do
            local allowed = (token == "LANTERN-17" and game.flags.lantern_code_known)
                or (token == "ASHLINE-NULL" and game.flags.ashline_code_known)
                or (token == "DAWN-GATE" and game.flags.dawn_code_known)
            if allowed and (#partial == 0 or token:sub(1, #partial) == partial) then
                table.insert(matches, token)
            end
        end
        return matches
    end

    if (cmd == "AUTHORIZE" or cmd == "DENY") and (#parts == 1 or (#parts == 2 and not input:find("%s$"))) then
        local matches = {}
        local partial = #parts >= 2 and parts[2] or ""
        for _, entry in ipairs(game:getAvailableActions()) do
            if #partial == 0 or entry.id:sub(1, #partial) == partial then
                table.insert(matches, entry.id)
            end
        end
        return matches
    end

    return {}
end

function commands.getGhostText(input, game)
    local completions = commands.getCompletions(input, game)
    if #completions == 0 then return "" end

    local upper_input = input:upper()
    local parts = {}
    for word in upper_input:gmatch("%S+") do
        table.insert(parts, word)
    end

    local completion = completions[1]
    if #parts <= 1 and not input:find("%s$") then
        local partial = #parts == 1 and parts[1] or ""
        if completion:sub(1, #partial) == partial then
            return completion:sub(#partial + 1)
        end
    else
        local last_part = parts[#parts]
        if not input:find("%s$") and completion:sub(1, #last_part) == last_part then
            return completion:sub(#last_part + 1)
        elseif input:find("%s$") then
            return completion
        end
    end

    return ""
end

function commands.applyCompletion(input, game)
    local ghost = commands.getGhostText(input, game)
    if #ghost > 0 then
        return input .. ghost
    end
    return input
end

function commands.execute(game, input_text)
    local trimmed = input_text:match("^%s*(.-)%s*$")
    if #trimmed == 0 then return {} end

    local parts = {}
    for word in trimmed:gmatch("%S+") do
        table.insert(parts, word)
    end

    local cmd = parts[1]:upper()
    local args = {}
    for i = 2, #parts do
        table.insert(args, parts[i])
    end

    local handler = handlers[cmd]
    if handler then
        return handler(game, args)
    end

    return {{
        {text = "  ERROR: Unknown command '", color = colors.red},
        {text = cmd, color = colors.bright},
        {text = "'. Type HELP for available commands.", color = colors.red},
    }}
end

return commands
