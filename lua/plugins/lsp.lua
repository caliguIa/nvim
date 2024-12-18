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
            { "gd", "<cmd>FzfLua lsp_definitions     jump_to_single_result=true ignore_current_line=true<cr>", desc = "Goto Definition", has = "definition" },
            { "gr", "<cmd>FzfLua lsp_references      jump_to_single_result=true ignore_current_line=true<cr>", desc = "References", nowait = true },
            { "gI", "<cmd>FzfLua lsp_implementations jump_to_single_result=true ignore_current_line=true<cr>", desc = "Goto Implementation" },
            { "gt", "<cmd>FzfLua lsp_typedefs        jump_to_single_result=true ignore_current_line=true<cr>", desc = "Goto T[y]pe Definition" },
            { "<leader>rn", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
            { "<leader>rN", Snacks.rename.rename_file, desc = "Rename File", mode = {"n"}, has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
            { "gy", false },
            { "gD", false },
            { "gI", false },
            { "gK", false },
            { "[d", false },
            { "]d", false },
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
                    header = "",
                    prefix = "",
                },
            },
        },
    },
}
