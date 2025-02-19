local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add({
        source = "MeanderingProgrammer/render-markdown.nvim",
        depends = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
    })
    require("render-markdown").setup({})
end)
