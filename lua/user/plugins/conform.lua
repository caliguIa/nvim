local util = require("conform.util")
require("conform").setup({
    stop_after_first = false,
    notify_on_error = false,
    default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
    },
    --stylua: ignore
    formatters_by_ft = {
        lua = { "stylua" }, php = { "pint" }, typescript = { "prettier" },
        typescriptreact = { "prettier" }, javascript = { "prettier" },
        javascriptreact = { "prettier" }, css = { "prettier" }, html = { "prettier" },
        json = { "prettier" }, jsonc = { "prettier" }, markdown = { "prettier" },
        nix = { "nixfmt" }, rust = { "rustfmt" }, scss = { "prettier" },
        sql = { "sleek" }, mysql = { "sleek" }, vue = { "prettier" }, yaml = { "prettier" },
    },
    formatters = {
        injected = { options = { ignore_errors = true } },
        pint = {
            command = util.find_executable({ "vendor/bin/pint" }, "pint"),
            args = { "$FILENAME" },
            stdin = false,
        },
    },
    format_on_save = { timeout_ms = 3000, lsp_format = "fallback" },
})
