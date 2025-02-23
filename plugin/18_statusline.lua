local api = vim.api
local fn = vim.fn
local diagnostic = vim.diagnostic
local lsp = vim.lsp

local CTRL_V = api.nvim_replace_termcodes("<C-V>", true, true, true)

local mode_map = {
    ["n"] = "N",
    ["v"] = "V",
    ["V"] = "VL",
    [CTRL_V] = "VB",
    ["i"] = "I",
    ["c"] = "C",
}

local severity_highlights = {
    ERROR = "%#DiagnosticError#",
    WARN = "%#DiagnosticWarn#",
    HINT = "%#DiagnosticHint#",
}

local mode_highlights = {
    n = "MiniStatuslineModeNormal",
    i = "MiniStatuslineModeInsert",
    v = "MiniStatuslineModeVisual",
    V = "MiniStatuslineModeVisual",
    [CTRL_V] = "MiniStatuslineModeVisual",
    c = "MiniStatuslineModeCommand",
}

local function get_git_info()
    local file = fn.expand("%:p")
    if file == "" then return "" end

    local branch = fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
    if branch == "" then return "" end

    local status = fn.system("git status --porcelain " .. fn.shellescape(file) .. " 2>/dev/null")
    local status_icon = status:match("^.M") and " " or ""

    return branch .. status_icon
end

local function get_diagnostics()
    if #lsp.get_clients({ bufnr = 0 }) == 0 then return "" end

    local result = {}
    for _, severity in ipairs({ "ERROR", "WARN", "HINT" }) do
        local count = #diagnostic.get(0, { severity = severity })
        table.insert(result, severity_highlights[severity] .. (count > 0 and "" or ""))
    end

    return table.concat(result, " ")
end

local function get_lsp_clients()
    local names = {}
    for _, client in ipairs(lsp.get_clients({ bufnr = 0 })) do
        if client.name ~= "copilot" then names[#names + 1] = client.name end
    end
    return table.concat(names, " ")
end

local function get_copilot()
    if vim.bo.filetype == "" then return "" end
    for _, client in ipairs(lsp.get_clients({ bufnr = 0 })) do
        if client.name == "copilot" then return "" end
    end
    return ""
end

local function get_search_count()
    if vim.v.hlsearch == 0 then return "" end
    local ok, s_count = pcall(vim.fn.searchcount, { recompute = true })
    if not ok or s_count.current == nil or s_count.total == 0 then return "" end

    if s_count.incomplete == 1 then return "?/?" end

    local too_many = ">" .. s_count.maxcount
    local current = s_count.current > s_count.maxcount and too_many or s_count.current
    local total = s_count.total > s_count.maxcount and too_many or s_count.total
    return current .. "/" .. total
end

function StatusLine()
    local mode = api.nvim_get_mode().mode
    local mode_hl = "%#" .. (mode_highlights[mode] or mode_highlights.n) .. "#"
    local current_line = fn.line(".")
    local total_lines = fn.line("$")
    local filetype = vim.bo.filetype

    local left_parts = {
        { hl = mode_hl, content = mode_map[mode] or mode },
        { hl = "%#MiniStatuslineDevinfo#", content = get_git_info() },
        { hl = "%#MiniStatuslineFilename#", content = get_diagnostics() },
        { hl = "%#MiniStatuslineFilename#", content = get_lsp_clients() },
    }

    local right_parts = {
        { hl = "%#MiniStatuslineDevinfo#", content = get_copilot() },
        { hl = "%#MiniStatuslineDevinfo#", content = filetype ~= "" and filetype or "" },
        { hl = mode_hl, content = get_search_count() },
        { hl = mode_hl, content = math.floor(current_line / total_lines * 100) .. "%% " .. total_lines },
    }

    local left_status = {}
    local right_status = {}

    for _, part in ipairs(left_parts) do
        if part.content and part.content ~= "" then table.insert(left_status, part.hl .. " " .. part.content .. " ") end
    end

    for _, part in ipairs(right_parts) do
        if part.content and part.content ~= "" then
            table.insert(right_status, part.hl .. " " .. part.content .. " ")
        end
    end

    -- Reset highlight for the middle spacer
    return table.concat(left_status) .. "%#Normal#%=" .. table.concat(right_status)
end

api.nvim_create_autocmd({
    "WinEnter",
    "BufEnter",
    "ModeChanged",
    "CursorMoved",
    "CursorMovedI",
    "InsertEnter",
    "InsertLeave",
}, {
    callback = function() vim.wo.statusline = "%!v:lua.StatusLine()" end,
})
