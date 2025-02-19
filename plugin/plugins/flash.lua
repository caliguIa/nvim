local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add("folke/flash.nvim")
    require("flash").setup()

    keymap("n", "<cr>", function() require("flash").jump() end, { desc = "Flash" })
    keymap("n", "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
    keymap("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })
end)
