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

-- Move Lines
keymap("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
keymap("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
keymap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
keymap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
keymap("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
keymap("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

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
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
keymap({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
keymap({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Quickfix list
keymap("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
keymap("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
keymap("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- tabs
keymap("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next" })
keymap("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous" })
keymap("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close current" })
keymap("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close other" })
