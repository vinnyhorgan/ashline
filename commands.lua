local colors = require("colors")
local data = require("data")

local commands = {}

local COMMAND_LIST = {
    "HELP", "STATUS", "ALERTS", "READ", "SEARCH", "LIST",
    "PERSONNEL", "COMPARE", "INSPECT", "TRACE", "AUTHORIZE",
    "DENY", "INBOX", "CLEAR", "LOGOUT",
}

local RECORD_IDS = {}
for id, _ in pairs(data.records) do
    table.insert(RECORD_IDS, id)
end
table.sort(RECORD_IDS)

local PERSONNEL_IDS = {}
for id, _ in pairs(data.personnel) do
    table.insert(PERSONNEL_IDS, id)
end
table.sort(PERSONNEL_IDS)

local SYSTEM_NAMES = {"WATER", "POWER", "AIR", "POPULATION"}
local LIST_CATEGORIES = {"INCIDENTS", "MAINTENANCE", "DIRECTIVES", "WITNESS", "ALL"}

-- ─── output formatting helpers ─────────────────────────────────────────

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
        seg(record.classification, record.classification:find("CLASSIFIED") and colors.classified or colors.text),
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
        if text:find("^%s*>") or text:find("WARNING") or text:find("ALERT") then
            table.insert(lines, {seg("  " .. text, colors.amber)})
        elseif text:find("^%s*NOTE") or text:find("^%s*OBSERVATION") or text:find("ADDITIONAL NOTE") then
            table.insert(lines, {seg("  " .. text, colors.cyan)})
        elseif text:find("██") then
            table.insert(lines, {seg("  " .. text, colors.classified)})
        elseif text:find("^%s*Q:") then
            table.insert(lines, {seg("  " .. text, colors.dim)})
        elseif text:find("^%s*A:") then
            table.insert(lines, {seg("  " .. text, colors.text)})
        elseif text:find("Cross%-reference") then
            table.insert(lines, {seg("  " .. text, colors.cyan)})
        elseif text == "" then
            table.insert(lines, blank())
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

-- ─── command handlers ──────────────────────────────────────────────────

local handlers = {}

function handlers.HELP(game, args)
    local out = {}
    table.insert(out, separator())
    table.insert(out, header_line("  AVAILABLE COMMANDS"))
    table.insert(out, separator())
    table.insert(out, blank())
    local cmds = {
        {"HELP",                "Show this help screen"},
        {"STATUS",              "Display system overview"},
        {"ALERTS",              "Show active alerts"},
        {"INBOX",               "View messages"},
        {"READ <id>",           "Read a record (e.g., READ INC-2047)"},
        {"READ MSG <n>",        "Read message number n from inbox"},
        {"SEARCH <keyword>",    "Search all records by keyword"},
        {"LIST [category]",     "List records (incidents/maintenance/directives/witness/all)"},
        {"PERSONNEL <id>",      "View personnel file (e.g., PERSONNEL CIV-0112)"},
        {"COMPARE <id1> <id2>", "Compare two records side by side"},
        {"INSPECT <system>",    "Inspect subsystem (water/power/air/population)"},
        {"TRACE <resource>",    "Trace resource flow"},
        {"AUTHORIZE <act-id>",  "Authorize a pending action"},
        {"DENY <act-id>",       "Deny a pending action"},
        {"CLEAR",               "Clear terminal screen"},
        {"LOGOUT",              "End session"},
    }
    for _, cmd in ipairs(cmds) do
        table.insert(out, {
            seg("  " .. string.format("%-24s", cmd[1]), colors.bright),
            seg(cmd[2], colors.dim),
        })
    end
    table.insert(out, blank())
    table.insert(out, dim_line("  Use Tab for autocomplete. Up/Down for command history."))
    table.insert(out, dim_line("  Page Up/Down to scroll output."))
    table.insert(out, separator())
    return out
end

function handlers.STATUS(game, args)
    local out = {}
    table.insert(out, separator())
    table.insert(out, header_line("  SILO MERIDIAN - SYSTEM STATUS OVERVIEW"))
    table.insert(out, separator())
    table.insert(out, blank())

    local systems = {"water", "power", "air", "population"}
    for _, sys_key in ipairs(systems) do
        local sys = data.systems[sys_key]
        local status_color = colors.bright
        if sys.status == "CAUTION" then status_color = colors.amber
        elseif sys.status == "CRITICAL" then status_color = colors.red end

        table.insert(out, {
            seg("  > ", colors.dim),
            seg(string.format("%-34s", sys.name), colors.text),
            seg("[", colors.dim),
            seg(sys.status, status_color),
            seg("]", colors.dim),
        })
    end

    table.insert(out, blank())
    table.insert(out, {
        seg("  Active alerts:    ", colors.dim),
        seg(tostring(game.alert_count), colors.amber),
    })
    table.insert(out, {
        seg("  Unread messages:  ", colors.dim),
        seg(tostring(game:getUnreadCount()), game:getUnreadCount() > 0 and colors.cyan or colors.dim),
    })
    table.insert(out, {
        seg("  Operator:         ", colors.dim),
        seg("CIV-0031 (Operator 31)", colors.text),
    })
    table.insert(out, {
        seg("  Clearance:        ", colors.dim),
        seg("Level 2", colors.text),
    })
    table.insert(out, blank())
    table.insert(out, dim_line("  Use INSPECT <system> for detailed view. Use ALERTS for alert details."))
    table.insert(out, separator())
    return out
end

function handlers.ALERTS(game, args)
    local out = {}
    table.insert(out, separator())
    table.insert(out, header_line("  ACTIVE ALERTS"))
    table.insert(out, separator())
    table.insert(out, blank())
    table.insert(out, {
        seg("  [PRIORITY-2] ", colors.amber),
        seg("INC-2047", colors.bright),
        seg(": Anomalous water consumption - Sector 9", colors.text),
    })
    table.insert(out, dim_line("    Filed: 2071-03-14  |  Status: OPEN  |  Requires investigation"))
    table.insert(out, blank())
    if game.records_read["INC-2044"] then
        table.insert(out, {
            seg("  [PRIORITY-2] ", colors.amber),
            seg("INC-2044", colors.bright),
            seg(": Water deficit projection", colors.text),
        })
        table.insert(out, dim_line("    Filed: 2071-02-28  |  Status: MONITORING"))
        table.insert(out, blank())
    end
    table.insert(out, dim_line("  Use READ <id> to view full incident report."))
    table.insert(out, separator())
    return out
end

function handlers.READ(game, args)
    if not args or #args == 0 then
        return {line("  ERROR: Usage: READ <record-id> or READ MSG <number>", colors.red)}
    end

    -- READ MSG <n>
    if args[1]:upper() == "MSG" then
        if not args[2] then
            return {line("  ERROR: Usage: READ MSG <number>", colors.red)}
        end
        local n = tonumber(args[2])
        if not n or n < 1 or n > #game.inbox then
            return {line("  ERROR: Invalid message number. Use INBOX to see messages.", colors.red)}
        end
        local entry = game.inbox[n]
        game:markMessageRead(n)
        local msg = entry.message
        local out = {}
        table.insert(out, separator())
        table.insert(out, {
            seg("  MESSAGE: ", colors.dim),
            seg(entry.id, colors.bright),
        })
        table.insert(out, {
            seg("  From:    ", colors.dim),
            seg(msg.from, msg.from == "UNKNOWN TERMINAL" and colors.amber or colors.text),
        })
        table.insert(out, {
            seg("  Subject: ", colors.dim),
            seg(msg.subject, colors.header),
        })
        table.insert(out, {
            seg("  Priority:", colors.dim),
            seg(" " .. msg.priority, msg.priority == "PRIORITY-1" and colors.red or (msg.priority == "URGENT" and colors.amber or colors.text)),
        })
        table.insert(out, separator())
        table.insert(out, blank())
        for _, text in ipairs(msg.content) do
            if text == "" then
                table.insert(out, blank())
            elseif text:find("^%s*>") then
                table.insert(out, {seg("  " .. text, colors.amber)})
            elseif text:find("ACCESS CODE") then
                table.insert(out, {seg("  " .. text, colors.classified)})
            elseif text:find("ACT%-") then
                table.insert(out, {seg("  " .. text, colors.cyan)})
            else
                table.insert(out, {seg("  " .. text, colors.text)})
            end
        end
        table.insert(out, blank())
        table.insert(out, separator())

        -- trigger game events based on message
        if entry.id == "MSG-005" then
            game.decisions_unlocked = true
            game.dir_9901_unlocked = true
        end

        return out
    end

    -- READ <record-id>
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
        table.insert(out, {seg("  Record " .. id .. " is classified at LEVEL 4.", colors.amber)})
        table.insert(out, {seg("  Your clearance: LEVEL 2.", colors.text)})
        table.insert(out, blank())
        table.insert(out, {seg("  Authorization required to access this record.", colors.dim)})
        table.insert(out, separator())
        return out
    end

    local out = {}
    local header = format_record_header(id, record)
    for _, l in ipairs(header) do table.insert(out, l) end
    table.insert(out, blank())
    local content = format_record_content(record)
    for _, l in ipairs(content) do table.insert(out, l) end
    local footer = format_record_footer(record)
    for _, l in ipairs(footer) do table.insert(out, l) end

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
        for _, r in ipairs(results) do
            local access_ok = game:canAccessRecord(r.id)
            if access_ok then
                table.insert(out, {
                    seg("  " .. string.format("%-16s", r.id), colors.bright),
                    seg(r.record.title, colors.text),
                })
                table.insert(out, {
                    seg("                  ", colors.dim),
                    seg(r.record.type:upper() .. " | " .. r.record.date .. " | " .. r.record.classification, colors.dim),
                })
            else
                table.insert(out, {
                    seg("  " .. string.format("%-16s", r.id), colors.classified),
                    seg("[CLASSIFIED - ACCESS DENIED]", colors.classified),
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

    local records = {}
    for id, record in pairs(data.records) do
        if not type_filter or record.type == type_filter then
            table.insert(records, {id = id, record = record})
        end
    end
    table.sort(records, function(a, b) return a.id < b.id end)

    local out = {}
    table.insert(out, separator())
    table.insert(out, {
        seg("  RECORDS INDEX", colors.header),
        seg(type_filter and ("  [" .. type_filter:upper() .. "]") or "  [ALL]", colors.dim),
        seg("  (" .. #records .. " records)", colors.dim),
    })
    table.insert(out, separator())
    table.insert(out, blank())

    for _, r in ipairs(records) do
        local access_ok = game:canAccessRecord(r.id)
        local read_marker = game.records_read[r.id] and "  " or "* "
        if access_ok then
            table.insert(out, {
                seg("  " .. read_marker, game.records_read[r.id] and colors.dim or colors.cyan),
                seg(string.format("%-16s", r.id), colors.bright),
                seg(r.record.title, colors.text),
            })
        else
            table.insert(out, {
                seg("  " .. read_marker, colors.classified),
                seg(string.format("%-16s", r.id), colors.classified),
                seg("[CLASSIFIED]", colors.classified),
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
        return {line("  ERROR: Usage: PERSONNEL <id> (e.g., PERSONNEL CIV-0112)", colors.red)}
    end

    local id = args[1]:upper()
    local person = data.personnel[id]
    if not person then
        -- try searching
        local results = data.searchPersonnel(table.concat(args, " "))
        if #results == 0 then
            return {line("  ERROR: Personnel '" .. id .. "' not found.", colors.red)}
        elseif #results == 1 then
            id = results[1].id
            person = results[1].person
        else
            local out = {}
            table.insert(out, line("  Multiple matches found:", colors.amber))
            for _, r in ipairs(results) do
                table.insert(out, {
                    seg("  " .. string.format("%-12s", r.id), colors.bright),
                    seg(r.person.name, colors.text),
                })
            end
            return out
        end
    end

    local out = {}
    table.insert(out, separator())
    table.insert(out, {
        seg("  PERSONNEL FILE: ", colors.dim),
        seg(id, colors.bright),
    })
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
    table.insert(out, {
        seg("  | ", colors.cyan),
        seg(r1.title, colors.header),
    })
    table.insert(out, {
        seg("  | ", colors.cyan),
        seg("Date: " .. r1.date .. "  |  By: " .. r1.filed_by, colors.dim),
    })
    table.insert(out, {seg("  |", colors.cyan)})
    for _, text in ipairs(r1.content) do
        if text ~= "" then
            table.insert(out, {seg("  | " .. text, colors.text)})
        else
            table.insert(out, {seg("  |", colors.cyan)})
        end
    end
    table.insert(out, {seg("  +----------------------------------------------", colors.cyan)})

    table.insert(out, blank())

    table.insert(out, {seg("  +-- " .. id2 .. " -----------------------------------", colors.amber)})
    table.insert(out, {
        seg("  | ", colors.amber),
        seg(r2.title, colors.header),
    })
    table.insert(out, {
        seg("  | ", colors.amber),
        seg("Date: " .. r2.date .. "  |  By: " .. r2.filed_by, colors.dim),
    })
    table.insert(out, {seg("  |", colors.amber)})
    for _, text in ipairs(r2.content) do
        if text ~= "" then
            table.insert(out, {seg("  | " .. text, colors.text)})
        else
            table.insert(out, {seg("  |", colors.amber)})
        end
    end
    table.insert(out, {seg("  +----------------------------------------------", colors.amber)})

    table.insert(out, blank())

    -- auto-analysis for certain comparisons
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

function handlers.INSPECT(game, args)
    if not args or #args == 0 then
        return {line("  ERROR: Usage: INSPECT <system> (water/power/air/population)", colors.red)}
    end

    local sys_key = args[1]:lower()
    local sys = data.systems[sys_key]
    if not sys then
        return {line("  ERROR: Unknown system '" .. args[1] .. "'. Available: water, power, air, population", colors.red)}
    end

    local out = {}
    table.insert(out, separator())
    table.insert(out, header_line("  " .. sys.name))
    table.insert(out, {
        seg("  Sector: ", colors.dim),
        seg(sys.sector, colors.text),
        seg("  |  Status: ", colors.dim),
        seg(sys.status, sys.status == "NOMINAL" and colors.bright or (sys.status == "CAUTION" and colors.amber or colors.red)),
    })
    table.insert(out, separator())
    table.insert(out, blank())
    for _, text in ipairs(sys.details) do
        if text == "" then
            table.insert(out, blank())
        elseif text:find(">") or text:find("ALERT") or text:find("WARNING") then
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
        return {line("  ERROR: Usage: TRACE <resource> (water/power)", colors.red)}
    end

    local resource = args[1]:lower()
    local out = {}

    if resource == "water" or resource == "wtr" then
        table.insert(out, separator())
        table.insert(out, header_line("  WATER DISTRIBUTION TRACE"))
        table.insert(out, separator())
        table.insert(out, blank())
        table.insert(out, {seg("  Source: Primary Aquifer (Sector 6)", colors.text)})
        table.insert(out, {seg("  Total output: 12,400 L/day", colors.text)})
        table.insert(out, blank())
        table.insert(out, {seg("  +-- AQUIFER -----------------------------------------", colors.cyan)})
        table.insert(out, {seg("  |", colors.cyan)})
        table.insert(out, {seg("  |-- WTR-V6-01 > Sector 1:    1,420 L/day", colors.text)})
        table.insert(out, {seg("  |-- WTR-V6-02 > Sector 2:    3,100 L/day", colors.text)})
        table.insert(out, {seg("  |-- WTR-V6-03 > Sector 3:    4,200 L/day", colors.text)})
        table.insert(out, {seg("  |-- WTR-V6-04 > Sector 4:      980 L/day", colors.text)})
        table.insert(out, {seg("  |-- WTR-V6-05 > Sector 5:    1,850 L/day", colors.text)})
        table.insert(out, {seg("  |-- WTR-V6-06 > Sector 6:      520 L/day", colors.text)})
        table.insert(out, {seg("  |-- WTR-V6-07 > Sector 7:      410 L/day", colors.text)})
        table.insert(out, {seg("  |-- WTR-V6-08 > Sector 8:      680 L/day", colors.text)})
        table.insert(out, {
            seg("  |-- WTR-V6-09 > Sector 9:        ", colors.text),
            seg("0 L/day [SEALED]", colors.amber),
        })
        table.insert(out, {
            seg("  |   +-- ", colors.cyan),
            seg("LINE S9-A: 847.3 L/day [ANOMALY]", colors.red),
        })
        table.insert(out, {
            seg("  |       +-- ", colors.cyan),
            seg("Via bypass valve WTR-BV-09 (undocumented)", colors.classified),
        })
        table.insert(out, {seg("  |-- WTR-V6-10 > Sector 10:     240 L/day", colors.text)})
        table.insert(out, {seg("  |-- WTR-V6-11 > Sector 11:     190 L/day", colors.text)})
        table.insert(out, {seg("  +-- WTR-V6-12 > Sector 12:     330 L/day", colors.text)})
        table.insert(out, blank())
        table.insert(out, {
            seg("  Documented total: ", colors.dim),
            seg("13,920 L/day", colors.text),
        })
        table.insert(out, {
            seg("  Actual output:    ", colors.dim),
            seg("12,400 L/day", colors.text),
        })
        table.insert(out, {
            seg("  Discrepancy:      ", colors.dim),
            seg("-1,520 L/day (includes S9-A anomaly)", colors.amber),
        })
        table.insert(out, blank())
        game:onSearchPerformed("water trace")
    elseif resource == "power" or resource == "pwr" then
        table.insert(out, separator())
        table.insert(out, header_line("  POWER DISTRIBUTION TRACE"))
        table.insert(out, separator())
        table.insert(out, blank())
        table.insert(out, {seg("  Source: Geothermal Generator (Sector 7)", colors.text)})
        table.insert(out, {seg("  Total output: 2,400 kWh/day", colors.text)})
        table.insert(out, blank())
        table.insert(out, {seg("  All sectors within nominal parameters.", colors.text)})
        table.insert(out, {
            seg("  Sector 9: ", colors.text),
            seg("12 kWh/day (emergency lighting)", colors.amber),
        })
        table.insert(out, {seg("  Note: 40% above expected for unoccupied sector.", colors.amber)})
        table.insert(out, blank())
    else
        return {line("  ERROR: Unknown resource. Available: water, power", colors.red)}
    end

    table.insert(out, separator())
    return out
end

function handlers.INBOX(game, args)
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
            if msg.priority == "PRIORITY-1" or msg.priority == "URGENT" then pri_color = colors.red
            elseif msg.priority == "PRIORITY-2" then pri_color = colors.amber end
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
    table.insert(out, dim_line("  * = unread  |  Use READ MSG <number> to read"))
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
        local out = {}
        table.insert(out, line("  ERROR: Unknown action '" .. id .. "'.", colors.red))
        table.insert(out, blank())
        table.insert(out, dim_line("  Available actions:"))
        for act_id, act in pairs(data.actions) do
            if game:isActionAvailable(act_id) then
                table.insert(out, {
                    seg("    " .. act_id .. ": ", colors.bright),
                    seg(act.title, colors.text),
                })
            end
        end
        return out
    end

    if not game:isActionAvailable(id) then
        return {line("  ERROR: Action " .. id .. " is not currently available.", colors.amber)}
    end

    local out = {}
    table.insert(out, separator())
    table.insert(out, {
        seg("  AUTHORIZATION REQUEST: ", colors.amber),
        seg(id, colors.bright),
    })
    table.insert(out, separator())
    table.insert(out, blank())
    table.insert(out, {seg("  " .. action.title, colors.header)})
    table.insert(out, {seg("  " .. action.description, colors.text)})
    table.insert(out, blank())
    table.insert(out, {seg("  PROCESSING...", colors.amber)})
    table.insert(out, blank())

    local ending = game:executeAction(id)
    if ending then
        table.insert(out, {seg("  === AUTHORIZATION CONFIRMED ===", colors.bright)})
    end
    table.insert(out, separator())
    return out
end

function handlers.DENY(game, args)
    if not args or #args == 0 then
        return {line("  ERROR: Usage: DENY <action-id>", colors.red)}
    end

    local id = args[1]:upper()
    if not data.actions[id] then
        return {line("  ERROR: Unknown action '" .. id .. "'.", colors.red)}
    end

    return {
        line("  Action " .. id .. " denied. No further action taken.", colors.text),
    }
end

function handlers.CLEAR(game, args)
    return "CLEAR"
end

function handlers.LOGOUT(game, args)
    return "LOGOUT"
end

-- ─── comparison analysis ───────────────────────────────────────────────

function commands.getComparisonAnalysis(id1, id2)
    local key = id1 .. ":" .. id2
    local rkey = id2 .. ":" .. id1

    local analyses = {
        ["INC-2031:WIT-088-A"] = {
            "Dr. Chen's official report states contamination was 'confirmed'.",
            "His personal assessment says he is 'not comfortable stating that",
            "a definitive contamination event has occurred.'",
            "",
            "The report was filed under a 4-hour deadline instead of the",
            "standard 72-hour protocol.",
            "",
            "Chain of custody for samples was non-standard.",
        },
        ["INC-2031:WIT-156-A"] = {
            "INC-2031 states evacuation was completed before seal.",
            "Reyes detected 'active life support cycling' consistent with",
            "occupied quarters DURING the seal procedure.",
            "",
            "Reyes's request to verify evacuation was DENIED by Hale's office.",
            "The evacuation manifest was issued by Administration, not the",
            "evacuation team.",
        },
        ["INC-2031:INC-1987"] = {
            "INC-2031 reports 0 casualties from the contamination event.",
            "INC-1987 shows 43 individuals reclassified as DECEASED and",
            "attributed to the same event.",
            "",
            "No death certificates were filed. No medical examiner reports.",
            "The reclassification was processed via DIR-9901, a directive",
            "the records clerk had never seen.",
        },
        ["MLOG-WTR-1201:MLOG-S9-0847"] = {
            "The pre-seal assessment (MLOG-S9-0847) documents NO bypass",
            "valves on line S9-A.",
            "",
            "MLOG-WTR-1201 references bypass valve WTR-BV-09 as a",
            "'field modification' that is not in the infrastructure diagram.",
            "",
            "Someone installed a bypass valve AFTER the seal.",
        },
        ["WIT-088-A:WIT-156-A"] = {
            "Dr. Chen was pressured to file within 4 hours (non-standard).",
            "Reyes was given 18 hours instead of the standard 72-hour window.",
            "",
            "Both timelines were compressed by Director Hale's office.",
            "Both witnesses express discomfort with the process.",
            "",
            "Chen: could not definitively confirm contamination.",
            "Reyes: detected signs of occupation during seal.",
        },
        ["INC-2047:MLOG-WTR-1201"] = {
            "INC-2047 detects 847.3 L/day flowing through sealed line S9-A.",
            "MLOG-WTR-1201 shows Elena Vasik adjusting a bypass valve on the",
            "same line, a valve that does not exist in official diagrams.",
            "",
            "The maintenance log describes the valve as a 'field modification.'",
            "This was filed routinely. No alarm was raised.",
        },
        ["WIT-031-A:INC-2019"] = {
            "Elena Vasik was found at junction WTR-J7 at 0214 hours.",
            "She claimed to be responding to a pressure alarm.",
            "No alarm was logged.",
            "",
            "Her access logs show 47 visits in 6 months. Average for her role: 8.",
            "She states the junction is 'the closest I can get to where my sister lived.'",
            "",
            "Her sister Marta was among the 43 listed as deceased in Sector 9.",
        },
    }

    return analyses[key] or analyses[rkey]
end

-- ─── autocomplete ──────────────────────────────────────────────────────

function commands.getCompletions(input, game)
    input = input:upper()
    local parts = {}
    for word in input:gmatch("%S+") do
        table.insert(parts, word)
    end

    if #parts == 0 then return {} end

    -- complete first word (command)
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

    -- complete arguments
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

    if (cmd == "COMPARE") then
        local arg_index = input:find("%s$") and #parts + 1 or #parts
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
        for _, name in ipairs({"WATER", "POWER"}) do
            if #partial == 0 or name:sub(1, #partial) == partial then
                table.insert(matches, name)
            end
        end
        return matches
    end

    if cmd == "LIST" and (#parts == 1 or (#parts == 2 and not input:find("%s$"))) then
        local matches = {}
        local partial = #parts >= 2 and parts[2] or ""
        for _, cat in ipairs(LIST_CATEGORIES) do
            if #partial == 0 or cat:sub(1, #partial) == partial then
                table.insert(matches, cat)
            end
        end
        return matches
    end

    if (cmd == "AUTHORIZE" or cmd == "DENY") and (#parts == 1 or (#parts == 2 and not input:find("%s$"))) then
        local matches = {}
        local partial = #parts >= 2 and parts[2] or ""
        for act_id, _ in pairs(data.actions) do
            if game:isActionAvailable(act_id) then
                local act_up = act_id:upper()
                if #partial == 0 or act_up:sub(1, #partial) == partial then
                    table.insert(matches, act_up)
                end
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

-- ─── main execute function ─────────────────────────────────────────────

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
    else
        return {
            {
                {text = "  ERROR: Unknown command '", color = colors.red},
                {text = cmd, color = colors.bright},
                {text = "'. Type HELP for available commands.", color = colors.red},
            },
        }
    end
end

return commands
