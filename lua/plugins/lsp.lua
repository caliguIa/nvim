return {
    {
        "williamboman/mason.nvim",
        opts = { ensure_installed = { "codelldb" } },
    },
    {
        "neovim/nvim-lspconfig",
        opts = function()
            local Keys = require("lazyvim.plugins.lsp.keymaps").get()
        -- stylua: ignore
        vim.list_extend(Keys, {
            { "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, desc = "Goto Definition", has = "definition" },
            { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References", nowait = true },
            { "gt", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto Type Definition" },
            { "<leader>rn", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
            { "<leader>rN", LazyVim.lsp.rename_file, desc = "Rename File", mode = {"n"}, has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
            { "gy", false },
            { "gD", false },
            { "gI", false },
            { "gK", false },
            { "<leader>cl", false },
        })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = false,
                severity_sort = true,
                signs = false,
                float = {
                    focusable = true,
                    style = "minimal",
                    border = "none",
                    source = "if_many",
                    header = "Diagnostics",
                    prefix = "",
                },
            },
        },
    },
}
