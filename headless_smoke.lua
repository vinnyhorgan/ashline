package.path = "./?.lua;" .. package.path

local Game = require("game")
local commands = require("commands")

local function assert_true(value, message)
    if not value then
        error(message or "assertion failed", 2)
    end
end

local function exec(game, command)
    local result = commands.execute(game, command)
    assert_true(result ~= nil, "command returned nil: " .. command)
    return result
end

local function flush_messages(game, cycles)
    for _ = 1, (cycles or 12) do
        if not next(game.message_timers) then
            break
        end
        game:update(10)
    end
end

local function read_all_messages(game)
    local total = #game.inbox
    for i = 1, total do
        exec(game, "READ MSG " .. i)
    end
end

local function build_final_state(include_meds)
    local game = Game.new()
    game:start()
    flush_messages(game, 4)

    local early_commands = {
        "HELP",
        "TASKS",
        "STATUS",
        "ALERTS",
        "LIST ALL",
        "READ INC-7301",
        "TRACE WATER",
        "READ MLOG-WTR-4408",
        "READ INC-7288",
        "READ MLOG-ARC-0902",
        "COMPARE INC-7288 MLOG-ARC-0902",
        "READ INC-7290",
        "READ MLOG-MED-1220",
        "READ INC-7021",
        "READ MLOG-AIR-4412",
        "SEARCH lantern",
        "SEARCH lantern",
        "PERSONNEL CIV-0119",
        "PERSONNEL CIV-0177",
    }

    for _, command in ipairs(early_commands) do
        exec(game, command)
    end

    local proof_after_first_search = game.proof_score
    exec(game, "SEARCH lantern")
    assert_true(game.proof_score == proof_after_first_search, "repeated search should not farm proof")

    flush_messages(game, 20)
    read_all_messages(game)

    exec(game, "AUTHORIZE ACT-101")
    if include_meds then
        exec(game, "AUTHORIZE ACT-102")
    end
    exec(game, "AUTHORIZE ACT-103")
    exec(game, "OVERRIDE LANTERN-17")
    exec(game, "READ INC-6402")
    exec(game, "READ MLOG-ANN-0007")
    exec(game, "READ DIR-4980")
    exec(game, "READ DIR-8890")
    exec(game, "READ WIT-084-A")
    exec(game, "READ WIT-308-A")
    exec(game, "READ WIT-621-A")
    exec(game, "READ DIR-4012")
    exec(game, "READ WIT-214-A")
    exec(game, "COMPARE INC-6402 DIR-8890")
    exec(game, "COMPARE DIR-4980 WIT-084-A")
    exec(game, "COMPARE WIT-621-A DIR-8890")

    flush_messages(game, 10)
    read_all_messages(game)

    exec(game, "AUTHORIZE ACT-104")
    exec(game, "AUTHORIZE ACT-105")

    flush_messages(game, 10)
    read_all_messages(game)

    exec(game, "OVERRIDE ASHLINE-NULL")
    exec(game, "READ DIR-9104")
    exec(game, "READ DIR-9991")
    exec(game, "READ INC-7316")
    exec(game, "ACTIONS")

    assert_true(game.decisions_unlocked, "final decisions should be unlocked")
    return game
end

local function verify_ending(action_id, expected_ending, include_meds)
    local game = build_final_state(include_meds)
    exec(game, "AUTHORIZE " .. action_id)
    assert_true(game.phase == "ending", "game should enter ending phase for " .. action_id)
    assert_true(game.ending == expected_ending, "expected " .. expected_ending .. " but got " .. tostring(game.ending))
    return true
end

local function run()
    local game = Game.new()
    game:start()
    flush_messages(game, 4)
    assert_true(#game.inbox >= 1, "initial message should arrive")
    assert_true(type(exec(game, "READ INC-6402")) == "table", "locked read should still return output")
    local denied = exec(game, "OVERRIDE LANTERN-17")
    assert_true(type(denied) == "table", "override denial should return output")

    verify_ending("ACT-201", "quiet_burial", false)
    verify_ending("ACT-202", "sustain_lie", true)
    verify_ending("ACT-203", "controlled_disclosure", false)
    verify_ending("ACT-204", "open_broadcast", false)
    verify_ending("ACT-205", "ashline_doctrine", true)

    print("headless smoke: ok")
end

run()
