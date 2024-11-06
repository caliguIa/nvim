return {
    {
        "saghen/blink.cmp",
        optional = false,
        enabled = true,
        -- dependencies = {
        --     { "saghen/blink.compat", opts = {} },
        --     {
        --         "zbirenbaum/copilot-cmp",
        --         dependencies = "copilot.lua",
        --         opts = {},
        --         config = function(_, opts)
        --             local copilot_cmp = require "copilot_cmp"
        --             copilot_cmp.setup(opts)
        --             LazyVim.lsp.on_attach(function(client) copilot_cmp._on_insert_enter {} end, "copilot")
        --         end,
        --     },
        -- },
        specs = {
            {
                "zbirenbaum/copilot.lua",
                event = "InsertEnter",
                opts = {
                    suggestion = {
                        enabled = true,
                        auto_trigger = true,
                        keymap = { accept = false },
                    },
                },
            },
        },
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            windows = {
                ghost_text = {
                    enabled = false,
                },
            },
            -- sources = {
            --     completion = {
            --         -- remember to enable your providers here
            --         enabled_providers = { "lsp", "path", "snippets", "buffer", "copilot" },
            --     },
            -- },
            -- providers = {
            --     digraphs = {
            --         name = "copilot", -- IMPORTANT: use the same name as you would for nvim-cmp
            --         module = "blink.compat.source",
            --
            --         -- all blink.cmp source config options work as normal:
            --         score_offset = -3,
            --
            --         opts = {},
            --     },
            -- },
            highlight = { use_nvim_cmp_as_default = true },
            keymap = {
                preset = "default",
                ["<Tab>"] = {
                    function(cmp)
                        if cmp.is_in_snippet() then
                            return cmp.accept()
                        else
                            return cmp.select_and_accept()
                        end
                    end,
                    "snippet_forward",
                    "fallback",
                },
                ["<C-a>"] = {
                    function()
                        if require("copilot.suggestion").is_visible() then
                            LazyVim.create_undo()
                            require("copilot.suggestion").accept()
                            return true
                        else
                        end
                    end,
                },
            },
        },
    },
}
