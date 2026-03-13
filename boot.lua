local colors = require("colors")
local locale = require("locale")
local utf8_utils = require("utf8_utils")

local boot = {}
local INNER_WIDTH = 60

local function fit_text(text, width)
    local value = text or ""
    local len = utf8_utils.len(value)
    if len > width then
        return utf8_utils.sub(value, 1, width)
    end
    if len < width then
        return value .. string.rep(" ", width - len)
    end
    return value
end

local function boxed_line(segments)
    local total = 0
    for _, segment in ipairs(segments) do
        total = total + utf8_utils.len(segment.text or "")
    end
    if total < INNER_WIDTH then
        segments[#segments + 1] = {text = string.rep(" ", INNER_WIDTH - total), color = colors.border}
    end

    local line = {
        {text = "|", color = colors.border},
    }
    for _, segment in ipairs(segments) do
        line[#line + 1] = segment
    end
    line[#line + 1] = {text = "|", color = colors.border}
    return line
end

function boot.getSequence()
    local L = function(k) return locale.t(k) end
    return {
        {delay = 0.3, segments = {{text = L("boot_bios"), color = colors.dim}}},
        {delay = 0.15, segments = {{text = L("boot_hw_check"), color = colors.dim}}},
        {delay = 0.12, segments = {{text = L("boot_cpu"), color = colors.dim}}},
        {delay = 0.08, segments = {{text = L("boot_memory"), color = colors.dim}}},
        {delay = 0.08, segments = {{text = L("boot_storage"), color = colors.dim}}},
        {delay = 0.08, segments = {{text = L("boot_terminal_ok"), color = colors.dim}}},
        {delay = 0.08, segments = {{text = L("boot_network"), color = colors.dim}}},
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
        {delay = 0.05, segments = boxed_line({
            {text = string.rep(" ", INNER_WIDTH), color = colors.border},
        })},
        {delay = 0.05, segments = boxed_line({
            {text = "    ", color = colors.border},
            {text = "A S H L I N E", color = colors.bright},
            {text = "   ", color = colors.border},
            {text = fit_text(L("boot_os_name"), INNER_WIDTH - 7 - utf8_utils.len("A S H L I N E")), color = colors.border},
        })},
        {delay = 0.05, segments = boxed_line({
            {text = "    ", color = colors.border},
            {text = fit_text(L("boot_site_line"), INNER_WIDTH - 4), color = colors.text},
        })},
        {delay = 0.05, segments = boxed_line({
            {text = string.rep(" ", INNER_WIDTH), color = colors.border},
        })},
        {delay = 0.05, segments = {{text = "+============================================================+", color = colors.border}}},
        {delay = 0.2, segments = {}},
        {delay = 0.1, segments = {
            {text = L("boot_operator"), color = colors.dim},
            {text = L("boot_operator_value"), color = colors.text},
        }},
        {delay = 0.08, segments = {
            {text = L("boot_clearance"), color = colors.dim},
            {text = L("boot_clearance_value"), color = colors.text},
        }},
        {delay = 0.08, segments = {
            {text = L("boot_shift"), color = colors.dim},
            {text = L("boot_shift_value"), color = colors.text},
        }},
        {delay = 0.08, segments = {
            {text = L("boot_terminal_label"), color = colors.dim},
            {text = L("boot_terminal_value"), color = colors.text},
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
