package.path = "./?.lua;./lib/?.lua;./lib/?/init.lua;" .. package.path

local Game = require("game")
local commands = require("commands")
local Save = require("save")
local RUNTIME_SLOT = "__ashline_test_" .. ((jit and "luajit") or ((_VERSION or "lua"):gsub("%W+", "_"):lower()))

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
        "READ INC-7322",
        "READ MLOG-EXT-4401",
        "READ INC-7295",
        "READ INC-7300",
        "READ INC-7310",
        "READ MLOG-PWR-4410",
        "READ MLOG-FOOD-4415",
        "READ MLOG-SEC-4420",
        "READ WIT-555-A",
        "READ INC-6200",
        "READ MLOG-SEC-6001",
        "READ WIT-099-A",
        "READ DIR-1010",
        "READ INC-5820",
        "SEARCH lantern",
        "SEARCH lantern",
        "PERSONNEL CIV-0119",
        "PERSONNEL CIV-0177",
        "PERSONNEL CIV-0412",
        "PERSONNEL CIV-0099",
        "PERSONNEL CIV-0333",
        "PERSONNEL CIV-0007",
        "PERSONNEL CIV-0027",
        "COMPARE INC-7295 MLOG-PWR-4410",
        "COMPARE WIT-099-A DIR-1010",
        "COMPARE MLOG-SEC-4420 MLOG-SEC-6001",
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
    exec(game, "READ MLOG-ANN-0012")
    exec(game, "READ MLOG-ANN-0018")
    exec(game, "READ WIT-308-B")
    exec(game, "READ DIR-5050")
    exec(game, "READ INC-6410")
    exec(game, "READ WIT-VEY-001")
    exec(game, "COMPARE INC-6402 DIR-8890")
    exec(game, "COMPARE DIR-4980 WIT-084-A")
    exec(game, "COMPARE WIT-621-A DIR-8890")
    exec(game, "COMPARE MLOG-ANN-0012 MLOG-ANN-0018")
    exec(game, "COMPARE INC-6410 WIT-084-A")

    flush_messages(game, 10)
    read_all_messages(game)

    exec(game, "AUTHORIZE ACT-104")
    exec(game, "AUTHORIZE ACT-105")
    exec(game, "AUTHORIZE ACT-109")

    flush_messages(game, 10)
    read_all_messages(game)

    exec(game, "OVERRIDE ASHLINE-NULL")
    exec(game, "READ DIR-9104")
    exec(game, "READ DIR-9991")
    exec(game, "READ INC-7316")
    exec(game, "READ MLOG-SRF-2003")
    exec(game, "READ DIR-9200")
    exec(game, "READ WIT-VEY-002")
    exec(game, "COMPARE WIT-VEY-001 WIT-VEY-002")
    exec(game, "COMPARE DIR-9200 DIR-8700")

    flush_messages(game, 10)
    read_all_messages(game)
    flush_messages(game, 10)
    read_all_messages(game)

    exec(game, "TRACE EXTERNAL")
    exec(game, "INSPECT EXTERNAL")
    exec(game, "COMPARE INC-7322 MLOG-EXT-4401")
    exec(game, "AUTHORIZE ACT-106")
    exec(game, "AUTHORIZE ACT-107")

    flush_messages(game, 10)
    read_all_messages(game)

    exec(game, "OVERRIDE DAWN-GATE")
    exec(game, "READ INC-6117")
    exec(game, "READ DIR-8700")
    exec(game, "READ DIR-9408")
    exec(game, "READ WIT-412-A")
    exec(game, "READ WIT-940-A")
    exec(game, "READ MLOG-EXT-4405")
    exec(game, "READ INC-6120")
    exec(game, "PERSONNEL CIV-0515")
    exec(game, "COMPARE INC-6117 DIR-8700")
    exec(game, "COMPARE DIR-9408 WIT-940-A")
    exec(game, "COMPARE INC-6117 WIT-412-A")
    exec(game, "COMPARE MLOG-EXT-4405 INC-6117")
    exec(game, "COMPARE INC-6120 DIR-8700")
    exec(game, "AUTHORIZE ACT-108")
    exec(game, "READ INC-7336")
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

local function verify_save_roundtrip()
    local slot = RUNTIME_SLOT
    Save.delete(slot)

    local game = build_final_state(true)
    local payload = {
        saved_at = "test",
        app = {
            input_text = "READ INC-7301",
            input_cursor = 13,
            command_history = {"HELP", "READ INC-7301"},
            history_index = 3,
        },
        game = game:serialize(),
    }

    local ok, err = Save.save(slot, payload)
    assert_true(ok, "save should succeed: " .. tostring(err))

    local loaded, source = Save.load(slot)
    assert_true(source == "current" or source == "backup", "expected valid save source")
    assert_true(loaded.game.phase == payload.game.phase, "loaded save should preserve phase")
    assert_true(loaded.game.flags.doctrine_unlocked == true, "loaded save should preserve flags")

    local backup_ok, backup_err = Save.save(slot, payload)
    assert_true(backup_ok, "second save should succeed: " .. tostring(backup_err))

    local current_path = slot .. ".save.json"
    local file = io.open(current_path, "wb")
    assert_true(file ~= nil, "should be able to corrupt current save")
    file:write("{corrupt")
    file:close()

    local recovered, recovered_source = Save.load(slot)
    assert_true(recovered ~= nil, "backup recovery should succeed")
    assert_true(recovered_source == "backup", "expected backup recovery source")
    assert_true(recovered.game.flags.dawn_vault_unlocked == true, "backup should preserve deep progress")

    Save.delete(slot)
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
    verify_save_roundtrip()

    print("headless smoke: ok")
end

run()
