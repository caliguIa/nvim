vim.keymap.del("n", "grr")
vim.keymap.del("n", "gra")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grn")

_G.Config.leader_group_clues = {
    { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
    { mode = "n", keys = "<Leader>c", desc = "+Code" },
    { mode = "n", keys = "<Leader>f", desc = "+File" },
    { mode = "n", keys = "<Leader>g", desc = "+Git" },
    { mode = "n", keys = "<Leader>m", desc = "+Marks" },
    { mode = "n", keys = "<Leader>r", desc = "+Rename" },
    { mode = "n", keys = "<Leader>s", desc = "+Search" },
    { mode = "n", keys = "<Leader>t", desc = "+Test" },
    { mode = "n", keys = "<Leader>w", desc = "+Window" },
    { mode = "n", keys = "<Leader><tab>", desc = "+Tabs" },
}

-- Better command history navigation
keymap("c", "<C-p>", "<Up>", { silent = false })
keymap("c", "<C-n>", "<Down>", { silent = false })

keymap("n", "q", "<Nop>", { desc = "Disable macro recording because I do not use it" })
keymap("n", "m", "<Nop>", { desc = "Disable marks because I do not use them" })
keymap("n", "x", '"_x', { desc = "Delete character without copying" })
keymap("n", "<leader>X", "<cmd>!chmod +x %<CR>", { desc = "Make file executable" })

keymap("n", "<C-d>", "<C-d>zz", { desc = "move [d]own half-page and center" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "move [u]p half-page and center" })

keymap({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Buffers
keymap("n", "<leader>ba", "<Cmd>b#<CR>", { desc = "Alternate" })

-- Search
keymap("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
keymap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
keymap("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
keymap("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
keymap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
keymap("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Add undo break-points
keymap("i", ",", ",<c-g>u")
keymap("i", ".", ".<c-g>u")
keymap("i", ";", ";<c-g>u")

-- better indenting
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- new file
keymap("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- windows
keymap("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
keymap("n", "<leader>w", "<c-w>", { desc = "Windows", remap = true })
keymap("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })

-- better up/down
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true })
keymap({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true })
keymap({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true })

-- Quickfix list
keymap("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
keymap("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
keymap("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- tabs
keymap("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next" })
keymap("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous" })
keymap("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close current" })
keymap("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close other" })

-- git
keymap("n", "<leader>gb", "<cmd>BlameToggle<cr>", { desc = "Git blame" })
keymap("n", "<Leader>gg", function() require("neogit").open() end, { desc = "Git" })
keymap(
    "n",
    "<leader>go",
    function() return MiniDiff.toggle_overlay(0) end,
    { expr = true, remap = true, desc = "Toggle diff overlay" }
)

-- flash
keymap("n", "<cr>", function() require("flash").jump() end, { desc = "Flash" })
keymap("n", "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
keymap("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })

-- mini
keymap("n", "<leader>nh", MiniNotify.show_history, { desc = "Show notification history" })
keymap("n", "<leader>bd", "<Cmd>lua MiniBufremove.delete()<CR>", { desc = "Delete current" })
keymap("n", "<leader>bo", function()
    local current_buf = vim.api.nvim_get_current_buf()
    local all_bufs = vim.api.nvim_list_bufs()

    for _, buf in ipairs(all_bufs) do
        -- Skip the current buffer and non-listed/invalid buffers
        if buf ~= current_buf and vim.fn.buflisted(buf) == 1 and vim.api.nvim_buf_is_valid(buf) then
            MiniBufremove.delete(buf, true) -- Using force=true to skip confirmation
        end
    end
end, { desc = "Delete others" })

-- neotest
keymap(
    "n",
    "<leader>tf",
    function() require("neotest").run.run(vim.fn.expand("%")) end,
    { desc = "Run File (Neotest)" }
)
keymap(
    "n",
    "<leader>tF",
    function() require("neotest").run.run(vim.fn.expand("%:h")) end,
    { desc = "Run Directory (Neotest)" }
)
keymap("n", "<leader>tr", function() require("neotest").run.run() end, { desc = "Run Nearest (Neotest)" })
keymap("n", "<leader>tl", function() require("neotest").run.run_last() end, { desc = "Run Last (Neotest)" })
keymap("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Toggle Summary (Neotest)" })
keymap(
    "n",
    "<leader>to",
    function() require("neotest").output.open({ enter = true, auto_close = true }) end,
    { desc = "Show Output (Neotest)" }
)
keymap(
    "n",
    "<leader>tO",
    function() require("neotest").output_panel.toggle() end,
    { desc = "Toggle Output Panel (Neotest)" }
)
keymap("n", "<leader>tS", function() require("neotest").run.stop() end, { desc = "Stop (Neotest)" })

-- oil
keymap("n", "<Leader>fe", "<CMD>Oil<CR>", { desc = "File explorer" })

-- snacks
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
keymap("n", "<leader>sC", function() Snacks.picker.colorschemes() end, { desc = "Search colorschemes" })
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

-- undotree
keymap("n", "<leader>U", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })
