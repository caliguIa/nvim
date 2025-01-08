local function build_blink(params)
    vim.notify("Building blink.cmp", vim.log.levels.INFO)
    local obj = vim.system({ "nix", "run", ".#build-plugin" }, { cwd = params.path }):wait()
    if obj.code == 0 then
        vim.notify("Building blink.cmp done", vim.log.levels.INFO)
    else
        vim.notify("Building blink.cmp failed", vim.log.levels.ERROR)
    end
end

later(function()
    add({
        source = "saghen/blink.cmp",
        hooks = {
            post_install = build_blink,
            post_checkout = build_blink,
        },
        depends = {
            "rafamadriz/friendly-snippets",
            "saghen/blink.compat",
            "zbirenbaum/copilot.lua",
            "giuxtaposition/blink-cmp-copilot",
        },
    })

    require("copilot").setup({
        suggestion = {
            enabled = false,
            auto_trigger = true,
            keymap = {
                accept = false,
                next = "<M-]>",
                prev = "<M-[>",
            },
        },
        panel = { enabled = false },
        filetypes = {
            markdown = true,
            help = true,
        },
    })

    local opts = {
        completion = {
            accept = {
                auto_brackets = {
                    enabled = true,
                },
            },
            menu = {
                draw = {
                    treesitter = { "lsp" },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
            },
            ghost_text = {
                enabled = false,
            },
        },
        sources = {
            compat = {},
            default = { "lsp", "path", "snippets", "buffer", "lazydev", "copilot" },
            cmdline = {},
            providers = {
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    score_offset = 100,
                },
                copilot = {
                    name = "copilot",
                    module = "blink-cmp-copilot",
                    kind = "Copilot",
                    score_offset = 100,
                    async = true,
                    transform_items = function(_, items)
                        local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                        local kind_idx = #CompletionItemKind + 1
                        CompletionItemKind[kind_idx] = "Copilot"
                        for _, item in ipairs(items) do
                            item.kind = kind_idx
                        end
                        return items
                    end,
                },
            },
        },
        appearance = {
            use_nvim_cmp_as_default = false,
            nerd_font_variant = "mono",
            -- Blink does not expose its default kind icons so you must copy them all (or set your custom ones) and add Copilot
            kind_icons = {
                Copilot = "",
                Text = "󰉿",
                Method = "󰊕",
                Function = "󰊕",
                Constructor = "󰒓",

                Field = "󰜢",
                Variable = "󰆦",
                Property = "󰖷",

                Class = "󱡠",
                Interface = "󱡠",
                Struct = "󱡠",
                Module = "󰅩",

                Unit = "󰪚",
                Value = "󰦨",
                Enum = "󰦨",
                EnumMember = "󰦨",

                Keyword = "󰻾",
                Constant = "󰏿",

                Snippet = "󱄽",
                Color = "󰏘",
                File = "󰈔",
                Reference = "󰬲",
                Folder = "󰉋",
                Event = "󱐋",
                Operator = "󰪚",
                TypeParameter = "󰬛",
            },
        },
        keymap = {
            preset = "default",
            ["<C-y>"] = { "select_and_accept" },
        },
    }

    -- Unset custom prop to pass blink.cmp validation
    opts.sources.compat = nil

    -- Process source providers
    for _, provider in pairs(opts.sources.providers or {}) do
        if provider.kind then
            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
            local kind_idx = #CompletionItemKind + 1

            CompletionItemKind[kind_idx] = provider.kind
            CompletionItemKind[provider.kind] = kind_idx

            local transform_items = provider.transform_items
            provider.transform_items = function(ctx, items)
                items = transform_items and transform_items(ctx, items) or items
                for _, item in ipairs(items) do
                    item.kind = kind_idx or item.kind
                end
                return items
            end

            provider.kind = nil
        end
    end

    require("blink.cmp").setup(opts)
end)
