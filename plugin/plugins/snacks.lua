local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add("folke/snacks.nvim")
    require("snacks").setup({
        bigfile = { enabled = true },
        dashboard = { enabled = false },
        explorer = { enabled = false },
        indent = { enabled = true },
        input = { enabled = false },
        picker = {
            enabled = true,
            cwd_bonus = true, -- give bonus for matching files in the cwd
            frecency = true, -- frecency bonus
            history_bonus = true, -- give more weight to chronological order
            layout = {
                preset = "ivy",
                border = "none",
            },
            sources = {
                buffers = { layout = "select" },
            },
        },
        notifier = { enabled = false },
        quickfile = { enabled = false },
        scope = { enabled = false },
        scroll = { enabled = false },
        statuscolumn = { enabled = false },
        words = { enabled = true },
    })

    vim.keymap.del("n", "grr")
    vim.keymap.del("n", "gra")
    vim.keymap.del("n", "gri")
    vim.keymap.del("n", "grn")
    keymap("n", "<leader><space>", function() Snacks.picker.smart() end, { desc = "Smart Find Files" })
    keymap("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
    keymap("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
    keymap("n", "<leader>:", function() Snacks.picker.command_history() end, { desc = "Command History" })
    keymap("n", "<leader>n", function() Snacks.picker.notifications() end, { desc = "Notification History" })
    keymap("n", "<leader>sb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
    keymap(
        "n",
        "<leader>sc",
        function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,
        { desc = "Find Config File" }
    )
    keymap("n", "<leader>sf", function() Snacks.picker.files() end, { desc = "Find Files" })
    keymap("n", "<leader>so", function() Snacks.picker.recent() end, { desc = "Recent" })
    keymap("n", "<leader>gsb", function() Snacks.picker.git_branches() end, { desc = "Git Branches" })
    keymap("n", "<leader>gsl", function() Snacks.picker.git_log() end, { desc = "Git Log" })
    keymap("n", "<leader>gsL", function() Snacks.picker.git_log_line() end, { desc = "Git Log Line" })
    keymap("n", "<leader>gst", function() Snacks.picker.git_status() end, { desc = "Git Status" })
    keymap("n", "<leader>gss", function() Snacks.picker.git_stash() end, { desc = "Git Stash" })
    keymap("n", "<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Git Diff (Hunks)" })
    keymap("n", "<leader>sB", function() Snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" })
    keymap("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep" })
    keymap("v", "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Visual selection or word" })
    keymap("n", "<leader>s/", function() Snacks.picker.search_history() end, { desc = "Search History" })
    keymap("n", "<leader>sa", function() Snacks.picker.autocmds() end, { desc = "Autocmds" })
    keymap("n", "<leader>sc", function() Snacks.picker.command_history() end, { desc = "Command History" })
    keymap("n", "<leader>sC", function() Snacks.picker.commands() end, { desc = "Commands" })
    keymap("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
    keymap("n", "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" })
    keymap("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help Pages" })
    keymap("n", "<leader>sH", function() Snacks.picker.highlights() end, { desc = "Highlights" })
    keymap("n", "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Jumps" })
    keymap("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
    keymap("n", "<leader>sl", function() Snacks.picker.loclist() end, { desc = "Location List" })
    keymap("n", "<leader>sR", function() Snacks.picker.resume() end, { desc = "Resume" })
    keymap("n", "<leader>su", function() Snacks.picker.undo() end, { desc = "Undo History" })
    keymap("n", "<leader>uC", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })
    keymap("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
    keymap("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration" })
    keymap("n", "gr", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "References" })
    keymap("n", "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
    keymap("n", "gt", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
    keymap("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
    keymap("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })
    keymap("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
    keymap("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })
end)
