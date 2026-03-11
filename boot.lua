local colors = require("colors")

local boot = {}

function boot.getSequence()
    return {
        {delay = 0.3, segments = {{text = "MERIDIAN SYSTEMS CORP. EMBEDDED BIOS v2.14", color = colors.dim}}},
        {delay = 0.15, segments = {{text = "Hardware check.........", color = colors.dim}}},
        {delay = 0.12, segments = {{text = "  CPU:       MRC-4400 Series    [OK]", color = colors.dim}}},
        {delay = 0.08, segments = {{text = "  Memory:    4096K Conventional  [OK]", color = colors.dim}}},
        {delay = 0.08, segments = {{text = "  Storage:   MSC-HD 240MB       [OK]", color = colors.dim}}},
        {delay = 0.08, segments = {{text = "  Terminal:  ARC-7 Interface     [OK]", color = colors.dim}}},
        {delay = 0.08, segments = {{text = "  Network:   SILO-NET Node 31   [OK]", color = colors.dim}}},
        {delay = 0.15, segments = {}},
        {delay = 0.3, segments = {{text = "Loading ASHLINE OS v4.7.1...", color = colors.text}}},
        {delay = 0.1, segments = {{text = "  Kernel modules.............. loaded", color = colors.dim}}},
        {delay = 0.08, segments = {{text = "  Terminal driver.............. loaded", color = colors.dim}}},
        {delay = 0.08, segments = {{text = "  Security subsystem.......... loaded", color = colors.dim}}},
        {delay = 0.08, segments = {{text = "  Communications layer........ loaded", color = colors.dim}}},
        {delay = 0.08, segments = {{text = "  Records interface........... loaded", color = colors.dim}}},
        {delay = 0.08, segments = {{text = "  Monitoring subsystem........ loaded", color = colors.dim}}},
        {delay = 0.15, segments = {}},
        {delay = 0.15, segments = {{text = "Connecting to SILO-NET...", color = colors.text}}},
        {delay = 0.2, segments = {{text = "  Node 31 authenticated.  Encryption: AES-MERIDIAN", color = colors.dim}}},
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
            {text = "  Operator:    ", color = colors.dim},
            {text = "CIV-0031 (OPERATOR 31)", color = colors.text},
        }},
        {delay = 0.08, segments = {
            {text = "  Clearance:   ", color = colors.dim},
            {text = "LEVEL 2", color = colors.text},
        }},
        {delay = 0.08, segments = {
            {text = "  Shift:       ", color = colors.dim},
            {text = "3 (2200-0600)", color = colors.text},
        }},
        {delay = 0.08, segments = {
            {text = "  Terminal:    ", color = colors.dim},
            {text = "ARC-7", color = colors.text},
        }},
        {delay = 0.15, segments = {}},
        {delay = 0.1, segments = {
            {text = "  Active alerts:  ", color = colors.dim},
            {text = "1", color = colors.amber},
        }},
        {delay = 0.1, segments = {
            {text = "  Pending inbox:  ", color = colors.dim},
            {text = "1", color = colors.cyan},
        }},
        {delay = 0.2, segments = {}},
        {delay = 0.05, segments = {{text = "  Session initialized. Type HELP for available commands.", color = colors.text}}},
        {delay = 0.05, segments = {}},
        {delay = 0.0, segments = {{text = "============================================================", color = colors.border}}},
    }
end

return boot
