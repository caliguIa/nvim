later(function()
    add("mbbill/undotree")
    keymap("n", "<leader>U", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })
end)
