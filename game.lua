local data = require("data")

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
    table.insert(self.searches_performed, keyword)
    self.proof_score = self.proof_score + 0.25
    self:checkTriggers("search:" .. keyword:lower())
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
    if self.decisions_unlocked then alerts = alerts + 1 end
    self.alert_count = alerts

    if self.phase == "main" then
        if self.decisions_unlocked then
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

    self.decisions_unlocked = self.flags["doctrine_unlocked"]
        and self.flags["model_generated"]
        and self.flags["camera_looped"]
        and self.records_read["DIR-9104"]
        and self.records_read["DIR-9991"]
        and self.records_read["INC-7316"]

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
    if self.decisions_unlocked then
        return {
            "Read DIR-9104, DIR-9991, and INC-7316 if you have not already.",
            "Use ACTIONS to review the final authorization set.",
            "Choose what A-17, and the rest of Meridian, are worth to you.",
        }
    end

    if self.flags["doctrine_unlocked"] then
        return {
            "Finish reading the black-vault doctrine and liquidation files.",
            "Run the ration model if you have not authorized ACT-104.",
            "Prepare a live proof channel from A-17 if you have not authorized ACT-105.",
        }
    end

    if self.flags["annex_vault_unlocked"] then
        return {
            "Read the annex suppression records now visible in the branch.",
            "Review DIR-4012 and WIT-214-A, then read MSG-006 when it arrives.",
            "If you need deeper truth, find a way below the annex vault.",
        }
    end

    if self.flags["mirror_rebuilt"] then
        return {
            "Use OVERRIDE LANTERN-17 to restore the annex occupancy branch.",
            "Read any newly exposed annex files immediately.",
            "Expect audit pressure to rise from this point onward.",
        }
    end

    if self.flags["msg_delivered_MSG-003"] then
        return {
            "Decide whether to buy Naima time with ACT-101.",
            "Read MLOG-ARC-0902 and any registry files tied to LANTERN.",
            "Follow med and air anomalies; they all point at occupancy.",
        }
    end

    return {
        "Start with INC-7301 and trace the retired A-17 branch.",
        "Search for annex, nursery, lantern, or checksum drift.",
        "Compare records when timelines or body counts do not align.",
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

return Game
