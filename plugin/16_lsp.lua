local later = MiniDeps.later

later(function()
    vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities({
            textDocument = {
                foldingRange = {
                    dynamicRegistration = false,
                    lineFoldingOnly = true,
                },
            },
        }),
        root_markers = { ".git" },
    })

    vim.iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
        :map(function(server_config_path) return vim.fs.basename(server_config_path):match("^(.*)%.lua$") end)
        :each(function(server_name) vim.lsp.enable(server_name) end)
end)
