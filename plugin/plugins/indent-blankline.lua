local add, later = MiniDeps.add, MiniDeps.now

later(function()
    add("lukas-reineke/indent-blankline.nvim")
    require("ibl").setup({
        indent = {
            char = "│",
            tab_char = "│",
        },
        scope = { enabled = false },
        exclude = {
            filetypes = {
                "Trouble",
                "alpha",
                "dashboard",
                "help",
                "notify",
                "toggleterm",
                "trouble",
            },
        },
    })
end)
