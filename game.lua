local data = require("data")

local Game = {}
Game.__index = Game

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
    self.dir_9901_unlocked = false
    self.decisions_unlocked = false
    self.ending = nil
    self.pending_messages = {}
    self.message_timers = {}
    self.investigation_score = 0
    return self
end

function Game:start()
    self.phase = "main"
    self:queueMessage("MSG-001", 2.0)
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
    if not self.flags["msg_delivered_" .. msg_id] then
        self.message_timers[msg_id] = delay or 0
    end
end

function Game:deliverMessage(msg_id)
    if self.flags["msg_delivered_" .. msg_id] then return false end
    local msg = data.messages[msg_id]
    if not msg then return false end
    self.flags["msg_delivered_" .. msg_id] = true
    table.insert(self.inbox, {id = msg_id, message = msg, read = false})
    self.unread_count = self.unread_count + 1
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

function Game:onRecordRead(record_id)
    if self.records_read[record_id] then return end
    self.records_read[record_id] = true
    self.investigation_score = self.investigation_score + 1
    self:checkTriggers(record_id)
end

function Game:onPersonnelViewed(person_id)
    if self.personnel_viewed[person_id] then return end
    self.personnel_viewed[person_id] = true
    self.investigation_score = self.investigation_score + 1
    self:checkTriggers(person_id)
end

function Game:onSearchPerformed(keyword)
    table.insert(self.searches_performed, keyword)
    self.investigation_score = self.investigation_score + 0.5
    self:checkTriggers("search:" .. keyword:lower())
end

function Game:onComparisonMade(id1, id2)
    local key = id1 .. "+" .. id2
    if self.comparisons_made[key] then return end
    self.comparisons_made[key] = true
    self.investigation_score = self.investigation_score + 2
    self:checkTriggers("compare:" .. key)
end

function Game:checkTriggers(context)
    -- Trigger MSG-002 after reading INC-2047
    if self.records_read["INC-2047"] and not self.flags["msg_delivered_MSG-002"] then
        self:queueMessage("MSG-002", 5.0)
    end

    -- Trigger MSG-003 (Elena's first message) after deep investigation
    if not self.flags["msg_delivered_MSG-003"] then
        local deep = 0
        if self.records_read["INC-2047"] then deep = deep + 1 end
        if self.records_read["INC-2031"] then deep = deep + 1 end
        if self.records_read["MLOG-WTR-1201"] then deep = deep + 1 end
        if self.records_read["WIT-031-A"] or self.personnel_viewed["CIV-0112"] then deep = deep + 1 end
        if self.records_read["INC-1987"] or self.records_read["WIT-088-A"] then deep = deep + 1 end
        if deep >= 4 then
            self:queueMessage("MSG-003", 8.0)
        end
    end

    -- Trigger MSG-004 (Hale's warning) after deeper investigation
    if not self.flags["msg_delivered_MSG-004"] then
        if self.flags["msg_delivered_MSG-003"] and self.investigation_score >= 8 then
            self:queueMessage("MSG-004", 12.0)
        end
    end

    -- Trigger MSG-005 (Elena's urgent message) after critical mass
    if not self.flags["msg_delivered_MSG-005"] then
        local critical = 0
        if self.records_read["WIT-088-A"] then critical = critical + 1 end
        if self.records_read["WIT-156-A"] then critical = critical + 1 end
        if self.records_read["WIT-201-A"] then critical = critical + 1 end
        if self.records_read["INC-1987"] then critical = critical + 1 end
        if self.records_read["INC-2033"] then critical = critical + 1 end
        if self.records_read["MLOG-S9-0847"] then critical = critical + 1 end
        if critical >= 3 and self.flags["msg_delivered_MSG-003"] then
            self:queueMessage("MSG-005", 6.0)
            self.decisions_unlocked = true
        end
    end

    -- Unlock DIR-9901 after MSG-005
    if self.flags["msg_delivered_MSG-005"] then
        self.dir_9901_unlocked = true
    end

    -- Trigger MSG-006 after reading DIR-9901
    if self.records_read["DIR-9901"] and not self.flags["msg_delivered_MSG-006"] then
        self:queueMessage("MSG-006", 4.0)
    end
end

function Game:canAccessRecord(record_id)
    local record = data.records[record_id]
    if not record then return false end
    if record.access_level and record.access_level >= 4 then
        return self.dir_9901_unlocked
    end
    return true
end

function Game:isActionAvailable(action_id)
    local action = data.actions[action_id]
    if not action then return false end
    if action.available_trigger == "read_inc_2047" then
        return self.records_read["INC-2047"] ~= nil
    elseif action.available_trigger == "decisions_unlocked" then
        return self.decisions_unlocked
    end
    return false
end

function Game:executeAction(action_id)
    local action = data.actions[action_id]
    if not action then return nil end
    if not self:isActionAvailable(action_id) then return nil end
    self.actions_taken[action_id] = true
    self.ending = action.ending
    self.phase = "ending"
    return action.ending
end

function Game:hasNewMessages()
    return self.unread_count > 0
end

return Game
