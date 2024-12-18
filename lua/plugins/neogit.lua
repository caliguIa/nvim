return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "ibhagwan/fzf-lua",
    },
    opts = {
        disable_builtin_notifications = true,
        disable_insert_on_commit = "auto",
        integrations = {
            diffview = true,
            telescope = false,
            fzf_lua = true,
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
            function() require("neogit").open() end,
            desc = "Git",
        },
        {
            "<Leader>gc",
            function() require("neogit").open { "commit" } end,
            desc = "Git Commit",
        },
    },
    config = true,
}
