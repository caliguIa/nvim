vim.keymap.del("n", "grr")
vim.keymap.del("n", "gra")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grn")

-- Better command history navigation
Util.keymap("c", "<C-p>", "<Up>", { silent = false })
Util.keymap("c", "<C-n>", "<Down>", { silent = false })

Util.keymap("n", "q", "<Nop>", { desc = "Disable macro recording because I do not use it" })
Util.keymap("n", "m", "<Nop>", { desc = "Disable marks because I do not use them" })
Util.keymap("n", "x", '"_x', { desc = "Delete character without copying" })
Util.keymap("n", "<leader>X", "<cmd>!chmod +x %<CR>", { desc = "Make file executable" })

Util.keymap("n", "<C-d>", "<C-d>zz", { desc = "move [d]own half-page and center" })
Util.keymap("n", "<C-u>", "<C-u>zz", { desc = "move [u]p half-page and center" })

Util.keymap({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Buffers
Util.keymap("n", "<leader>ba", "<Cmd>b#<CR>", { desc = "Alternate" })

-- Search
Util.keymap("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
Util.keymap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
Util.keymap("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
Util.keymap("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
Util.keymap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
Util.keymap("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Add undo break-points
Util.keymap("i", ",", ",<c-g>u")
Util.keymap("i", ".", ".<c-g>u")
Util.keymap("i", ";", ";<c-g>u")

-- better indenting
Util.keymap("v", "<", "<gv")
Util.keymap("v", ">", ">gv")

-- new file
Util.keymap("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- windows
Util.keymap("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
Util.keymap("n", "<leader>w", "<c-w>", { desc = "Windows", remap = true })
Util.keymap("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })

-- better up/down
Util.keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
Util.keymap({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
Util.keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
Util.keymap({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Quickfix list
Util.keymap("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
Util.keymap("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
Util.keymap("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- tabs
Util.keymap("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next" })
Util.keymap("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous" })
Util.keymap("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close current" })
Util.keymap("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close other" })

-- flash
Util.keymap("n", "<cr>", function() require("flash").jump() end, { desc = "Flash" })
Util.keymap("n", "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
Util.keymap("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })

-- Easy insertion of a trailing ; or , from insert mode.
Util.keymap("i", ";;", "<Esc>A;<Esc>")
Util.keymap("i", ",,", "<Esc>A,<Esc>")

-- mini
Util.keymap("n", "<leader>nh", MiniNotify.show_history, { desc = "Show notification history" })
Util.keymap("n", "<leader>bd", "<Cmd>lua MiniBufremove.delete()<CR>", { desc = "Delete current" })
Util.keymap("n", "<leader>bo", function()
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
Util.keymap(
    "n",
    "<leader>tf",
    function() require("neotest").run.run(vim.fn.expand("%")) end,
    { desc = "Run File (Neotest)" }
)
Util.keymap(
    "n",
    "<leader>tF",
    function() require("neotest").run.run(vim.fn.expand("%:h")) end,
    { desc = "Run Directory (Neotest)" }
)
Util.keymap("n", "<leader>tr", function() require("neotest").run.run() end, { desc = "Run Nearest (Neotest)" })
Util.keymap("n", "<leader>tl", function() require("neotest").run.run_last() end, { desc = "Run Last (Neotest)" })
Util.keymap(
    "n",
    "<leader>ts",
    function() require("neotest").summary.toggle() end,
    { desc = "Toggle Summary (Neotest)" }
)
Util.keymap(
    "n",
    "<leader>to",
    function() require("neotest").output.open({ enter = true, auto_close = true }) end,
    { desc = "Show Output (Neotest)" }
)
Util.keymap(
    "n",
    "<leader>tO",
    function() require("neotest").output_panel.toggle() end,
    { desc = "Toggle Output Panel (Neotest)" }
)
Util.keymap("n", "<leader>tS", function() require("neotest").run.stop() end, { desc = "Stop (Neotest)" })
Util.keymap(
    "n",
    "<leader>tw",
    function() require("neotest").watch.toggle(vim.fn.expand("%")) end,
    { desc = "Toggle Watch (Neotest)" }
)

Util.keymap("n", "<Leader>fe", function() MiniFiles.open() end, { desc = "File explorer" })

-- search
Util.keymap("n", "<leader>cs", [[<cmd>Pick spellsuggest<cr>]], { desc = "Spelling" })
Util.keymap("n", "<leader>sb", [[<cmd>Pick buffers<cr>]], { desc = "Buffers" })
Util.keymap("n", "<leader>sf", [[<cmd>Pick files<cr>]], { desc = "Find Files" })
Util.keymap("n", "<leader>sg", [[<cmd>Pick grep_live<cr>]], { desc = "Grep" })
Util.keymap("n", "<leader>sh", [[<cmd>Pick help<cr>]], { desc = "Help Pages" })
Util.keymap("n", "<leader>sH", [[<cmd>Pick hl_groups<cr>]], { desc = "Highlight groups" })
Util.keymap("n", "<leader>sk", [[<cmd>Pick keymaps<cr>]], { desc = "Keymaps" })
Util.keymap("n", "<leader>sr", [[<cmd>Pick resume<cr>]], { desc = "Resume" })
Util.keymap("n", "<leader>so", [[<cmd>Pick visit_paths<cr>]], { desc = "Recent" })

local function goto_marked_file(index)
    local marked = MiniVisits.list_paths(nil, {
        filter = "core",
        sort = function(paths) return paths end,
    })
    if marked[index] then vim.cmd("edit " .. marked[index]) end
end

Util.keymap("n", "<leader>sm", [[<cmd>Pick visit_paths filter='core'<cr>]], { desc = "Marked files" })
Util.keymap("n", "<leader>ma", [[<cmd>lua MiniVisits.add_label("core")<CR>]], { desc = "Add mark" })
Util.keymap("n", "<leader>md", [[<cmd>lua MiniVisits.remove_label("core")<CR>]], { desc = "Delete mark" })
Util.keymap("n", "mq", function() goto_marked_file(1) end, { desc = "Goto mark 1" })
Util.keymap("n", "mw", function() goto_marked_file(2) end, { desc = "Goto mark 2" })
Util.keymap("n", "me", function() goto_marked_file(3) end, { desc = "Goto mark 3" })
Util.keymap("n", "mr", function() goto_marked_file(4) end, { desc = "Goto mark 4" })

-- undotree
Util.keymap("n", "<leader>U", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })

--php
Util.keymap("n", "<leader>la", ":Laravel artisan<cr>", { desc = "Laravel artisan" })
Util.keymap("n", "<leader>lsr", ":Laravel routes<cr>", { desc = "Laravel routes" })
Util.keymap("n", "<leader>lsm", ":Laravel related<cr>", { desc = "Laravel related" })

-- git
Util.keymap("n", "<leader>ghp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview hunk" })
Util.keymap("n", "<leader>ghi", "<cmd>Gitsigns preview_hunk_inline<cr>", { desc = "Preview hunk inline" })
Util.keymap("n", "<leader>gb", "<cmd>Gitsigns blame<cr>", { desc = "Blame" })
Util.keymap("n", "]h", [[<cmd>Gitsigns next_hunk<cr>]], { desc = "Next hunk" })
Util.keymap("n", "[h", [[<cmd>Gitsigns prev_hunk<cr>]], { desc = "Prev hunk" })

-- tmux
Util.keymap("n", "<M-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Tmux Navigate Left" })
Util.keymap("n", "<M-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Tmux Navigate Down" })
Util.keymap("n", "<M-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Tmux Navigate Up" })
Util.keymap("n", "<M-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Tmux Navigate Right" })
