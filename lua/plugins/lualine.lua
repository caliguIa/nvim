local icons = LazyVim.config.icons

return {
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                theme = "auto",
                disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "oil", "NeogitStatus" } },
            },
            sections = {
                lualine_a = { LazyVim.lualine.root_dir { icon = "", color = "" } },
                lualine_b = { LazyVim.lualine.pretty_path { length = 7 } },
                lualine_c = {},
                lualine_x = {
                    {
                        "diff",
                        symbols = { added = "+", modified = "~", removed = "-" },
                        separator = " ",
                    },
                },
                lualine_y = {
                    {
                        "diagnostics",
                        symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
                        colored = true,
                        always_visible = false,
                        separator = " ",
                    },
                },
                lualine_z = { { "branch", separator = " ", icon = "" } },
            },
        },
    },
}
