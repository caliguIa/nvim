return {
    {
        "saghen/blink.cmp",
        lazy = false,
        dependencies = {
            -- { "saghen/blink.compat", opts = { impersonate_nvim_cmp = true } },
            "rafamadriz/friendly-snippets",
            -- { "kristijanhusak/vim-dadbod-completion", lazy = true },
        },
        version = "v0.*",
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            highlight = { use_nvim_cmp_as_default = true },
            -- sources = {
            --     completion = {
            --         enabled_providers = { "lsp", "path", "snippets", "buffer", "vim-dadbod-completion" },
            --     },
            --
            --     providers = {
            --         ["vim-dadbod-completion"] = {
            --             name = "vim-dadbod-completion",
            --             module = "blink.compat.source",
            --             score_offset = 3,
            --             -- opts = {},
            --         },
            --     },
            -- },
            keymap = {
                preset = "default",
                ["<C-a>"] = { "select_and_accept" },
            },
        },
    },
}
