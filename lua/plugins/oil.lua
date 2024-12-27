return {
    "stevearc/oil.nvim",
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    lazy = false,
    opts = {
        lsp_file_methods = {
            autosave_changes = true,
        },
        view_options = {
            show_hidden = true,
        },
        keymaps = {
            ["q"] = "actions.close",
        },
    },
    config = function(_, opts)
        require("oil").setup(opts)

        -- Auto-open Oil when starting Neovim with no file arguments
        vim.api.nvim_create_autocmd("UIEnter", {
            callback = function()
                vim.schedule(function()
                    if vim.fn.argc() == 0 then vim.cmd "Oil" end
                end)
            end,
        })
    end,
    keys = {
        {
            "<leader>fe",
            "<CMD>Oil<CR>",
            desc = "File explorer",
        },
    },
}
