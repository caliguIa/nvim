vim.cmd "setlocal spell wrap"

if vim.b.did_ftplugin then return end
vim.b.did_ftplugin = 1

-- Function to check if current file is in a todo directory
local function is_in_todo_dir()
    local filepath = vim.fn.expand "%:p"
    return string.find(filepath:lower(), "/todo/") ~= nil
end

-- Disable spell checking and diagnostics for todo files
if is_in_todo_dir() then
    vim.opt_local.spell = false
    vim.diagnostic.enable(false)
end
