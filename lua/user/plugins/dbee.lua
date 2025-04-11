require("dbee").setup({
    sources = {
        require("dbee.sources").MemorySource:new({
            { name = "ous_local", type = "mysql", url = os.getenv("DBEE_OUS_LOCAL") },
            { name = "ous_staging", type = "mysql", url = os.getenv("DBEE_OUS_STAGING") },
            { name = "ous_prod", type = "mysql", url = os.getenv("DBEE_OUS_PROD") },
        }),
    },
})
Util.map.nl("do", require("dbee").toggle, "Database")

local ous_ssh_group = vim.api.nvim_create_augroup("OusSSHTunnel", { clear = true })
local ssh_handles = {}
vim.api.nvim_create_autocmd("VimEnter", {
    group = ous_ssh_group,
    callback = function()
        if not vim.startswith(vim.fn.getcwd(), os.getenv("HOME") .. "/ous") then return end

        for _, env in ipairs({ "staging", "prod" }) do
            local handle, _ = vim.uv.spawn("ssh", {
                args = { "-N", "ous-" .. env },
                stdio = { nil, nil, nil },
                detached = false,
            })
            if handle then
                ssh_handles[env] = handle
                vim.notify(env .. " SSH tunnel started", vim.log.levels.INFO)
            else
                vim.notify(env .. " SSH tunnel failed to start", vim.log.levels.ERROR)
            end
        end
    end,
})
vim.api.nvim_create_autocmd("VimLeave", {
    group = ous_ssh_group,
    callback = function()
        for _, handle in pairs(ssh_handles) do
            if handle then
                handle:kill(9)
                handle:close()
            end
        end
    end,
})
