local add, later = MiniDeps.add, MiniDeps.later

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

    keymap("n", "<Leader>gg", function() require("neogit").open() end, { desc = "Git" })
end)
