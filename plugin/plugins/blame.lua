local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add("FabijanZulj/blame.nvim")
    require("blame").setup()

    keymap("n", "<leader>gb", "<cmd>BlameToggle<cr>", { desc = "Git blame" })
end)
