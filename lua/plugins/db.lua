return {
    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            { "tpope/vim-dadbod", lazy = true },
            { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
        },
        cmd = {
            "DBUI",
            "DBUIToggle",
            "DBUIAddConnection",
            "DBUIFindBuffer",
        },
        init = function()
            local cmp = require("cmp")
            cmp.setup.filetype({ "sql" }, { sources = { { name = "vim-dadbod-completion" }, { name = "buffer" } } })
            vim.g.db_ui_use_nerd_fonts = 1
        end,
        keys = {
            {
                "<leader>db",
                "<CMD>DBUIToggle<CR>",
                desc = "Toggle database",
            },
        },
    },
}
