local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add("ramilito/winbar.nvim")
    require("winbar").setup({
        icons = true,
        diagnostics = true,
        buf_modified = true,
        -- buf_modified_symbol = "M",
        -- or use an icon
        buf_modified_symbol = "●",
        dim_inactive = {
            enabled = true,
            highlight = "WinbarNC",
            icons = true, -- whether to dim the icons
            name = true, -- whether to dim the name
        },
        dir_levels = 3,
        filetype_exclude = {
            "help",
            "ministarter",
            "neogitstatus",
            "Trouble",
            "alpha",
            "lir",
            "oil",
            "toggleterm",
            "prompt",
        },
    })
end)
