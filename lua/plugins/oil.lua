return {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
        default_file_explorer = true,
        columns = { "icon" },
        win_options = {
            wrap = false,
            signcolumn = "no",
            cursorcolumn = false,
            foldcolumn = "0",
            spell = false,
            list = false,
            conceallevel = 3,
            concealcursor = "nvic",
        },
        view_options = {
            show_hidden = true,
        },
    },
    keys = {
        {
            "<leader>fe",
            "<CMD>Oil<CR>",
            desc = "File explorer",
        },
    },
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
}
