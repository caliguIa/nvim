local add, later = MiniDeps.add, MiniDeps.later

-- Editor -----------
later(function()
    add("folke/flash.nvim")
    require("flash").setup()
end)
later(function()
    add("catgoose/nvim-colorizer.lua")
    require("colorizer").setup({
        user_default_options = {
            names = false,
            sass = { enable = true, parsers = { "css" } },
            mode = "virtualtext",
            virtualtext_inline = true,
        },
    })
end)
later(function()
    add("lukas-reineke/indent-blankline.nvim")
    require("ibl").setup({
        indent = { char = "│" },
        scope = { enabled = false },
    })
end)

later(function() add("mbbill/undotree") end)
---------------------

-- Git
later(function()
    add("sindrets/diffview.nvim")
    require("diffview").setup()
end)
later(function()
    add("lewis6991/gitsigns.nvim")
    local gitsigns = require("gitsigns")
    gitsigns.setup({
        signs_staged_enable = false,
        signcolumn = false,
        numhl = true,
    })
end)
later(function()
    add({ source = "ldelossa/gh.nvim", depends = { "ldelossa/litee.nvim" } })
    require("litee.lib").setup()
    require("litee.gh").setup()
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
        },
        formatters_by_ft = {
            lua = { "stylua" },
            php = { "pint" },
            typescript = { "deno_fmt", "prettier" },
            typescriptreact = { "deno_fmt", "prettier" },
            javascript = { "deno_fmt", "prettier" },
            javascriptreact = { "deno_fmt", "prettier" },
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
        depends = { "windwp/nvim-ts-autotag" },
    })
    add("folke/ts-comments.nvim")
    require("nvim-treesitter.configs").setup({
        --stylua: ignore
        ensure_installed = {
            "bash", "c", "cpp", "css", "csv", "diff", "elixir", "git_config", "git_rebase",
            "gitcommit", "gitignore", "gleam", "go", "html", "http", "javascript", "jsdoc",
            "json", "jsonc","json", "jq", "lua", "luadoc", "luap", "make", "markdown",
            "markdown_inline", "nix", "nu", "ocaml", "php", "php_only", "phpdoc", "printf", "python", "query",
            "regex", "rst", "rust", "sql", "ssh_config", "terraform", "toml", "tsx",
            "typescript", "vim", "vimdoc", "yaml", "zig",
        },
        incremental_selection = { enable = false },
        textobjects = { enable = false },
        indent = { enable = true },
        highlight = { enable = true },
    })
    require("ts-comments").setup()
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
            accept = { auto_brackets = { enabled = true } },
            menu = { draw = { treesitter = { "lsp" } } },
            ghost_text = { enabled = false },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
            },
        },
        cmdline = { enabled = false },
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
                },
            },
        },
        appearance = {
            use_nvim_cmp_as_default = false,
            nerd_font_variant = "mono",
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

later(function() add("ku1ik/vim-pasta") end)
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

later(function()
    add({
        source = "adalessa/laravel.nvim",
        depends = {
            "kevinhwang91/promise-async",
            "tpope/vim-dotenv",
            "MunifTanjim/nui.nvim",
        },
    })
    require("laravel").setup({
        lsp_server = "intelephense",
        features = {
            route_info = { enable = true, position = "right" },
            override = { enable = true },
            pickers = { enable = true, provider = "ui.select" },
        },
    })
    local app = require("laravel").app
    local route_info_view = {}
    function route_info_view:get(route)
        return {
            virt_text = {
                { "[", "comment" },
                { "Method: ", "comment" },
                { table.concat(route.methods, "|"), "@enum" },
                { " Uri: ", "comment" },
                { route.uri, "@enum" },
                { "]", "comment" },
            },
        }
    end

    app:instance("route_info_view", route_info_view)
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
