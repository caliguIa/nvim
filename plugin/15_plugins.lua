local add, later = MiniDeps.add, MiniDeps.later

-- Editor -----------
later(function()
    add("folke/flash.nvim")
    require("flash").setup()
end)
later(function()
    add("folke/snacks.nvim")
    require("snacks").setup({
        bigfile = { enabled = true },
        indent = { enabled = true },
        picker = {
            enabled = true,
            cwd_bonus = true, -- give bonus for matching files in the cwd
            frecency = true, -- frecency bonus
            history_bonus = true, -- give more weight to chronological order
            layout = {
                preset = "ivy",
                border = "none",
            },
            sources = {
                buffers = { layout = "select" },
            },
        },
    })
end)
later(function()
    add("stevearc/oil.nvim")
    function _G.get_oil_winbar()
        local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
        local dir = require("oil").get_current_dir(bufnr)
        if dir then
            return vim.fn.fnamemodify(dir, ":~")
        else
            -- If there is no current directory (e.g. over ssh), just show the buffer name
            return vim.api.nvim_buf_get_name(0)
        end
    end
    require("oil").setup({
        lsp_file_methods = { autosave_changes = true },
        view_options = { show_hidden = true },
        keymaps = { ["q"] = "actions.close" },
        watch_for_changes = false,
        win_options = {
            winbar = "%!v:lua.get_oil_winbar()",
        },
    })
end)
later(function()
    add("MagicDuck/grug-far.nvim")
    require("grug-far").setup()
end)
later(function() add("mbbill/undotree") end)
---------------------

-- Git
later(function()
    add({ source = "akinsho/git-conflict.nvim", checkout = "v2.1.0" })
    require("git-conflict").setup()
end)
later(function()
    add("FabijanZulj/blame.nvim")
    require("blame").setup()
end)
later(function()
    add({
        source = "NeogitOrg/neogit",
        depends = {
            "nvim-lua/plenary.nvim",
        },
    })
    require("neogit").setup({
        disable_insert_on_commit = "auto",
        integrations = {
            diffview = false,
            fzf_lua = false,
        },
        initial_branch_name = "DREAD-",
    })
end)
---------------------

-- UI
-- later(function()
--     add({
--         source = "MeanderingProgrammer/render-markdown.nvim",
--         depends = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
--     })
--     require("render-markdown").setup()
-- end)
later(function()
    add({ source = "catppuccin/nvim", name = "catppuccin" })
    require("catppuccin").setup({
        integrations = {
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
---------------------

-- Lang
later(function()
    add("stevearc/conform.nvim")
    local util = require("conform.util")
    require("conform").setup({
        stop_after_first = false,
        notify_on_error = false,
        default_format_opts = {
            timeout_ms = 3000,
            async = false,
            quiet = false,
            -- lsp_format = "fallback",
        },
        formatters_by_ft = {
            lua = { "stylua" },
            php = { "pint" },
            typescript = { "deno_fmt", "eslint_d", "prettier" },
            typescriptreact = { "deno_fmt", "eslint_d", "prettier" },
            javascript = { "deno_fmt", "eslint_d", "prettier" },
            javascriptreact = { "deno_fmt", "eslint_d", "prettier" },
            css = { "prettier" },
            html = { "prettier" },
            json = { "prettier" },
            jsonc = { "prettier" },
            markdown = { "prettier" },
            nix = { "nixfmt" },
            rust = { "rustfmt" },
            scss = { "prettier" },
            vue = { "prettier" },
            yaml = { "prettier" },
        },
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
later(function()
    add({
        source = "nvim-treesitter/nvim-treesitter",
        checkout = "master",
        monitor = "main",
        hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
        depends = {
            "windwp/nvim-ts-autotag",
            "nvim-treesitter/nvim-treesitter-context",
        },
    })
    add("folke/ts-comments.nvim")
    require("nvim-treesitter.configs").setup({
        --stylua: ignore
        ensure_installed = {
            "bash", "c", "cpp", "css", "csv", "diff", "elixir", "git_config", "git_rebase",
            "gitcommit", "gitignore", "gleam", "go", "html", "http", "javascript", "jsdoc",
            "json", "jsonc","json", "jq", "lua", "luadoc", "luap", "make", "markdown",
            "markdown_inline", "nix", "nu", "ocaml", "php", "printf", "python", "query",
            "regex", "rst", "rust", "sql", "ssh_config", "terraform", "toml", "tsx",
            "typescript", "vim", "vimdoc", "yaml", "zig",
        },
        incremental_selection = { enable = false },
        textobjects = { enable = false },
        indent = { enable = false },
        highlight = {
            enable = true,
            disable = function(_, buf)
                local max_filesize = 240 * 1024
                local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then return true end
            end,
        },
    })
    require("ts-comments").setup()
    require("treesitter-context").setup({ mode = "cursor", max_lines = 3 })
    require("nvim-ts-autotag").setup()
end)
later(function()
    local build_blink = function(params)
        vim.notify("Building blink.cmp", vim.log.levels.INFO)
        local obj = vim.system({ "nix", "run", ".#build-plugin" }, { cwd = params.path }):wait()
        if obj.code == 0 then
            vim.notify("Building blink.cmp done", vim.log.levels.INFO)
        else
            vim.notify("Building blink.cmp failed", vim.log.levels.ERROR)
        end
    end
    add({
        source = "saghen/blink.cmp",
        hooks = {
            post_install = build_blink,
            post_checkout = build_blink,
        },
        depends = {
            "rafamadriz/friendly-snippets",
            "saghen/blink.compat",
            "giuxtaposition/blink-cmp-copilot",
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
        cmdline = {
            enabled = false,
        },
        sources = {
            compat = {},
            default = { "lsp", "path", "snippets", "buffer", "copilot" },
            providers = {
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
later(function()
    add("mfussenegger/nvim-lint")
    vim.env.ESLINT_D_PPID = vim.fn.getpid()
    require("lint").linters_by_ft = {
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        ["javascript.jsx"] = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        ["typescript.tsx"] = { "eslint_d" },
        rust = { "clippy" },
    }
end)
---------------------

--- AI
later(function()
    add("zbirenbaum/copilot.lua")
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
end)

--------------------

-- Test
later(function()
    add({
        source = "nvim-neotest/neotest",
        depends = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "olimorris/neotest-phpunit",
            "marilari88/neotest-vitest",
        },
    })
    local opts = {
        adapters = {
            ["neotest-phpunit"] = {},
            ["neotest-vitest"] = {
                cwd = function(file)
                    local util = require("neotest-vitest.util")
                    return util.find_node_modules_ancestor(file)
                end,
            },
        },
        output = { open_on_run = true },
    }

    if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
            if type(name) == "number" then
                if type(config) == "string" then config = require(config) end
                adapters[#adapters + 1] = config
            elseif config ~= false then
                local adapter = require(name)
                if type(config) == "table" and not vim.tbl_isempty(config) then
                    local meta = getmetatable(adapter)
                    if adapter.setup then
                        adapter.setup(config)
                    elseif adapter.adapter then
                        adapter.adapter(config)
                        adapter = adapter.adapter
                    elseif meta and meta.__call then
                        adapter = adapter(config)
                    else
                        error("Adapter " .. name .. " does not support setup")
                    end
                end
                adapters[#adapters + 1] = adapter
            end
        end
        opts.adapters = adapters
    end

    require("neotest").setup(opts)
end)
---------------------

-- Local
later(function()
    local dev_path = vim.fn.expand("~/dev/nvim-plugins")

    local function use_local_plugin(name)
        local plugin_path = dev_path .. "/" .. name
        vim.opt.runtimepath:prepend(plugin_path)

        local plugin_file = plugin_path .. "/plugin/" .. name:gsub("%.nvim$", "") .. ".lua"
        if vim.fn.filereadable(plugin_file) == 1 then vim.cmd("source " .. plugin_file) end
    end

    use_local_plugin("hanzel.nvim")
    use_local_plugin("zendiagram.nvim")

    require("hanzel").setup()
    require("zendiagram").setup()
end)
---------------------
