local data = require("data")
local locale = require("locale")

local Game = {}
Game.__index = Game

local function count_true(map)
    local total = 0
    for _, value in pairs(map) do
        if value then total = total + 1 end
    end
    return total
end

local function has_all_flags(flags, required)
    if not required then return true end
    if type(required) == "string" then
        return flags[required] == true
    end
    for _, flag in ipairs(required) do
        if not flags[flag] then
            return false
        end
    end
    return true
end

local function normalize_code(code)
    code = (code or ""):upper()
    code = code:gsub("^%s+", ""):gsub("%s+$", "")
    code = code:gsub("%s+", "-")
    return code
end

local function copy_map(source)
    local out = {}
    for key, value in pairs(source or {}) do
        if type(value) == "table" then
            local nested = {}
            for k, v in pairs(value) do
                nested[k] = v
            end
            out[key] = nested
        else
            out[key] = value
        end
    end
    return out
end

local function copy_array(source)
    local out = {}
    for i, value in ipairs(source or {}) do
        if type(value) == "table" then
            local nested = {}
            for k, v in pairs(value) do
                if type(v) == "table" then
                    local nested2 = {}
                    for k2, v2 in pairs(v) do
                        nested2[k2] = v2
                    end
                    nested[k] = nested2
                else
                    nested[k] = v
                end
            end
            out[i] = nested
        else
            out[i] = value
        end
    end
    return out
end

local function compute_decisions_unlocked(self)
    return self.flags["doctrine_unlocked"]
        and self.flags["dawn_vault_unlocked"]
        and self.flags["model_generated"]
        and self.flags["surface_model_generated"]
        and self.flags["surface_cache_decoded"]
        and self.flags["camera_looped"]
        and self.records_read["DIR-9104"]
        and self.records_read["DIR-9991"]
        and self.records_read["INC-7316"]
        and self.records_read["DIR-8700"]
        and self.records_read["DIR-9408"]
        and self.records_read["INC-6117"]
        and self.records_read["INC-7336"]
end

function Game.new()
    local self = setmetatable({}, Game)
    self.phase = "boot"
    self.flags = {}
    self.inbox = {}
    self.unread_count = 0
    self.alert_count = 1
    self.records_read = {}
    self.personnel_viewed = {}
    self.searches_performed = {}
    self.comparisons_made = {}
    self.actions_taken = {}
    self.game_time = 0
    self.ending = nil
    self.message_timers = {}
    self.proof_score = 0
    self.audit_risk = 0
    self.strain = 0
    self.mercy = 0
    self.complicity = 0
    self.chapter = 1
    self.decisions_unlocked = false
    return self
end

function Game.fromSnapshot(snapshot)
    local self = Game.new()
    snapshot = snapshot or {}

    self.phase = snapshot.phase or "main"
    self.flags = copy_map(snapshot.flags)
    self.inbox = {}
    self.records_read = copy_map(snapshot.records_read)
    self.personnel_viewed = copy_map(snapshot.personnel_viewed)
    self.searches_performed = copy_map(snapshot.searches_performed)
    self.comparisons_made = copy_map(snapshot.comparisons_made)
    self.actions_taken = copy_map(snapshot.actions_taken)
    self.game_time = snapshot.game_time or 0
    self.ending = snapshot.ending
    self.message_timers = copy_map(snapshot.message_timers)
    self.proof_score = snapshot.proof_score or 0
    self.audit_risk = snapshot.audit_risk or 0
    self.strain = snapshot.strain or 0
    self.mercy = snapshot.mercy or 0
    self.complicity = snapshot.complicity or 0
    self.chapter = snapshot.chapter or 1
    self.decisions_unlocked = snapshot.decisions_unlocked or false

    self.unread_count = 0
    for _, entry in ipairs(snapshot.inbox or {}) do
        local msg = entry.id and data.messages[entry.id] or nil
        if not msg and type(entry.message) == "table" then
            msg = entry.message
        end
        if msg then
            table.insert(self.inbox, {
                id = entry.id,
                message = msg,
                read = entry.read == true,
            })
            if entry.read ~= true then
                self.unread_count = self.unread_count + 1
            end
        end
    end

    self.decisions_unlocked = compute_decisions_unlocked(self)
    self:updateDerivedState()
    return self
end

function Game:start()
    self.phase = "main"
    self:queueMessage("MSG-001", 2.0)
    self:updateDerivedState()
end

function Game:update(dt)
    self.game_time = self.game_time + dt

    for msg_id, timer in pairs(self.message_timers) do
        self.message_timers[msg_id] = timer - dt
        if self.message_timers[msg_id] <= 0 then
            self.message_timers[msg_id] = nil
            self:deliverMessage(msg_id)
        end
    end
end

function Game:queueMessage(msg_id, delay)
    if self.flags["msg_delivered_" .. msg_id] or self.message_timers[msg_id] then
        return
    end
    self.message_timers[msg_id] = delay or 0
end

function Game:deliverMessage(msg_id)
    if self.flags["msg_delivered_" .. msg_id] then return false end
    local msg = data.messages[msg_id]
    if not msg then return false end
    self.flags["msg_delivered_" .. msg_id] = true
    table.insert(self.inbox, {id = msg_id, message = msg, read = false})
    self.unread_count = self.unread_count + 1
    self:updateDerivedState()
    return true
end

function Game:markMessageRead(index)
    if self.inbox[index] and not self.inbox[index].read then
        self.inbox[index].read = true
        self.unread_count = math.max(0, self.unread_count - 1)
    end
end

function Game:getUnreadCount()
    return self.unread_count
end

function Game:addMetric(name, amount)
    local current = self[name] or 0
    self[name] = math.max(0, current + amount)
end

function Game:applyEffects(effects)
    effects = effects or {}

    if effects.flags then
        for _, flag in ipairs(effects.flags) do
            self.flags[flag] = true
        end
    end

    if effects.metrics then
        for key, amount in pairs(effects.metrics) do
            self:addMetric(key, amount)
        end
    end

    if effects.queue_messages then
        for _, entry in ipairs(effects.queue_messages) do
            if type(entry) == "table" then
                self:queueMessage(entry[1], entry[2] or 0)
            else
                self:queueMessage(entry, 0)
            end
        end
    end
end

function Game:onRecordRead(record_id)
    if self.records_read[record_id] then return end
    self.records_read[record_id] = true
    local record = data.records[record_id]
    self.proof_score = self.proof_score + ((record and record.proof) or 1)
    self:checkTriggers(record_id)
end

function Game:onPersonnelViewed(person_id)
    if self.personnel_viewed[person_id] then return end
    self.personnel_viewed[person_id] = true
    self.proof_score = self.proof_score + 0.5
    self:checkTriggers(person_id)
end

function Game:onSearchPerformed(keyword)
    local normalized = (keyword or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
    if normalized == "" then return end
    if self.searches_performed[normalized] then return end
    self.searches_performed[normalized] = true
    self.proof_score = self.proof_score + 0.25
    self:checkTriggers("search:" .. normalized)
end

function Game:onComparisonMade(id1, id2)
    local key = id1 < id2 and (id1 .. "+" .. id2) or (id2 .. "+" .. id1)
    if self.comparisons_made[key] then return end
    self.comparisons_made[key] = true
    self.proof_score = self.proof_score + 1.5
    self:checkTriggers("compare:" .. key)
end

function Game:updateDerivedState()
    local alerts = 1
    if self.records_read["INC-7290"] or self.flags["msg_delivered_MSG-005"] then alerts = alerts + 1 end
    if self.records_read["INC-7288"] or self.flags["mirror_rebuilt"] then alerts = alerts + 1 end
    if self.flags["annex_vault_unlocked"] or self.records_read["DIR-8890"] then alerts = alerts + 1 end
    if self.flags["doctrine_unlocked"] then alerts = alerts + 1 end
    if self.records_read["INC-7322"] or self.flags["dawn_vault_unlocked"] then alerts = alerts + 1 end
    if self.decisions_unlocked then alerts = alerts + 1 end
    if self.records_read["INC-7295"] or self.records_read["INC-7300"] then alerts = alerts + 1 end
    if self.records_read["INC-6410"] then alerts = alerts + 1 end
    if self.flags["msg_delivered_MSG-015"] then alerts = alerts + 1 end
    if self.flags["construction_lead"] then alerts = alerts + 1 end
    if self.flags["ash_contact"] then alerts = alerts + 1 end
    if self.records_read["WIT-MIRA-001"] then alerts = alerts + 1 end
    self.alert_count = alerts

    if self.phase == "main" then
        if self.decisions_unlocked then
            self.chapter = 5
        elseif self.flags["dawn_vault_unlocked"] or self.flags["surface_cache_decoded"] then
            self.chapter = 4
        elseif self.flags["annex_vault_unlocked"] or self.flags["camera_looped"] then
            self.chapter = 3
        elseif self.flags["msg_delivered_MSG-003"] or self.flags["mirror_rebuilt"] then
            self.chapter = 2
        else
            self.chapter = 1
        end
    end
end

function Game:checkTriggers(_context)
    if self.records_read["INC-7301"] and not self.flags["msg_delivered_MSG-002"] then
        self:queueMessage("MSG-002", 3.0)
    end

    local early_evidence = 0
    if self.records_read["INC-7288"] then early_evidence = early_evidence + 1 end
    if self.records_read["MLOG-WTR-4408"] then early_evidence = early_evidence + 1 end
    if self.records_read["MLOG-MED-1220"] then early_evidence = early_evidence + 1 end
    if self.records_read["MLOG-AIR-4412"] then early_evidence = early_evidence + 1 end
    if self.records_read["WIT-308-A"] then early_evidence = early_evidence + 1 end
    if early_evidence >= 3 and not self.flags["msg_delivered_MSG-003"] then
        self:queueMessage("MSG-003", 6.0)
    end

    if self.records_read["MLOG-ARC-0902"] and not self.flags["msg_delivered_MSG-004"] then
        self:queueMessage("MSG-004", 5.0)
    end

    if self.records_read["INC-7290"] and self.records_read["MLOG-MED-1220"] and not self.flags["msg_delivered_MSG-005"] then
        self:queueMessage("MSG-005", 5.0)
    end

    if self.flags["annex_vault_unlocked"]
        and (self.records_read["DIR-4012"] or self.records_read["INC-7288"] or self.records_read["WIT-214-A"])
        and not self.flags["msg_delivered_MSG-006"] then
        self:queueMessage("MSG-006", 5.0)
    end

    if self.records_read["DIR-8890"] and not self.flags["msg_delivered_MSG-007"] then
        self:queueMessage("MSG-007", 4.0)
    end

    if self.flags["doctrine_unlocked"]
        and (self.records_read["DIR-9104"] or self.records_read["DIR-9991"])
        and not self.flags["msg_delivered_MSG-009"] then
        self:queueMessage("MSG-009", 5.0)
    end

    if self.flags["dawn_prompt"]
        and (self.records_read["INC-7322"] or self.records_read["MLOG-EXT-4401"])
        and not self.flags["msg_delivered_MSG-012"] then
        self:queueMessage("MSG-012", 4.0)
    end

    -- Audit risk warning when access pattern gets heavy
    if self.audit_risk >= 3 and not self.flags["msg_delivered_MSG-014"] then
        self:queueMessage("MSG-014", 8.0)
    end

    -- Drenn warning after reading security-related annex records
    local security_reads = 0
    if self.records_read["MLOG-SEC-4420"] then security_reads = security_reads + 1 end
    if self.records_read["MLOG-SEC-6001"] then security_reads = security_reads + 1 end
    if self.records_read["INC-7310"] then security_reads = security_reads + 1 end
    if security_reads >= 2 and not self.flags["msg_delivered_MSG-015"] then
        self:queueMessage("MSG-015", 7.0)
    end

    -- Previous operator warning after reading 10+ records
    if count_true(self.records_read) >= 10 and not self.flags["msg_delivered_MSG-016"] then
        self:queueMessage("MSG-016", 12.0)
    end

    -- Naima personal message after manifold override
    if self.actions_taken["ACT-101"] and not self.flags["msg_delivered_MSG-017"] then
        self:queueMessage("MSG-017", 10.0)
    end

    -- Vey direct threat after doctrine is unlocked
    if self.flags["doctrine_unlocked"]
        and self.records_read["DIR-9104"]
        and not self.flags["msg_delivered_MSG-019"] then
        self:queueMessage("MSG-019", 8.0)
    end

    -- Jonas construction discovery after reading both WIT-099-A and DIR-1010
    if self.records_read["WIT-099-A"] and self.records_read["DIR-1010"]
        and not self.flags["msg_delivered_MSG-020"] then
        self:queueMessage("MSG-020", 6.0)
    end

    -- Naima reveals she knows Mira after you read detainee manifest
    if self.records_read["MLOG-ANN-0025"] and not self.flags["msg_delivered_MSG-021"] then
        self:queueMessage("MSG-021", 5.0)
    end

    -- Jonas personality message after early evidence phase
    if self.flags["msg_delivered_MSG-003"]
        and count_true(self.records_read) >= 6
        and not self.flags["msg_delivered_MSG-022"] then
        self:queueMessage("MSG-022", 8.0)
    end

    -- Sera ethics journal after reading INC-6410 + WIT-084-A
    if self.records_read["INC-6410"] and self.records_read["WIT-084-A"]
        and not self.flags["msg_delivered_MSG-023"] then
        self:queueMessage("MSG-023", 6.0)
    end

    -- Commander Ash direct threat after audit risk + security reads
    if self.audit_risk >= 2 and security_reads >= 2
        and not self.flags["msg_delivered_MSG-024"] then
        self:queueMessage("MSG-024", 10.0)
    end

    -- Elsa Kell message from inside after annex vault + classroom records
    if self.flags["annex_vault_unlocked"]
        and (self.records_read["MLOG-ANN-0012"] or self.records_read["WIT-KELL-001"])
        and not self.flags["msg_delivered_MSG-025"] then
        self:queueMessage("MSG-025", 7.0)
    end

    -- System personnel flag after Commander Ash contact
    if self.flags["ash_contact"] and not self.flags["msg_delivered_MSG-026"] then
        self:queueMessage("MSG-026", 4.0)
    end

    -- Jonas going dark after doctrine unlocked + many records
    if self.flags["doctrine_unlocked"]
        and count_true(self.records_read) >= 25
        and not self.flags["msg_delivered_MSG-027"] then
        self:queueMessage("MSG-027", 8.0)
    end

    -- Sera connects your assignment to Drenn after reading assignment order
    if self.records_read["DIR-ASSIGN-0031"] and not self.flags["msg_delivered_MSG-028"] then
        self:queueMessage("MSG-028", 5.0)
    end

    -- Naima final message — late game, after most evidence
    if self.flags["naima_knows_mira"]
        and self.flags["dawn_vault_unlocked"]
        and count_true(self.records_read) >= 35
        and not self.flags["msg_delivered_MSG-029"] then
        self:queueMessage("MSG-029", 6.0)
    end

    self.decisions_unlocked = compute_decisions_unlocked(self)

    -- Mira's message — after decisions unlocked, the last thing before you choose
    if self.decisions_unlocked
        and self.records_read["WIT-MIRA-001"]
        and not self.flags["msg_delivered_MSG-030"] then
        self:queueMessage("MSG-030", 3.0)
    end

    self:updateDerivedState()
end

function Game:canAccessRecord(record_id)
    local record = data.records[record_id]
    if not record then return false end
    if record.requires_flag then
        return has_all_flags(self.flags, record.requires_flag)
    end
    if record.access_level and record.access_level >= 4 then
        return false
    end
    return true
end

function Game:hasRequirements(requirements)
    if not requirements then return true end

    if requirements.flags and not has_all_flags(self.flags, requirements.flags) then
        return false
    end

    if requirements.records then
        for _, record_id in ipairs(requirements.records) do
            if not self.records_read[record_id] then
                return false
            end
        end
    end

    if requirements.actions then
        for _, action_id in ipairs(requirements.actions) do
            if not self.actions_taken[action_id] then
                return false
            end
        end
    end

    if requirements.decisions_unlocked and not self.decisions_unlocked then
        return false
    end

    if requirements.min_proof and self.proof_score < requirements.min_proof then
        return false
    end

    if requirements.min_mercy and self.mercy < requirements.min_mercy then
        return false
    end

    if requirements.min_complicity and self.complicity < requirements.min_complicity then
        return false
    end

    return true
end

function Game:isActionAvailable(action_id)
    local action = data.actions[action_id]
    if not action then return false end
    if self.actions_taken[action_id] and not action.repeatable then
        return false
    end
    return self:hasRequirements(action.requirements)
end

function Game:getAvailableActions()
    local actions = {}
    for id, action in pairs(data.actions) do
        if self:isActionAvailable(id) then
            table.insert(actions, {id = id, action = action})
        end
    end
    table.sort(actions, function(a, b) return a.id < b.id end)
    return actions
end

function Game:executeAction(action_id)
    local action = data.actions[action_id]
    if not action or not self:isActionAvailable(action_id) then
        return nil
    end

    self.actions_taken[action_id] = true
    self:applyEffects(action.effects)

    if action.ending then
        self.ending = action.ending
        self.phase = "ending"
    end

    self:checkTriggers("action:" .. action_id)

    return {
        ending = action.ending,
        notes = action.result or {},
    }
end

function Game:unlockOverride(code)
    local normalized = normalize_code(code)
    local entry = data.overrides[normalized]
    if not entry then
        return {ok = false, message = "Unknown override token."}
    end

    if entry.requires_flag and not self.flags[entry.requires_flag] then
        return {ok = false, message = "This terminal rejects that token at the current depth."}
    end

    if self.flags[entry.flag] then
        return {ok = true, already = true, entry = entry}
    end

    self.flags[entry.flag] = true
    self:applyEffects({
        metrics = entry.metrics,
        queue_messages = entry.queue_messages,
    })
    self:checkTriggers("override:" .. normalized)

    return {ok = true, entry = entry}
end

function Game:getObjectives()
    local function L(k) return locale.t(k) end
    if self.decisions_unlocked then
        return {
            L("obj_read_all_vault"),
            L("obj_choose_ending"),
            L("obj_unlock_decision"),
        }
    end

    if self.flags["dawn_vault_unlocked"] or self.flags["surface_cache_decoded"] then
        return {
            L("obj_read_all_vault"),
            L("obj_check_inbox"),
            L("obj_deeper_vault"),
        }
    end

    if self.flags["doctrine_unlocked"] then
        return {
            L("obj_read_all_vault"),
            L("obj_check_personnel"),
            L("obj_deeper_vault"),
        }
    end

    if self.flags["dawn_prompt"] then
        return {
            L("obj_find_overrides"),
            L("obj_deeper_vault"),
            L("obj_trace_systems"),
        }
    end

    if self.flags["annex_vault_unlocked"] then
        return {
            L("obj_read_all_vault"),
            L("obj_compare_records"),
            L("obj_check_personnel"),
        }
    end

    if self.flags["mirror_rebuilt"] then
        return {
            L("obj_find_overrides"),
            L("obj_read_all_vault"),
            L("obj_check_inbox"),
        }
    end

    if self.flags["msg_delivered_MSG-003"] then
        return {
            L("obj_compare_records"),
            L("obj_trace_systems"),
            L("obj_check_personnel"),
        }
    end

    return {
        L("obj_review_anomaly"),
        L("obj_search_records"),
        L("obj_check_inbox"),
    }
end

function Game:hasNewMessages()
    return self.unread_count > 0
end

function Game:getStats()
    return {
        proof = math.floor(self.proof_score),
        risk = self.audit_risk,
        strain = self.strain,
        mercy = self.mercy,
        complicity = self.complicity,
        records = count_true(self.records_read),
    }
end

function Game:serialize()
    local inbox = {}
    for i, entry in ipairs(self.inbox) do
        inbox[i] = {
            id = entry.id,
            read = entry.read == true,
        }
    end

    return {
        phase = self.phase,
        flags = copy_map(self.flags),
        inbox = inbox,
        records_read = copy_map(self.records_read),
        personnel_viewed = copy_map(self.personnel_viewed),
        searches_performed = copy_map(self.searches_performed),
        comparisons_made = copy_map(self.comparisons_made),
        actions_taken = copy_map(self.actions_taken),
        game_time = self.game_time,
        ending = self.ending,
        message_timers = copy_map(self.message_timers),
        proof_score = self.proof_score,
        audit_risk = self.audit_risk,
        strain = self.strain,
        mercy = self.mercy,
        complicity = self.complicity,
        chapter = self.chapter,
        decisions_unlocked = self.decisions_unlocked,
    }
end

return Game
