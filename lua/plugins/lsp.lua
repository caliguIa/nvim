return {
    "neovim/nvim-lspconfig",
    opts = function()
        if LazyVim.pick.want() ~= "telescope" then
            return
        end
        local Keys = require("lazyvim.plugins.lsp.keymaps").get()
        -- stylua: ignore
        vim.list_extend(Keys, {
            { "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, desc = "Goto Definition", has = "definition" },
            { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References", nowait = true },
            { "gt", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto Type Definition" },
            { "gy", false },
            { "gD", false },
            { "gI", false },
            { "gK", false },
        })
    end,
}
