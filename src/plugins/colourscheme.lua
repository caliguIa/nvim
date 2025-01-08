later(function()
    add({ source = "catppuccin/nvim", name = "catppuccin" })

    require("catppuccin").setup({
        integrations = {
            fzf = true,
            grug_far = true,
            illuminate = true,
            indent_blankline = { enabled = true },
            markdown = true,
            mini = true,
            native_lsp = {
                enabled = true,
                underlines = {
                    errors = { "undercurl" },
                    hints = { "undercurl" },
                    warnings = { "undercurl" },
                    information = { "undercurl" },
                },
            },
            neotest = true,
            treesitter = true,
            treesitter_context = true,
        },
    })

    vim.cmd.colorscheme("catppuccin-mocha")
end)
