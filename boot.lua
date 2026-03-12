local colors = require("colors")
local locale = require("locale")

local boot = {}

function boot.getSequence()
    local L = function(k) return locale.t(k) end
    return {
        {delay = 0.3, segments = {{text = "MERIDIAN SYSTEMS CORP. EMBEDDED BIOS v2.14", color = colors.dim}}},
        {delay = 0.15, segments = {{text = L("boot_hw_check"), color = colors.dim}}},
        {delay = 0.12, segments = {{text = "  CPU:       MRC-4400 Series     [OK]", color = colors.dim}}},
        {delay = 0.08, segments = {{text = "  Memory:    4096K Conventional  [OK]", color = colors.dim}}},
        {delay = 0.08, segments = {{text = "  Storage:   MSC-HD 240MB        [OK]", color = colors.dim}}},
        {delay = 0.08, segments = {{text = "  Terminal:  ARC-7 Interface     [OK]", color = colors.dim}}},
        {delay = 0.08, segments = {{text = "  Network:   SILO-NET Node 31    [OK]", color = colors.dim}}},
        {delay = 0.15, segments = {}},
        {delay = 0.3, segments = {{text = L("boot_loading"), color = colors.text}}},
        {delay = 0.1, segments = {{text = L("boot_kernel"), color = colors.dim}}},
        {delay = 0.08, segments = {{text = L("boot_terminal"), color = colors.dim}}},
        {delay = 0.08, segments = {{text = L("boot_security"), color = colors.dim}}},
        {delay = 0.08, segments = {{text = L("boot_comms"), color = colors.dim}}},
        {delay = 0.08, segments = {{text = L("boot_records"), color = colors.dim}}},
        {delay = 0.08, segments = {{text = L("boot_monitoring"), color = colors.dim}}},
        {delay = 0.15, segments = {}},
        {delay = 0.15, segments = {{text = L("boot_connecting"), color = colors.text}}},
        {delay = 0.2, segments = {{text = L("boot_node_auth"), color = colors.dim}}},
        {delay = 0.1, segments = {}},
        {delay = 0.2, segments = {{text = "+============================================================+", color = colors.border}}},
        {delay = 0.05, segments = {{text = "|                                                            |", color = colors.border}}},
        {delay = 0.05, segments = {
            {text = "|    ", color = colors.border},
            {text = "A S H L I N E", color = colors.bright},
            {text = "   Terminal Operating System               ", color = colors.border},
            {text = "|", color = colors.border},
        }},
        {delay = 0.05, segments = {
            {text = "|    ", color = colors.border},
            {text = "Silo Meridian  |  Terminal ARC-7  |  2071.03.14", color = colors.text},
            {text = "         |", color = colors.border},
        }},
        {delay = 0.05, segments = {{text = "|                                                            |", color = colors.border}}},
        {delay = 0.05, segments = {{text = "+============================================================+", color = colors.border}}},
        {delay = 0.2, segments = {}},
        {delay = 0.1, segments = {
            {text = L("boot_operator"), color = colors.dim},
            {text = "CIV-0031 (OPERATOR 31)", color = colors.text},
        }},
        {delay = 0.08, segments = {
            {text = L("boot_clearance"), color = colors.dim},
            {text = "LEVEL 2", color = colors.text},
        }},
        {delay = 0.08, segments = {
            {text = L("boot_shift"), color = colors.dim},
            {text = "3 (2200-0600)", color = colors.text},
        }},
        {delay = 0.08, segments = {
            {text = L("boot_terminal_label"), color = colors.dim},
            {text = "ARC-7", color = colors.text},
        }},
        {delay = 0.15, segments = {}},
        {delay = 0.1, segments = {
            {text = L("boot_alerts"), color = colors.dim},
            {text = "1", color = colors.amber},
        }},
        {delay = 0.1, segments = {
            {text = L("boot_inbox"), color = colors.dim},
            {text = "1", color = colors.cyan},
        }},
        {delay = 0.2, segments = {}},
        {delay = 0.05, segments = {{text = L("boot_init"), color = colors.text}}},
        {delay = 0.05, segments = {}},
        {delay = 0.0, segments = {{text = "============================================================", color = colors.border}}},
    }
end

return boot
