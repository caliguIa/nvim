local function is_in_todo_dir()
    local filepath = vim.fn.expand "%:p"
    return string.find(filepath:lower(), "todo") ~= nil
end

if is_in_todo_dir() then
    -- Force spell check off with multiple approaches
    vim.cmd [[
        setlocal nospell
        set nospell
    ]]
    vim.opt_local.spell = false

    vim.diagnostic.enable(false)
    require("tiny-inline-diagnostic").disable()
else
    -- vim.cmd "setlocal spell wrap"
end
