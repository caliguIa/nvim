return {
    "ibhagwan/fzf-lua",
    keys = function()
        return {
            { "<c-j>", "<c-j>", ft = "fzf", mode = "t", nowait = true },
            { "<c-k>", "<c-k>", ft = "fzf", mode = "t", nowait = true },
            {
                "<leader>,",
                "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>",
                desc = "Switch Buffer",
            },
            { "<leader>/", LazyVim.pick "live_grep", desc = "Grep (Root Dir)" },
            { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
            -- find
            { "<leader>sb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
            { "<leader>sc", LazyVim.pick.config_files(), desc = "Find Config File" },
            { "<leader>sf", LazyVim.pick "files", desc = "Find Files (Root Dir)" },
            { "<leader>sr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
            -- search
            { "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
            { "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
            { "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
            { "<leader>sg", LazyVim.pick "live_grep", desc = "Grep (Root Dir)" },
            { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
            { "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "Search Highlight Groups" },
            { "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
            { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
            { "<leader>sl", "<cmd>FzfLua loclist<cr>", desc = "Location List" },
            { "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
            { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
            { "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume" },
            { "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
            { "<leader>sw", LazyVim.pick "grep_cword", desc = "Word (Root Dir)" },
            { "<leader>sw", LazyVim.pick "grep_visual", mode = "v", desc = "Selection (Root Dir)" },
            { "<leader>uC", LazyVim.pick "colorschemes", desc = "Colorscheme with Preview" },
            {
                "<leader>ss",
                function()
                    require("fzf-lua").lsp_document_symbols {
                        regex_filter = symbols_filter,
                    }
                end,
                desc = "Goto Symbol",
            },
            {
                "<leader>sS",
                function()
                    require("fzf-lua").lsp_live_workspace_symbols {
                        regex_filter = symbols_filter,
                    }
                end,
                desc = "Goto Symbol (Workspace)",
            },
        }
    end,
}
