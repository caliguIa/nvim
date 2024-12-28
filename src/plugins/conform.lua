later(function()
    add("stevearc/conform.nvim")

    local util = require("conform.util")
    require("conform").setup({
        notify_on_error = false,
        default_format_opts = {
            timeout_ms = 3000,
            async = false,
            quiet = false,
            lsp_format = "fallback",
        },
        formatters_by_ft = {
            lua = { "stylua" },
            php = { "pint" },
        },
        ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
        formatters = {
            injected = { options = { ignore_errors = true } },
            pint = {
                command = util.find_executable({
                    "vendor/bin/pint",
                }, "pint"),
                args = { "$FILENAME" },
                stdin = false,
            },
        },
        format_on_save = {
            timeout_ms = 3000,
            lsp_format = "fallback",
        },
    })
end)
