local add, later = MiniDeps.add, MiniDeps.later

local clients = { "lua_ls", "vtsls", "intelephense", "nil_ls", "zls" }
local base_capabilities = vim.lsp.protocol.make_client_capabilities()

later(function()
    add({ source = "saghen/blink.cmp" })
    local enhanced_capabilities = require("blink.cmp").get_lsp_capabilities(base_capabilities)

    for _, client in pairs(clients) do
        local cur_config = vim.lsp.config[client]
        if cur_config then
            vim.lsp.config(client, {
                capabilities = enhanced_capabilities,
                cmd = { vim.fn.exepath(cur_config.cmd[1]), unpack(cur_config.cmd, 2) },
            })
            vim.lsp.enable(client)
        else
        end
    end
end)
