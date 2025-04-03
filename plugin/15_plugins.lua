local add, later = MiniDeps.add, MiniDeps.later

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
        depends = { "windwp/nvim-ts-autotag", "folke/ts-comments.nvim" },
    })
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
    require("nvim-ts-autotag").setup({ enable_close_on_slash = false })
end)
later(function()
    local function build_blink(params)
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
            "zbirenbaum/copilot.lua",
            "giuxtaposition/blink-cmp-copilot",
        },
    })
    require("copilot").setup({
        suggestion = {
            enabled = false,
            auto_trigger = true,
            keymap = { accept = false },
        },
        panel = { enabled = false },
    })
    require("blink.cmp").setup({
        completion = { documentation = { auto_show = true } },
        sources = {
            default = { "lsp", "copilot", "path", "snippets", "buffer" },
            providers = { copilot = { name = "copilot", module = "blink-cmp-copilot", async = true } },
        },
    })
end)
later(function() add("ku1ik/vim-pasta") end)
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
    require("neotest").setup({
        adapters = {
            require("neotest-phpunit"),
            require("neotest-vitest")({
                cwd = function(file)
                    local util = require("neotest-vitest.util")
                    return util.find_node_modules_ancestor(file)
                end,
            }),
        },
        output = { open_on_run = true },
    })
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
later(function() add("christoomey/vim-tmux-navigator") end)
later(function()
    add({ source = "kristijanhusak/vim-dadbod-ui", depends = { "tpope/vim-dadbod" } })
    local base = vim.fs.joinpath(os.getenv("HOME"), "tmp", "queries")
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_winwidth = 40
    vim.g.db_ui_win_position = "right"
    vim.g.db_ui_auto_execute_table_helpers = true
    vim.g.db_ui_execute_on_save = false
    vim.g.db_ui_show_database_icon = true
    vim.g.db_ui_save_location = base
    vim.g.db_ui_tmp_query_location = vim.fs.joinpath(base, "tmp")
    vim.g.dbs = {
        { name = "ous-local", url = os.getenv("DB_OUS_LOCAL") },
        { name = "ous-staging", url = os.getenv("DB_OUS_STAGING") },
        { name = "ous-prod", url = os.getenv("DB_OUS_PROD") },
    }
end)

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

    require("hanzel").setup({ icons = {
        directory = false,
    } })
    require("zendiagram").setup()
end)
---------------------
