package.path = "./?.lua;./lib/?.lua;./lib/?/init.lua;" .. package.path

local locale = require("locale")
local Game = require("game")
local commands = require("commands")
local Save = require("save")
local boot = require("boot")
local data_it = require("data_it")
local utf8_utils = require("utf8_utils")
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
        "READ MLOG-SHIFT-7140",
        "READ INC-MOR-2071",
        "READ MLOG-CAF-3001",
        "READ WIT-ANON-001",
        "READ INC-MAINT-0088",
        "READ MLOG-POP-2071",
        "READ INC-ARC-7340",
        "READ MLOG-PER-0031",
        "SEARCH lantern",
        "SEARCH lantern",
        "PERSONNEL CIV-0119",
        "PERSONNEL CIV-0177",
        "PERSONNEL CIV-0412",
        "PERSONNEL CIV-0099",
        "PERSONNEL CIV-0333",
        "PERSONNEL CIV-0007",
        "PERSONNEL CIV-0027",
        "PERSONNEL CIV-0031",
        "PERSONNEL CIV-0455",
        "COMPARE INC-7295 MLOG-PWR-4410",
        "COMPARE WIT-099-A DIR-1010",
        "COMPARE MLOG-SEC-4420 MLOG-SEC-6001",
        "COMPARE INC-MOR-2071 DIR-4980",
        "COMPARE WIT-ANON-001 MLOG-SHIFT-7140",
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
    exec(game, "READ MLOG-ANN-0025")
    exec(game, "READ MLOG-SEC-0031")
    exec(game, "READ WIT-KELL-001")
    exec(game, "COMPARE INC-6402 DIR-8890")
    exec(game, "COMPARE DIR-4980 WIT-084-A")
    exec(game, "COMPARE WIT-621-A DIR-8890")
    exec(game, "COMPARE MLOG-ANN-0012 MLOG-ANN-0018")
    exec(game, "COMPARE INC-6410 WIT-084-A")
    exec(game, "COMPARE MLOG-PER-0031 MLOG-ANN-0025")
    exec(game, "COMPARE MLOG-PER-0031 MLOG-SEC-0031")

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
    exec(game, "READ DIR-ASSIGN-0031")
    exec(game, "COMPARE WIT-VEY-001 WIT-VEY-002")
    exec(game, "COMPARE DIR-9200 DIR-8700")
    exec(game, "COMPARE MLOG-SEC-0031 DIR-ASSIGN-0031")

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
    exec(game, "READ WIT-MIRA-001")
    exec(game, "PERSONNEL CIV-0515")
    exec(game, "COMPARE INC-6117 DIR-8700")
    exec(game, "COMPARE DIR-9408 WIT-940-A")
    exec(game, "COMPARE INC-6117 WIT-412-A")
    exec(game, "COMPARE MLOG-EXT-4405 INC-6117")
    exec(game, "COMPARE INC-6120 DIR-8700")
    exec(game, "COMPARE WIT-KELL-001 WIT-MIRA-001")
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

local function verify_language_restore_roundtrip()
    local slot = RUNTIME_SLOT .. "_lang"
    Save.delete(slot)

    locale.setLanguage("en")
    local data = require("data")
    data.applyLanguage("en")

    local game = Game.new()
    game:start()
    flush_messages(game, 4)

    local ok, err = Save.save(slot, {
        saved_at = "test",
        app = {},
        game = game:serialize(),
    })
    assert_true(ok, "language restore save should succeed: " .. tostring(err))

    locale.setLanguage("it")
    data.applyLanguage("it")

    local loaded = assert(Save.load(slot))
    local restored = Game.fromSnapshot(loaded.game)
    assert_true(restored.inbox[1] ~= nil, "restored inbox should contain first message")
    assert_true(restored.inbox[1].message.subject == data.messages["MSG-001"].subject, "restored inbox message should follow active language")

    locale.setLanguage("en")
    data.applyLanguage("en")
    Save.delete(slot)
end

local function verify_final_message_trigger()
    local game = Game.new()
    game.phase = "main"

    local flags = {
        "doctrine_unlocked",
        "dawn_vault_unlocked",
        "model_generated",
        "surface_model_generated",
        "surface_cache_decoded",
        "camera_looped",
    }
    for _, flag in ipairs(flags) do
        game.flags[flag] = true
    end

    local records = {
        "DIR-9104",
        "DIR-9991",
        "INC-7316",
        "DIR-8700",
        "DIR-9408",
        "INC-6117",
        "WIT-MIRA-001",
    }
    for _, record_id in ipairs(records) do
        game.records_read[record_id] = true
    end

    game:onRecordRead("INC-7336")
    assert_true(game.decisions_unlocked, "final decisions should unlock on final prerequisite read")
    assert_true(game.message_timers["MSG-030"] ~= nil, "MSG-030 should queue immediately when decisions unlock")
end

local function verify_utf8_layout_regression()
    local subject = data_it.messages["MSG-001"].subject
    assert_true(subject ~= nil, "italian MSG-001 subject should exist")
    assert_true(utf8_utils.len(subject) < #subject, "utf8 len should differ from byte length for italian subject")
end

local function flatten_output(output)
    if type(output) ~= "table" then
        return ""
    end

    local lines = {}
    for _, entry in ipairs(output) do
        if type(entry) == "table" then
            local text = {}
            for _, segment in ipairs(entry) do
                text[#text + 1] = segment.text or ""
            end
            lines[#lines + 1] = table.concat(text)
        end
    end
    return table.concat(lines, "\n")
end

local function verify_italian_release_surface()
    locale.setLanguage("it")
    local data = require("data")
    data.applyLanguage("it")

    local game = Game.new()
    game:start()
    flush_messages(game, 4)

    assert_true(type(exec(game, "AIUTO")) == "table", "AIUTO alias should work")
    assert_true(type(exec(game, "ELENCA DIRETTIVE")) == "table", "ELENCA DIRETTIVE alias should work")
    assert_true(type(exec(game, "TRACCIA superficie")) == "table", "TRACCIA superficie alias should work")
    assert_true(type(exec(game, "ISPEZIONA INC-7301")) == "table", "ISPEZIONA record alias should work")
    assert_true(type(exec(game, "POSTA")) == "table", "POSTA alias should work")

    local inspect_output = exec(game, "ISPEZIONA INC-7301")
    local inspect_text = flatten_output(inspect_output)
    assert_true(inspect_text:find("METADATI DOCUMENTO", 1, true) ~= nil, "italian inspect should show record metadata")

    local personnel_output = exec(game, "PERSONNEL VOSS")
    local personnel_text = flatten_output(personnel_output)
    assert_true(personnel_text:find("Trovate corrispondenze multiple", 1, true) ~= nil, "italian personnel search should localize multi-match heading")

    local boot_sequence = boot.getSequence()
    local boot_text = {}
    for _, entry in ipairs(boot_sequence) do
        for _, segment in ipairs(entry.segments or {}) do
            boot_text[#boot_text + 1] = segment.text or ""
        end
    end
    local boot_joined = table.concat(boot_text, "\n")
    assert_true(boot_joined:find("BIOS INTEGRATO", 1, true) ~= nil, "italian boot should localize BIOS line")
    assert_true(boot_joined:find("Sistema Operativo Terminale", 1, true) ~= nil, "italian boot should localize OS banner")
    for _, entry in ipairs(boot_sequence) do
        local width = 0
        local has_box = false
        for _, segment in ipairs(entry.segments or {}) do
            local text = segment.text or ""
            if text:find("|", 1, true) or text:find("+", 1, true) then
                has_box = true
            end
            width = width + utf8_utils.len(text)
        end
        if has_box then
            assert_true(width == 62, "boot banner lines should keep a fixed ASCII width")
        end
    end

    local status_output = exec(game, "STATUS")
    local status_text = flatten_output(status_output)
    assert_true(status_text:find("ATTENZIONE", 1, true) ~= nil, "italian status should localize system status labels")
    assert_true(status_text:find("CAUTION", 1, true) == nil, "italian status should not leak english system status labels")

    exec(game, "READ INC-7301")
    flush_messages(game, 6)
    local inbox_text = flatten_output(exec(game, "INBOX"))
    assert_true(inbox_text:find("PRIORITA%-1") ~= nil, "italian inbox should localize priority labels")

    local final_game = build_final_state(false)
    local actions_text = flatten_output(exec(final_game, "ACTIONS"))
    assert_true(actions_text:find("%[FINALE%]") ~= nil, "italian actions should localize final action badge")

    locale.setLanguage("en")
    data.applyLanguage("en")
end

local function verify_terminal_command_surface()
    local game = Game.new()
    game:start()
    flush_messages(game, 4)

    assert_true(commands.applyCompletion("h", game) == "HELP", "completion should normalize lowercase input to uppercase")
    assert_true(exec(game, "EXIT") == "EXIT", "EXIT should map to the title-menu signal")
    assert_true(exec(game, "ESCI") == "EXIT", "ESCI alias should map to EXIT")
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
    verify_language_restore_roundtrip()
    verify_final_message_trigger()
    verify_utf8_layout_regression()
    verify_italian_release_surface()
    verify_terminal_command_surface()

    print("headless smoke: ok")
end

run()
