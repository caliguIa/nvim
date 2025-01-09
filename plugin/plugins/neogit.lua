local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add({
        source = "NeogitOrg/neogit",
        depends = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "ibhagwan/fzf-lua",
        },
    })

    require("neogit").setup({
        -- disable_builtin_notifications = true,
        disable_insert_on_commit = "auto",
        integrations = {
            diffview = true,
            fzf_lua = true,
        },
        initial_branch_name = "DREAD-",
    })

    keymap("n", "<Leader>gg", function() require("neogit").open() end, { desc = "Git" })
end)
