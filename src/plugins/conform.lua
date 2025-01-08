later(function()
    add("stevearc/conform.nvim")

    local util = require("conform.util")

    require("conform").setup({
        stop_after_first = true,
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
            typescript = { "deno_fmt", "prettier" },
            typescriptreact = { "deno_fmt", "prettier" },
            css = { "prettier" },
            html = { "prettier" },
            javascript = { "deno_fmt", "prettier" },
            javascriptreact = { "deno_fmt", "prettier" },
            json = { "prettier" },
            jsonc = { "prettier" },
            markdown = { "prettier" },
            scss = { "prettier" },
            vue = { "prettier" },
            yaml = { "prettier" },
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
            deno_fmt = {
                cwd = require("conform.util").root_file({
                    "deno.json",
                }),
                require_cwd = true,
            },
        },
        format_on_save = {
            timeout_ms = 3000,
            lsp_format = "fallback",
        },
    })
end)
