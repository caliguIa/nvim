local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add("stevearc/oil.nvim")
    require("oil").setup({
        lsp_file_methods = {
            autosave_changes = true,
        },
        view_options = {
            show_hidden = true,
        },
        keymaps = {
            ["q"] = "actions.close",
        },
    })

    keymap("n", "<Leader>fe", "<CMD>Oil<CR>", { desc = "File explorer" })
end)
