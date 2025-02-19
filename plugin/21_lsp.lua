local add, later = MiniDeps.add, MiniDeps.later

local clients = { "eslint" } -- Let's focus on just eslint for now
local base_capabilities = vim.lsp.protocol.make_client_capabilities()

later(function()
    -- add({ source = "saghen/blink.cmp" })
    -- local enhanced_capabilities = require("blink.cmp").get_lsp_capabilities(base_capabilities)

    for _, client in pairs(clients) do
        local cur_config = vim.lsp.config[client]
        if cur_config then
            local config_patch = {
                capabilities = enhanced_capabilities,
            }

            if cur_config.cmd then
                config_patch.cmd = { vim.fn.exepath(cur_config.cmd[1]), unpack(cur_config.cmd, 2) }
            end

            -- Keep other important settings
            config_patch.root_dir = cur_config.root_dir
            config_patch.settings = cur_config.settings
            config_patch.handlers = cur_config.handlers
            config_patch.init_options = cur_config.init_options
            config_patch.before_init = cur_config.before_init
            config_patch.on_new_config = cur_config.on_new_config

            -- vim.lsp.config(client, config_patch)
            -- vim.lsp.enable(client)
        end
    end
end)
