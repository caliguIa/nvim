return {
    "sindrets/diffview.nvim",
    keys = {
        {
            "<leader>gd",
            vim.cmd.DiffviewOpen,
            desc = "Open diffview",
        },
        {
            "<leader>gh",
            vim.cmd.diffviewfilehistory,
            desc = "File history",
        },
        {
            "<leader>gfb",
            function()
                vim.cmd.DiffviewFileHistory(vim.api.nvim_buf_get_name(0))
            end,
            desc = "Buffer history",
        },
    },
}
