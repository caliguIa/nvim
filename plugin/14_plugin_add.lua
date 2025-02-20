local add, later = MiniDeps.add, MiniDeps.later

local build_blink = function(params)
    vim.notify("Building blink.cmp", vim.log.levels.INFO)
    local obj = vim.system({ "nix", "run", ".#build-plugin" }, { cwd = params.path }):wait()
    if obj.code == 0 then
        vim.notify("Building blink.cmp done", vim.log.levels.INFO)
    else
        vim.notify("Building blink.cmp failed", vim.log.levels.ERROR)
    end
end

later(function()
    add("FabijanZulj/blame.nvim")
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
    add({ source = "catppuccin/nvim", name = "catppuccin" })
    add("stevearc/conform.nvim")
    add("folke/flash.nvim")
    add({ source = "akinsho/git-conflict.nvim", checkout = "v2.1.0" })
    add({ source = "ThePrimeagen/harpoon", checkout = "harpoon2", depends = { "nvim-lua/plenary.nvim" } })
    add("MagicDuck/grug-far.nvim")
    add({
        source = "NeogitOrg/neogit",
        depends = {
            "nvim-lua/plenary.nvim",
        },
    })
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
    add("stevearc/oil.nvim")
    add({
        source = "MeanderingProgrammer/render-markdown.nvim",
        depends = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
    })
    add("folke/snacks.nvim")
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
    add("nvim-treesitter/nvim-treesitter-textobjects")
    add("folke/ts-comments.nvim")
    add("mbbill/undotree")
    add("mfussenegger/nvim-lint")
end)

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
end)
