local colors = require("colors")
local data = require("data")
local locale = require("locale")

local commands = {}

local function L(k) return locale.t(k) end
local function Lt(k, ...)
    local value = locale.t(k)
    if select("#", ...) > 0 then
        return string.format(value, ...)
    end
    return value
end

local COMMAND_LIST = {
    "HELP", "TASKS", "ACTIONS", "STATUS", "ALERTS", "READ", "SEARCH", "LIST",
    "PERSONNEL", "COMPARE", "INSPECT", "TRACE", "OVERRIDE", "AUTHORIZE",
    "DENY", "INBOX", "CLEAR", "EXIT", "LOGOUT",
}

local COMMAND_ALIASES = {
    AIUTO = "HELP",
    OBIETTIVI = "TASKS",
    AZIONI = "ACTIONS",
    STATO = "STATUS",
    AVVISI = "ALERTS",
    LEGGI = "READ",
    CERCA = "SEARCH",
    ELENCA = "LIST",
    LISTA = "LIST",
    PERSONALE = "PERSONNEL",
    CONFRONTA = "COMPARE",
    ISPEZIONA = "INSPECT",
    TRACCIA = "TRACE",
    AUTORIZZA = "AUTHORIZE",
    NEGA = "DENY",
    POSTA = "INBOX",
    MESSAGGI = "INBOX",
    PULISCI = "CLEAR",
    ESCI = "EXIT",
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
local SYSTEM_ALIASES = {
    water = "water",
    wtr = "water",
    acqua = "water",
    power = "power",
    pwr = "power",
    energia = "power",
    potenza = "power",
    air = "air",
    aria = "air",
    population = "population",
    pop = "population",
    popolazione = "population",
    external = "external",
    ext = "external",
    surface = "external",
    esterno = "external",
    superficie = "external",
}
local LIST_CATEGORY_ALIASES = {
    INCIDENTS = "INCIDENTS",
    INCIDENTI = "INCIDENTS",
    MAINTENANCE = "MAINTENANCE",
    MANUTENZIONE = "MAINTENANCE",
    DIRECTIVES = "DIRECTIVES",
    DIRETTIVE = "DIRECTIVES",
    WITNESS = "WITNESS",
    TESTIMONIANZA = "WITNESS",
    TESTIMONIANZE = "WITNESS",
    ALL = "ALL",
    TUTTO = "ALL",
}
local LOCK_REASON_KEYS = {
    ["  Record sealed inside ANNEX occupancy branch. Rebuild and override required."] = "cmd_lock_annex_rebuild",
    ["  Run the off-ledger ration model before this file exists."] = "cmd_lock_ration_model",
    ["  BLACK VAULT locked. Deep override required."] = "cmd_lock_black_vault",
    ["  Capture a live slate sync from A-17 before this file exists."] = "cmd_lock_slate_sync",
    ["  DAWN branch locked. Surface continuity records remain suppressed."] = "cmd_lock_dawn_branch",
    ["  Run the surface stability model before this file exists."] = "cmd_lock_surface_model",
    ["  Decode the dawn cache before this slate becomes readable."] = "cmd_lock_dawn_cache",
    ["Annex vault access required."] = "cmd_lock_annex_access",
    ["Doctrine-level access required."] = "cmd_lock_doctrine_access",
    ["Dawn branch access required."] = "cmd_lock_dawn_access",
}
local OVERRIDE_ERROR_KEYS = {
    ["Unknown override token."] = "cmd_override_unknown",
    ["This terminal rejects that token at the current depth."] = "cmd_override_depth_reject",
}

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

local function normalize_command_name(name)
    name = (name or ""):upper()
    return COMMAND_ALIASES[name] or name
end

local function normalize_system_name(name)
    return SYSTEM_ALIASES[(name or ""):lower()]
end

local function normalize_list_category(name)
    return LIST_CATEGORY_ALIASES[(name or ""):upper()]
end

local function localize_lock_reason(reason)
    local key = LOCK_REASON_KEYS[reason or ""]
    if key then
        return L(key)
    end
    return reason or L("cmd_record_locked")
end

local function localize_override_error(message)
    local key = OVERRIDE_ERROR_KEYS[message or ""]
    if key then
        return L(key)
    end
    return message or L("cmd_access_reject")
end

local function build_command_names()
    local names = {}
    local seen = {}

    for _, cmd in ipairs(COMMAND_LIST) do
        seen[cmd] = true
        table.insert(names, cmd)
    end

    for alias in pairs(COMMAND_ALIASES) do
        if not seen[alias] then
            seen[alias] = true
            table.insert(names, alias)
        end
    end

    table.sort(names)
    return names
end

local function build_system_completion_names()
    local names = {}
    local seen = {}

    for _, name in ipairs(SYSTEM_NAMES) do
        seen[name] = true
        table.insert(names, name)
    end

    for alias in pairs(SYSTEM_ALIASES) do
        local upper = alias:upper()
        if not seen[upper] then
            seen[upper] = true
            table.insert(names, upper)
        end
    end

    table.sort(names)
    return names
end

local function build_list_category_completion_names()
    local names = {}
    local seen = {}

    for _, category in ipairs(LIST_CATEGORIES) do
        seen[category] = true
        table.insert(names, category)
    end

    for alias in pairs(LIST_CATEGORY_ALIASES) do
        local upper = alias:upper()
        if not seen[upper] then
            seen[upper] = true
            table.insert(names, upper)
        end
    end

    table.sort(names)
    return names
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
        seg(L("cmd_classification"), colors.dim),
        seg(record.classification, record.classification:find("BLACK VAULT") and colors.classified or colors.text),
    })
    table.insert(lines, {
        seg(L("cmd_date"), colors.dim),
        seg(record.date, colors.text),
    })
    table.insert(lines, {
        seg(L("cmd_filed_by"), colors.dim),
        seg(record.filed_by, colors.text),
    })
    table.insert(lines, {
        seg(L("cmd_sector"), colors.dim),
        seg(record.sector, colors.text),
    })
    table.insert(lines, separator())
    return lines
end

local function format_record_content(record)
    local lines = {}
    for _, entry in ipairs(record.content) do
        -- Handle both plain strings (EN) and {text,color} segment tables (IT)
        local text = type(entry) == "table" and entry.text or entry
        local explicit_color = type(entry) == "table" and entry.color or nil

        if text == "" then
            table.insert(lines, blank())
        elseif explicit_color then
            table.insert(lines, {seg("  " .. text, explicit_color)})
        elseif text:find("^%s*>") or text:find("WARNING") or text:find("ALERT") or text:find("AVVISO") or text:find("ALLERTA") then
            table.insert(lines, {seg("  " .. text, colors.amber)})
        elseif text:find("^%s*NOTE") or text:find("^%s*NOTA") or text:find("^%s*RECOMMENDATION") or text:find("^%s*RACCOMANDAZIONE") or text:find("^%s*Directive note") or text:find("^%s*Nota direttiva") then
            table.insert(lines, {seg("  " .. text, colors.cyan)})
        elseif text:find("OVERRIDE CODE") or text:find("CODICE OVERRIDE") or text:find("BLACK VAULT") or text:find("VAULT NERO") then
            table.insert(lines, {seg("  " .. text, colors.classified)})
        elseif text:find("^%s*Q:") or text:find("^%s*D:") then
            table.insert(lines, {seg("  " .. text, colors.dim)})
        elseif text:find("^%s*A:") or text:find("^%s*R:") then
            table.insert(lines, {seg("  " .. text, colors.text)})
        elseif text:find("Cross%-reference") or text:find("Riferimento incrociato") then
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
            seg(L("cmd_related"), colors.dim),
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
    table.insert(out, header_line(L("cmd_available")))
    table.insert(out, separator())
    table.insert(out, blank())

    local cmds = {
        {"HELP",                L("cmd_help_help")},
        {"TASKS",               L("cmd_help_tasks")},
        {"ACTIONS",             L("cmd_help_actions")},
        {"STATUS",              L("cmd_help_status")},
        {"ALERTS",              L("cmd_help_alerts")},
        {"INBOX",               L("cmd_help_inbox")},
        {"READ <id>",           L("cmd_help_read")},
        {"READ MSG <n>",        L("cmd_help_read_msg")},
        {"SEARCH <keyword>",    L("cmd_help_search")},
        {"LIST [category]",     L("cmd_help_list")},
        {"PERSONNEL <id>",      L("cmd_help_personnel")},
        {"COMPARE <id1> <id2>", L("cmd_help_compare")},
        {"INSPECT <system>",    L("cmd_help_inspect")},
        {"TRACE <resource>",    L("cmd_help_trace")},
        {"OVERRIDE <token>",    L("cmd_help_override")},
        {"AUTHORIZE <act-id>",  L("cmd_help_authorize")},
        {"DENY <act-id>",       L("cmd_help_deny")},
        {"CLEAR",               L("cmd_help_clear")},
        {"EXIT",                L("cmd_help_exit")},
        {"LOGOUT",              L("cmd_help_logout")},
    }

    for _, cmd in ipairs(cmds) do
        table.insert(out, {
            seg("  " .. string.format("%-24s", cmd[1]), colors.bright),
            seg(cmd[2], colors.dim),
        })
    end

    table.insert(out, blank())
    table.insert(out, dim_line(L("cmd_help_footer")))
    table.insert(out, separator())
    return out
end

function handlers.TASKS(game, _args)
    local out = {}
    table.insert(out, separator())
    table.insert(out, header_line(L("cmd_objectives")))
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
    table.insert(out, header_line(L("cmd_actions_hdr")))
    table.insert(out, separator())
    table.insert(out, blank())

    if #actions == 0 then
        table.insert(out, dim_line(L("cmd_no_actions")))
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
    table.insert(out, header_line(L("cmd_status_hdr")))
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
    table.insert(out, {seg(L("cmd_proof"), colors.dim), seg(tostring(stats.proof), colors.bright)})
    table.insert(out, {seg(L("cmd_risk"), colors.dim), seg(tostring(stats.risk), stats.risk >= 5 and colors.red or colors.amber)})
    table.insert(out, {seg(L("cmd_strain"), colors.dim), seg(tostring(stats.strain), stats.strain >= 5 and colors.red or colors.amber)})
    table.insert(out, {seg(L("cmd_mercy"), colors.dim), seg(tostring(stats.mercy), colors.text)})
    table.insert(out, {seg(L("cmd_complicity"), colors.dim), seg(tostring(stats.complicity), colors.text)})
    table.insert(out, {seg(L("cmd_records_exam"), colors.dim), seg(tostring(stats.records), colors.text)})
    table.insert(out, {seg(L("cmd_unread_msgs"), colors.dim), seg(tostring(game:getUnreadCount()), game:getUnreadCount() > 0 and colors.cyan or colors.dim)})
    table.insert(out, blank())
    table.insert(out, dim_line(L("cmd_status_hint")))
    table.insert(out, separator())
    return out
end

function handlers.ALERTS(game, _args)
    local out = {}
    table.insert(out, separator())
    table.insert(out, header_line(L("cmd_alerts_hdr")))
    table.insert(out, separator())
    table.insert(out, blank())

    local alerts = {
        {id = "INC-7301", desc = "alert_inc_7301", label = "alert_label_priority_2", severity = "warning"},
    }
    if game.records_read["INC-7290"] then
        table.insert(alerts, {id = "INC-7290", desc = "alert_inc_7290", label = "alert_label_priority_2", severity = "warning"})
    end
    if game.records_read["INC-7288"] then
        table.insert(alerts, {id = "INC-7288", desc = "alert_inc_7288", label = "alert_label_priority_3", severity = "warning"})
    end
    if game.records_read["INC-7021"] then
        table.insert(alerts, {id = "INC-7021", desc = "alert_inc_7021", label = "alert_label_priority_2", severity = "warning"})
    end
    if game.records_read["INC-7322"] then
        table.insert(alerts, {id = "INC-7322", desc = "alert_inc_7322", label = "alert_label_priority_2", severity = "warning"})
    end
    if game.flags["annex_vault_unlocked"] then
        table.insert(alerts, {id = "DIR-8890", desc = "alert_dir_8890", label = "alert_label_directive_breach", severity = "critical"})
    end
    if game.flags["dawn_vault_unlocked"] then
        table.insert(alerts, {id = "DIR-8700", desc = "alert_dir_8700", label = "alert_label_directive_breach", severity = "critical"})
    end
    if game.records_read["INC-7295"] then
        table.insert(alerts, {id = "INC-7295", desc = "alert_inc_7295", label = "alert_label_priority_2", severity = "warning"})
    end
    if game.records_read["INC-7300"] then
        table.insert(alerts, {id = "INC-7300", desc = "alert_inc_7300", label = "alert_label_priority_2", severity = "warning"})
    end
    if game.records_read["INC-6410"] then
        table.insert(alerts, {id = "INC-6410", desc = "alert_inc_6410", label = "alert_label_priority_1", severity = "critical"})
    end
    if game.records_read["INC-5820"] then
        table.insert(alerts, {id = "INC-5820", desc = "alert_inc_5820", label = "alert_label_priority_3", severity = "warning"})
    end
    if game.flags["construction_lead"] then
        table.insert(alerts, {id = "WIT-099-A", desc = "alert_wit_099_a", label = "alert_label_priority_2", severity = "warning"})
    end
    if game.records_read["DIR-9200"] then
        table.insert(alerts, {id = "DIR-9200", desc = "alert_dir_9200", label = "alert_label_directive_breach", severity = "critical"})
    end
    if game.records_read["INC-6120"] then
        table.insert(alerts, {id = "INC-6120", desc = "alert_inc_6120", label = "alert_label_directive_breach", severity = "critical"})
    end
    if game.flags["ash_contact"] then
        table.insert(alerts, {id = "SEC", desc = "alert_sec", label = "alert_label_priority_1", severity = "critical"})
    end
    if game.records_read["MLOG-ANN-0025"] then
        table.insert(alerts, {id = "MLOG-ANN-0025", desc = "alert_mlog_ann_0025", label = "alert_label_priority_1", severity = "critical"})
    end
    if game.records_read["WIT-MIRA-001"] then
        table.insert(alerts, {id = "WIT-MIRA-001", desc = "alert_wit_mira_001", label = "alert_label_personal", severity = "warning"})
    end
    if game.decisions_unlocked then
        table.insert(alerts, {id = "FINAL", desc = "alert_final", label = "alert_label_immediate", severity = "critical"})
    end

    for _, alert in ipairs(alerts) do
        local pri_color = colors.amber
        if alert.severity == "critical" then
            pri_color = colors.red
        end
        table.insert(out, {
            seg("  [" .. L(alert.label) .. "] ", pri_color),
            seg(alert.id, colors.bright),
            seg(": " .. L(alert.desc), colors.text),
        })
    end

    table.insert(out, blank())
    table.insert(out, separator())
    return out
end

function handlers.READ(game, args)
    if not args or #args == 0 then
        return {line(L("cmd_read_usage"), colors.red)}
    end

    if args[1]:upper() == "MSG" then
        if not args[2] then
            return {line(L("cmd_read_msg_usage"), colors.red)}
        end
        local n = tonumber(args[2])
        if not n or n < 1 or n > #game.inbox then
            return {line(L("cmd_invalid_msg"), colors.red)}
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
        table.insert(out, {seg(L("cmd_message_label"), colors.dim), seg(entry.id, colors.bright)})
        table.insert(out, {seg(L("cmd_from"), colors.dim), seg(msg.from, msg.from == "UNKNOWN TERMINAL" and colors.amber or colors.text)})
        table.insert(out, {seg(L("cmd_subject"), colors.dim), seg(msg.subject, colors.header)})
        table.insert(out, {seg(L("cmd_priority"), colors.dim), seg(" " .. msg.priority, (msg.priority == "PRIORITY-1" or msg.priority == "URGENT") and colors.red or colors.text)})
        table.insert(out, separator())
        table.insert(out, blank())

        for _, text in ipairs(msg.content) do
            if text == "" then
                table.insert(out, blank())
            elseif text:find("^%s*>") then
                table.insert(out, {seg("  " .. text, colors.amber)})
            elseif text:find("ACT%-") then
                table.insert(out, {seg("  " .. text, colors.cyan)})
            elseif text:find("OVERRIDE CODE") or text:find("CODICE OVERRIDE") then
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
        return {line(Lt("cmd_record_not_found_search", id), colors.red)}
    end

    if not game:canAccessRecord(id) then
        local out = {}
        table.insert(out, separator())
        table.insert(out, {seg(L("cmd_access_denied"), colors.red)})
        table.insert(out, blank())
        table.insert(out, {seg(localize_lock_reason(record.lock_reason), colors.amber)})
        table.insert(out, blank())
        table.insert(out, {seg(L("cmd_override_hint"), colors.dim)})
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
        return {line("  " .. L("cmd_search_hint"), colors.red)}
    end

    local keyword = table.concat(args, " ")
    local results = data.search(keyword)
    game:onSearchPerformed(keyword)

    local out = {}
    table.insert(out, separator())
    table.insert(out, {
        seg(L("cmd_search_results"), colors.dim),
        seg('"' .. keyword .. '"', colors.bright),
        seg("  (" .. #results .. L("cmd_found"), colors.dim),
    })
    table.insert(out, separator())

    if #results == 0 then
        table.insert(out, blank())
        table.insert(out, dim_line(L("cmd_no_results")))
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
                    seg(L("cmd_locked_label"), colors.classified),
                })
            end
            table.insert(out, blank())
        end
    end

    table.insert(out, separator())
    return out
end

function handlers.LIST(game, args)
    local category = (args and #args > 0) and normalize_list_category(args[1]) or "ALL"
    local type_filter = nil

    if category == "INCIDENTS" then type_filter = "incident"
    elseif category == "MAINTENANCE" then type_filter = "maintenance"
    elseif category == "DIRECTIVES" then type_filter = "directive"
    elseif category == "WITNESS" then type_filter = "witness"
    elseif category ~= "ALL" then
        return {
            line(Lt("cmd_list_category_unknown", args[1] or ""), colors.red),
            line(L("cmd_list_categories_available"), colors.dim),
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
        seg(L("cmd_record_index"), colors.header),
        seg(type_filter and ("  [" .. type_filter:upper() .. "]") or "  [ALL]", colors.dim),
        seg("  (" .. #results .. L("cmd_records_label"), colors.dim),
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
                seg(L("cmd_locked"), colors.classified),
            })
        end
    end

    table.insert(out, blank())
    table.insert(out, dim_line(L("cmd_list_footer")))
    table.insert(out, separator())
    return out
end

function handlers.PERSONNEL(game, args)
    if not args or #args == 0 then
        return {line(L("cmd_personnel_usage"), colors.red)}
    end

    local id = args[1]:upper()
    local person = data.personnel[id]
    if not person then
        local results = data.searchPersonnel(table.concat(args, " "))
        if #results == 0 then
            return {line(Lt("cmd_personnel_not_found", id), colors.red)}
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
    table.insert(out, {seg(L("cmd_personnel_file"), colors.dim), seg(id, colors.bright)})
    table.insert(out, separator())
    table.insert(out, {seg(L("cmd_name"), colors.dim), seg(person.name, colors.header)})
    table.insert(out, {seg(L("cmd_role"), colors.dim), seg(person.role, colors.text)})
    table.insert(out, {seg(L("cmd_sector_label"), colors.dim), seg(person.sector, colors.text)})
    table.insert(out, {seg(L("cmd_clearance"), colors.dim), seg(L("cmd_level") .. person.clearance, colors.text)})
    table.insert(out, {seg(L("cmd_status_label"), colors.dim), seg(person.status, person.status == "ACTIVE" and colors.bright or colors.red)})
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
        return {line(L("cmd_compare_usage"), colors.red)}
    end

    local id1 = args[1]:upper()
    local id2 = args[2]:upper()
    local r1 = data.records[id1]
    local r2 = data.records[id2]

    if not r1 then return {line(Lt("cmd_record_not_found_simple", id1), colors.red)} end
    if not r2 then return {line(Lt("cmd_record_not_found_simple", id2), colors.red)} end
    if not game:canAccessRecord(id1) then return {line(Lt("cmd_access_denied_to", id1), colors.red)} end
    if not game:canAccessRecord(id2) then return {line(Lt("cmd_access_denied_to", id2), colors.red)} end

    local out = {}
    table.insert(out, separator())
    table.insert(out, {
        seg(L("cmd_comparison"), colors.dim),
        seg(id1, colors.bright),
        seg(L("cmd_vs"), colors.dim),
        seg(id2, colors.bright),
    })
    table.insert(out, separator())
    table.insert(out, blank())

    table.insert(out, {seg("  +-- " .. id1 .. " -----------------------------------", colors.cyan)})
    table.insert(out, {seg("  | " .. r1.title, colors.header)})
    table.insert(out, {seg("  | " .. L("cmd_date"):gsub("^%s+","") .. r1.date .. "  |  " .. L("cmd_filed_by"):gsub("^%s+","") .. r1.filed_by, colors.dim)})
    for _, entry in ipairs(r1.content) do
        local text = type(entry) == "table" and entry.text or entry
        table.insert(out, {seg(text == "" and "  |" or ("  | " .. text), colors.text)})
    end
    table.insert(out, {seg("  +----------------------------------------------", colors.cyan)})
    table.insert(out, blank())

    table.insert(out, {seg("  +-- " .. id2 .. " -----------------------------------", colors.amber)})
    table.insert(out, {seg("  | " .. r2.title, colors.header)})
    table.insert(out, {seg("  | " .. L("cmd_date"):gsub("^%s+","") .. r2.date .. "  |  " .. L("cmd_filed_by"):gsub("^%s+","") .. r2.filed_by, colors.dim)})
    for _, entry in ipairs(r2.content) do
        local text = type(entry) == "table" and entry.text or entry
        table.insert(out, {seg(text == "" and "  |" or ("  | " .. text), colors.text)})
    end
    table.insert(out, {seg("  +----------------------------------------------", colors.amber)})
    table.insert(out, blank())

    local analysis = commands.getComparisonAnalysis(id1, id2)
    if analysis then
        table.insert(out, {seg(L("cmd_discrepancy"), colors.classified)})
        for _, text in ipairs(analysis) do
            table.insert(out, {seg("  | " .. text, colors.amber)})
        end
        table.insert(out, {seg(L("cmd_discrepancy_end"), colors.classified)})
    end

    table.insert(out, separator())
    game:onComparisonMade(id1, id2)
    return out
end

function handlers.INSPECT(game, args)
    if not args or #args == 0 then
        return {line(L("cmd_inspect_hint"), colors.red)}
    end

    local id = args[1]:upper()
    local record = data.records[id]
    if record then
        if not game:canAccessRecord(id) then
            return {line(Lt("cmd_access_denied_to", id), colors.red)}
        end

        local out = {}
        table.insert(out, separator())
        table.insert(out, header_line(L("cmd_inspect_hdr")))
        table.insert(out, separator())
        table.insert(out, {seg("  " .. id, colors.bright)})
        table.insert(out, {seg("  " .. record.title, colors.header)})
        table.insert(out, separator())
        table.insert(out, {seg(L("cmd_type_label"), colors.dim), seg(record.type:upper(), colors.text)})
        table.insert(out, {seg(L("cmd_classification"), colors.dim), seg(record.classification, record.classification:find("BLACK VAULT") and colors.classified or colors.text)})
        table.insert(out, {seg(L("cmd_date"), colors.dim), seg(record.date, colors.text)})
        table.insert(out, {seg(L("cmd_filed_by"), colors.dim), seg(record.filed_by, colors.text)})
        table.insert(out, {seg(L("cmd_sector"), colors.dim), seg(record.sector, colors.text)})
        if record.related and #record.related > 0 then
            table.insert(out, {seg(L("cmd_xrefs"), colors.dim), seg(table.concat(record.related, ", "), colors.cyan)})
        end
        if record.keywords and #record.keywords > 0 then
            table.insert(out, {seg(L("cmd_keywords_label"), colors.dim), seg(table.concat(record.keywords, ", "), colors.dim)})
        end
        table.insert(out, separator())
        return out
    end

    local key = normalize_system_name(args[1])
    local sys = key and data.systems[key] or nil
    if not sys then
        return {line(L("cmd_trace_unknown"), colors.red)}
    end

    local out = {}
    table.insert(out, separator())
    table.insert(out, header_line("  " .. sys.name))
    table.insert(out, {
        seg(L("cmd_sector_prefix"), colors.dim),
        seg(sys.sector, colors.text),
        seg(L("cmd_status_prefix"), colors.dim),
        seg(sys.status, sys.status == "NOMINAL" and colors.bright or colors.amber),
    })
    table.insert(out, separator())
    table.insert(out, blank())
    for _, text in ipairs(sys.details) do
        if text == "" then
            table.insert(out, blank())
        elseif text:find(">") or text:find("WARNING") or text:find("ALERT") or text:find("AVVISO") or text:find("ALLERTA") then
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
        return {line(L("cmd_trace_hint"), colors.red)}
    end

    local resource = normalize_system_name(args[1])
    local out = {}

    if resource == "water" then
        table.insert(out, separator())
        table.insert(out, header_line(L("cmd_trace_hdr") .. L("trace_label_water")))
        table.insert(out, separator())
        table.insert(out, blank())
        table.insert(out, {seg(L("trace_water_source"), colors.text)})
        table.insert(out, {seg(L("trace_water_output"), colors.text)})
        table.insert(out, blank())
        table.insert(out, {seg(L("trace_water_public"), colors.text)})
        table.insert(out, {seg(L("trace_water_reserve"), colors.text)})
        table.insert(out, {seg(L("trace_water_a17"), colors.cyan)})
        table.insert(out, {seg(L("trace_water_draw"), colors.red)})
        table.insert(out, {seg(L("trace_water_curve"), colors.amber)})
        table.insert(out, blank())
        game:onSearchPerformed("trace water")
    elseif resource == "power" then
        table.insert(out, separator())
        table.insert(out, header_line(L("cmd_trace_hdr") .. L("trace_label_power")))
        table.insert(out, separator())
        table.insert(out, blank())
        table.insert(out, {seg(L("trace_power_source"), colors.text)})
        table.insert(out, {seg(L("trace_power_public"), colors.text)})
        table.insert(out, {seg(L("trace_power_annex"), colors.amber)})
        table.insert(out, blank())
        game:onSearchPerformed("trace power")
    elseif resource == "air" then
        table.insert(out, separator())
        table.insert(out, header_line(L("cmd_trace_hdr") .. L("trace_label_air")))
        table.insert(out, separator())
        table.insert(out, blank())
        table.insert(out, {seg(L("trace_air_main"), colors.text)})
        table.insert(out, {seg(L("trace_air_a17"), colors.amber)})
        table.insert(out, {seg(L("trace_air_residue"), colors.text)})
        table.insert(out, blank())
        game:onSearchPerformed("trace air")
    elseif resource == "population" then
        table.insert(out, separator())
        table.insert(out, header_line(L("cmd_trace_hdr") .. L("trace_label_population")))
        table.insert(out, separator())
        table.insert(out, blank())
        table.insert(out, {seg(L("trace_pop_public"), colors.text)})
        table.insert(out, {seg(L("trace_pop_hidden"), colors.red)})
        table.insert(out, {seg(L("trace_pop_tag"), colors.amber)})
        table.insert(out, blank())
        game:onSearchPerformed("trace population")
    elseif resource == "external" then
        table.insert(out, separator())
        table.insert(out, header_line(L("cmd_trace_hdr") .. L("trace_label_external")))
        table.insert(out, separator())
        table.insert(out, blank())
        table.insert(out, {seg(L("trace_ext_mast"), colors.text)})
        table.insert(out, {seg(L("trace_ext_mask"), colors.amber)})
        table.insert(out, {seg(L("trace_ext_signal"), colors.text)})
        table.insert(out, {seg(L("trace_ext_servo"), colors.text)})
        table.insert(out, blank())
        game:onSearchPerformed("trace external")
    else
        return {line(L("cmd_trace_unknown"), colors.red)}
    end

    table.insert(out, separator())
    return out
end

function handlers.OVERRIDE(game, args)
    if not args or #args == 0 then
        return {line(L("cmd_override_usage"), colors.red)}
    end

    local token = table.concat(args, " ")
    local result = game:unlockOverride(token)
    local out = {}

    table.insert(out, separator())
    table.insert(out, {seg(L("cmd_override_token"), colors.dim), seg(token:upper(), colors.classified)})
    table.insert(out, separator())
    table.insert(out, blank())

    if not result.ok then
        table.insert(out, {seg(L("cmd_access_reject"), colors.red)})
        table.insert(out, {seg("  " .. localize_override_error(result.message), colors.amber)})
        table.insert(out, blank())
        table.insert(out, separator())
        return out
    end

    if result.already then
        table.insert(out, {seg(L("cmd_token_applied"), colors.amber)})
        table.insert(out, {seg(L("cmd_token_open"), colors.text)})
        table.insert(out, blank())
        table.insert(out, separator())
        return out
    end

    table.insert(out, {seg(L("cmd_override_ok"), colors.bright)})
    table.insert(out, {seg("  " .. result.entry.title, colors.header)})
    table.insert(out, {seg("  " .. result.entry.description, colors.text)})
    table.insert(out, blank())
    table.insert(out, {seg(L("cmd_unlocked_recs"), colors.dim)})
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
        seg(L("cmd_inbox_hdr"), colors.header),
        seg("  (" .. #game.inbox .. L("cmd_messages_count") .. game:getUnreadCount() .. L("cmd_unread_count"), colors.dim),
    })
    table.insert(out, separator())
    table.insert(out, blank())

    if #game.inbox == 0 then
        table.insert(out, dim_line(L("cmd_no_messages")))
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
    table.insert(out, dim_line(L("cmd_inbox_footer")))
    table.insert(out, separator())
    return out
end

function handlers.AUTHORIZE(game, args)
    if not args or #args == 0 then
        return {line(L("cmd_auth_usage"), colors.red)}
    end

    local id = args[1]:upper()
    local action = data.actions[id]
    if not action then
        return {line(L("cmd_no_action"), colors.red)}
    end

    if not game:isActionAvailable(id) then
        return {line(L("cmd_no_action"), colors.amber)}
    end

    local result = game:executeAction(id)
    if not result then
        return {line(L("cmd_no_action"), colors.red)}
    end

    local out = {}
    table.insert(out, separator())
    table.insert(out, {seg(L("cmd_auth_request"), colors.amber), seg(id, colors.bright)})
    table.insert(out, separator())
    table.insert(out, blank())
    table.insert(out, {seg("  " .. action.title, colors.header)})
    table.insert(out, {seg("  " .. action.description, colors.text)})
    table.insert(out, blank())
    table.insert(out, {seg(L("cmd_processing"), colors.amber)})
    table.insert(out, blank())

    for _, text in ipairs(result.notes or {}) do
        table.insert(out, {seg("  " .. text, colors.text)})
    end

    if result.ending then
        table.insert(out, blank())
        table.insert(out, {seg(L("cmd_auth_confirmed"), colors.bright)})
    end

    table.insert(out, separator())
    return out
end

function handlers.DENY(_game, args)
    if not args or #args == 0 then
        return {line(L("cmd_deny_usage"), colors.red)}
    end
    local id = args[1]:upper()
    if not data.actions[id] then
        return {line(L("cmd_no_action"), colors.red)}
    end
    return {line(L("cmd_denial_logged") .. id, colors.text)}
end

function handlers.CLEAR(_game, _args)
    return "CLEAR"
end

function handlers.LOGOUT(_game, _args)
    return "LOGOUT"
end

function handlers.EXIT(_game, _args)
    return "EXIT"
end

function commands.getComparisonAnalysis(id1, id2)
    local key = id1 .. ":" .. id2
    local rkey = id2 .. ":" .. id1

    -- Check for localized comparison first
    local localized = locale.getComparison(id1, id2)
    if localized then return localized end

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
        ["INC-7295:MLOG-PWR-4410"] = {
            "INC-7295 flags a parasitic load on a feeder that should carry nothing.",
            "MLOG-PWR-4410 shows those taps were placed by someone who knew the routing grid.",
            "",
            "This was not accidental leakage. It was professional concealment of life support.",
        },
        ["INC-7300:MLOG-ANN-0007"] = {
            "Thermal imaging finds body heat behind a wall that should be cold.",
            "The ingress power test confirms bunks and living space behind that same wall.",
            "",
            "The heat is not anomalous. It is sixty-four people breathing.",
        },
        ["INC-7310:INC-7288"] = {
            "Archive suppression has been actively maintained for eleven years.",
            "The population checksum mismatch hides behind that same suppression.",
            "",
            "Someone has been gardening the data to keep the hidden branch invisible.",
        },
        ["MLOG-FOOD-4415:DIR-4012"] = {
            "64 anonymous ration events labelled CANTEEN-ZERO appear daily.",
            "The triage ladder explicitly denies standing to unregistered persons.",
            "",
            "The food proves they exist. The policy says they do not.",
        },
        ["MLOG-SEC-4420:MLOG-SEC-6001"] = {
            "Present-day camera feeds are looped to hide movement near A-17.",
            "The 2060 arrest log shows detention orders written 48 hours before the protest.",
            "",
            "Security has been managing this lie from both ends of the timeline.",
        },
        ["WIT-555-A:INC-6550"] = {
            "The Lantern Assembly asked for an elected council and resource audits.",
            "The disturbance report frames these same people as destabilizers.",
            "",
            "Their reasonable demands were rewritten as security threats to justify disappearance.",
        },
        ["INC-6200:MLOG-WTR-4408"] = {
            "740 liters per day were rerouted away from public supply before Lantern.",
            "The water draw on A-17 began after they were relocated there.",
            "",
            "First they took the water. Then they used the shortage as a weapon.",
        },
        ["WIT-099-A:DIR-1010"] = {
            "Renn's testimony proves sealed habitable volumes were built before Lantern.",
            "The MERIDIAN charter itself provides for 'dissent reduction infrastructure.'",
            "",
            "The cage was designed before the crime. The silo was built to disappear people.",
        },
        ["INC-5820:INC-6402"] = {
            "The Selection Protocol weighted for political compliance, not survival fitness.",
            "The relocation order moved Lantern Assembly members into sealed annex.",
            "",
            "The lottery was never random. The disappearances were never temporary.",
        },
        ["MLOG-ANN-0012:MLOG-ANN-0018"] = {
            "The classroom log shows what the children are forbidden to learn.",
            "The birth registry shows children identified by code, not name.",
            "",
            "They are being raised without sky, without names, without the words for what was stolen.",
        },
        ["WIT-308-B:WIT-308-A"] = {
            "Ten years ago, Elsa asked why a 48-hour isolation needed nursery supplies.",
            "Now she calls the annex 'the close sky' and refuses to leave.",
            "",
            "She understood the lie on night one. By year ten, she had become its mother.",
        },
        ["DIR-5050:DIR-4980"] = {
            "Long-term disposition includes 'phase reduction' — controlled starvation.",
            "Calm-ash keeps them docile enough not to notice the thinning.",
            "",
            "They are being chemically quieted while being slowly starved. Each policy enables the other.",
        },
        ["INC-6410:WIT-084-A"] = {
            "Seven people died including two children when medical response was denied.",
            "Dr. Sera's notes describe calm-ash as causing developmental damage.",
            "",
            "The compound makes them sick. When they get sick, they are denied treatment.",
        },
        ["WIT-VEY-001:WIT-VEY-002"] = {
            "In the official memo, Vey justifies inheriting the annex as a stability measure.",
            "In the margin note, she admits she knows it is wrong and is afraid.",
            "",
            "Fear looks like conviction from the outside. On the inside, it looks like this.",
        },
        ["DIR-9200:DIR-8700"] = {
            "Four or more silos maintain hidden populations. Silo 9 refused and was destroyed.",
            "DIR-8700 suppresses knowledge that the surface is not uniformly lethal.",
            "",
            "They are hiding people from the sky and the sky from people, across every facility.",
        },
        ["MLOG-EXT-4405:INC-6117"] = {
            "Surface material analysis finds living soil, pollen, and beetle chitin.",
            "Team Kestrel found breathable intervals years before this sample.",
            "",
            "The surface has been recovering for longer than anyone inside has been told.",
        },
        ["INC-6120:DIR-8700"] = {
            "Team Sparrow surveyed the surface before the silo was sealed and found it viable.",
            "DIR-8700 orders the public told the surface is uniformly fatal.",
            "",
            "They did not discover the lie later. They built the silo on top of it.",
        },
        ["MLOG-PWR-4410:MLOG-ANN-0007"] = {
            "Marek Sorn's power routing shows professional unauthorized taps on retired feeders.",
            "The ingress power test confirms those feeders supply 64 bunks and a classroom.",
            "",
            "A sanitation porter has been keeping the lights on for hidden children for eleven years.",
        },
        ["INC-6200:INC-6550"] = {
            "Water was being rerouted away from public supply before the Lantern protests.",
            "The Lantern Assembly demanded resource audits — exactly what would have exposed the rerouting.",
            "",
            "The protest was not about ideology. It was about to find the missing water.",
        },
        ["MLOG-PER-0031:MLOG-ANN-0025"] = {
            "Your personnel file mentions a family connection to Suppression Event CL-2060.",
            "The detainee manifest lists VOSS, MIRA as entry A17-22. Age at intake: fifteen.",
            "",
            "Your sister has been behind the wall for eleven years. You are reading her file.",
        },
        ["MLOG-PER-0031:MLOG-SEC-0031"] = {
            "Your personnel evaluation calls your night shift assignment 'standard rotation.'",
            "Your security observation file says Drenn requested the assignment three months early.",
            "",
            "You were not rotated here. You were placed here.",
        },
        ["MLOG-SEC-0031:DIR-ASSIGN-0031"] = {
            "Security has been watching you since the day you sat down at this terminal.",
            "Drenn's handwritten addendum says she chose you because you have a sister behind the wall.",
            "",
            "Ash watches to contain you. Drenn arranged you to find the truth. You sit between their intentions.",
        },
        ["INC-MOR-2071:DIR-4980"] = {
            "Morale scores are identical to two decimal places across 1,800 respondents. Probability: near zero.",
            "The calm-ash directive calls cognitive suppression an acceptable population management tool.",
            "",
            "They are not measuring morale. They are measuring the dosage.",
        },
        ["MLOG-CAF-3001:MLOG-FOOD-4415"] = {
            "Ration allocations have dropped 460 kcal per person since 2065.",
            "64 CANTEEN-ZERO events appear daily in the food distribution log.",
            "",
            "The silo is slowly starving because it is feeding people who do not officially exist.",
        },
        ["WIT-ANON-001:MLOG-SHIFT-7140"] = {
            "Operator 27 warns you that they rotate night operators every 14 months.",
            "The shift handover log confirms six previous operators with an average tenure of 14.2 months.",
            "",
            "You are not discovering anything new. You are the seventh person to find the same branch.",
        },
        ["INC-ARC-7340:MLOG-SEC-0031"] = {
            "Your access audit shows every query forwarded to Commander Ash in real-time.",
            "Your security file says if you access suppressed branches, Ash is to be notified immediately.",
            "",
            "You are reading your own surveillance. The surveillance is reading you back.",
        },
        ["WIT-KELL-001:WIT-MIRA-001"] = {
            "Elsa Kell writes about a girl named Mira who asked if she had a family.",
            "Mira's own slate says she remembers someone with her eyes but cannot hold the name.",
            "",
            "Your sister is alive. She is trying to remember you. She drew a bird she has never seen.",
        },
        ["INC-MAINT-0088:INC-7300"] = {
            "Twelve years of identical maintenance entries: 'partition sealed, no access required.'",
            "Thermal imaging shows body heat behind that same sealed partition.",
            "",
            "The inspector was never asked to notice. The heat was never asked to stop.",
        },
        ["MLOG-POP-2071:INC-MOR-2071"] = {
            "Voluntary sterilization has quadrupled since the calm-ash water additive began.",
            "Morale scores are statistically impossible in their uniformity.",
            "",
            "The population is not choosing stability. It is being chemically rendered into it.",
        },
        ["MLOG-ANN-0025:MLOG-ANN-0018"] = {
            "The detainee manifest lists 45 adults relocated in 2060. The birth registry lists 19 children born after.",
            "The children are identified by code numbers. The adults at least have names.",
            "",
            "In one generation, they went from political prisoners to a nameless population experiment.",
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
        for _, cmd in ipairs(build_command_names()) do
            if cmd:sub(1, #parts[1]) == parts[1] and cmd ~= parts[1] then
                table.insert(matches, cmd)
            end
        end
        return matches
    end

    local cmd = normalize_command_name(parts[1])

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
        for _, id in ipairs(RECORD_IDS) do
            if #partial == 0 or id:sub(1, #partial) == partial then
                table.insert(matches, id)
            end
        end
        for _, name in ipairs(build_system_completion_names()) do
            if #partial == 0 or name:sub(1, #partial) == partial then
                table.insert(matches, name)
            end
        end
        return matches
    end

    if cmd == "TRACE" and (#parts == 1 or (#parts == 2 and not input:find("%s$"))) then
        local matches = {}
        local partial = #parts >= 2 and parts[2] or ""
        for _, name in ipairs(build_system_completion_names()) do
            if #partial == 0 or name:sub(1, #partial) == partial then
                table.insert(matches, name)
            end
        end
        return matches
    end

    if cmd == "LIST" and (#parts == 1 or (#parts == 2 and not input:find("%s$"))) then
        local matches = {}
        local partial = #parts >= 2 and parts[2] or ""
        for _, category in ipairs(build_list_category_completion_names()) do
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
        return input:upper() .. ghost
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

    local cmd = normalize_command_name(parts[1]:upper())
    local args = {}
    for i = 2, #parts do
        table.insert(args, parts[i])
    end

    local handler = handlers[cmd]
    if handler then
        return handler(game, args)
    end

    return {{
        {text = L("cmd_unknown_pre"), color = colors.red},
        {text = cmd, color = colors.bright},
        {text = L("cmd_unknown_post"), color = colors.red},
    }}
end

return commands
