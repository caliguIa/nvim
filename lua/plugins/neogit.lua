return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "nvim-telescope/telescope.nvim",
    },
    opts = {
        disable_builtin_notifications = true,
        disable_insert_on_commit = "auto",
        integrations = {
            diffview = true,
            telescope = true,
            fzf_lua = false,
        },
        sections = {
            recent = {
                folded = false,
            },
        },
    },
    keys = {
        {
            "<Leader>gg",
            function()
                require("neogit").open()
            end,
            desc = "Git",
        },
        {
            "<Leader>gc",
            function()
                require("neogit").open({ "commit" })
            end,
            desc = "Git Commit",
        },
    },
    config = true,
}
