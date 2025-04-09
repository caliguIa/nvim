local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add("lukas-reineke/indent-blankline.nvim")
    require("ibl").setup({
        indent = { char = "│" },
        scope = { enabled = false },
    })
end)
later(function() add("mbbill/undotree") end)
later(function()
    add("akinsho/git-conflict.nvim")
    require("git-conflict").setup()
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
end)
later(function()
    add({
        source = "nvim-treesitter/nvim-treesitter",
        hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
        depends = { "windwp/nvim-ts-autotag", "folke/ts-comments.nvim" },
    })
    add("nvim-treesitter/nvim-treesitter-textobjects")
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
        },
    })
    require("blink.cmp").setup({
        completion = { documentation = { auto_show = true } },
    })
end)
later(function() add("ku1ik/vim-pasta") end)
later(function()
    add("vim-test/vim-test")

    local PhpUnitTransform = function(cmd)
        local parts = vim.split(cmd, " ")
        for i, part in ipairs(parts) do
            if part == "--colors" then parts[i] = "--colors=always" end
        end
        return table.concat(parts, " ")
    end

    vim.g["test#custom_transformations"] = { phpunit = PhpUnitTransform }
    vim.g["test#transformation"] = "phpunit"
    vim.g["test#php#phpunit#options"] = "--colors=always"
    vim.g["test#javascript#jest#options"] = "--color"
    vim.g["test#strategy"] = "neovim"
    vim.g["test#neovim#start_normal"] = 1
    vim.g["test#basic#start_normal"] = 1
    vim.g["test#neovim#term_position"] = "vert"
    vim.g["test#javascript#runner"] = "vitest"
end)
later(function() add("christoomey/vim-tmux-navigator") end)
later(function()
    add({
        source = "kndndrj/nvim-dbee",
        depends = { "MunifTanjim/nui.nvim" },
        hooks = { post_install = function() require("dbee").install() end },
    })
    require("dbee").setup({
        sources = {
            require("dbee.sources").MemorySource:new({
                { name = "ous_local", type = "mysql", url = os.getenv("DBEE_OUS_LOCAL") },
                { name = "ous_staging", type = "mysql", url = os.getenv("DBEE_OUS_STAGING") },
                { name = "ous_prod", type = "mysql", url = os.getenv("DBEE_OUS_PROD") },
            }),
        },
    })
end)
later(function()
    add("Goose97/timber.nvim")
    require("timber").setup({
        log_templates = {
            default = {
                php = [[dump("%log_target", %log_target);]],
            },
        },
    })
end)
later(function()
    add({
        source = "olimorris/codecompanion.nvim",
        depends = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    })
    require("codecompanion").setup({ strategies = { chat = { adapter = "anthropic" } } })
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
