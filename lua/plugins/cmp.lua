return {
    {
        "saghen/blink.cmp",
        lazy = false,
        dependencies = {
            -- "saghen/blink.compat",
            "rafamadriz/friendly-snippets",
            -- "kristijanhusak/vim-dadbod-completion",
        },
        version = "v0.*",
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            highlight = { use_nvim_cmp_as_default = true },
            -- sources = {
            -- completion = {
            --     enabled_providers = { "lsp", "path", "snippets", "buffer" },
            -- },

            -- providers = {
            --     lazydev = {
            --         name = "lazydev",
            --         module = "blink.compat",
            --         score_offset = 3,
            --         opts = {},
            --     },
            -- ["vim-dadbod-completion"] = {
            --     name = "vim-dadbod-completion",
            --     module = "blink.compat",
            --     score_offset = 3,
            --     opts = {},
            -- },
            -- },
            -- },
            keymap = {
                ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
                ["<C-e>"] = { "hide" },
                ["<C-y>"] = { "select_and_accept" },
                ["<C-a>"] = { "select_and_accept" },

                ["<C-p>"] = { "select_prev", "fallback" },
                ["<C-n>"] = { "select_next", "fallback" },
                ["<C-k>"] = { "select_prev", "fallback" },
                ["<C-j>"] = { "select_next", "fallback" },
                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },

                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },

                ["<Tab>"] = { "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "snippet_backward", "fallback" },
            },
        },
    },
}
