local later = MiniDeps.later

vim.keymap.del("n", "grr")
vim.keymap.del("n", "gra")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grn")

-- Better command history navigation
Util.map("c", "<C-p>", "<Up>")
Util.map("c", "<C-n>", "<Down>")

Util.map("n", "q", "<Nop>", { desc = "Disable macro recording because I do not use it" })
Util.map("n", "m", "<Nop>", { desc = "Disable marks because I do not use them" })
Util.map("n", "x", '"_x', { desc = "Delete character without copying" })
Util.map("n", "<leader>X", "<cmd>!chmod +x %<CR>", { desc = "Make file executable" })

Util.map("n", "<C-d>", "<C-d>zz", { desc = "move [d]own half-page and center" })
Util.map("n", "<C-u>", "<C-u>zz", { desc = "move [u]p half-page and center" })

Util.map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Buffers
Util.map("n", "<leader>ba", "<Cmd>b#<CR>", { desc = "Alternate" })

-- Search
Util.map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
Util.map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
Util.map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
Util.map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
Util.map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
Util.map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Add undo break-points
Util.map("i", ",", ",<c-g>u")
Util.map("i", ".", ".<c-g>u")
Util.map("i", ";", ";<c-g>u")

-- better indenting
Util.map("v", "<", "<gv")
Util.map("v", ">", ">gv")

-- new file
Util.map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- windows
Util.map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
Util.map("n", "<leader>w", "<c-w>", { desc = "Windows", remap = true })
Util.map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })

-- better up/down
Util.map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
Util.map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
Util.map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
Util.map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Quickfix list
Util.map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
Util.map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
Util.map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- tabs
Util.map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next" })
Util.map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous" })
Util.map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close current" })
Util.map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close other" })

later(function()
    local function RunVimTest(cmd_name)
        local root = require("lspconfig").util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git")(
            vim.fn.expand("%:p")
        )
        if root then vim.g["test#project_root"] = root end

        vim.cmd(":" .. cmd_name)
    end
    Util.map("n", "<leader>tr", function() RunVimTest("TestNearest") end, { desc = "Run nearest test" })

    Util.map("n", "<leader>tf", function() RunVimTest("TestFile") end, { desc = "Run all tests in the current file" })

    Util.map("n", "<leader>ta", function() RunVimTest("TestLast") end, { desc = "Run last test again" })
end)

-- mini
Util.map("n", "<Leader>fe", function()
    local path = vim.bo.buftype ~= "nofile" and vim.api.nvim_buf_get_name(0) or nil
    MiniFiles.open(path)
end, { desc = "File explorer" })
Util.map("n", "<leader>nh", MiniNotify.show_history, { desc = "Show notification history" })
Util.map("n", "<leader>bd", "<Cmd>lua MiniBufremove.delete()<CR>", { desc = "Delete current" })
Util.map("n", "<leader>bo", function()
    local current_buf = vim.api.nvim_get_current_buf()
    local all_bufs = vim.api.nvim_list_bufs()

    for _, buf in ipairs(all_bufs) do
        -- Skip the current buffer and non-listed/invalid buffers
        if buf ~= current_buf and vim.fn.buflisted(buf) == 1 and vim.api.nvim_buf_is_valid(buf) then
            MiniBufremove.delete(buf, true) -- Using force=true to skip confirmation
        end
    end
end, { desc = "Delete others" })
-- search
Util.map("n", "<leader>cs", [[<cmd>Pick spellsuggest<cr>]], { desc = "Spelling" })
Util.map("n", "<leader>sb", [[<cmd>Pick buffers<cr>]], { desc = "Buffers" })
Util.map("n", "<leader>sf", [[<cmd>Pick files<cr>]], { desc = "Find Files" })
Util.map("n", "<leader>sg", [[<cmd>Pick grep_live<cr>]], { desc = "Grep" })
Util.map("n", "<leader>sh", [[<cmd>Pick help<cr>]], { desc = "Help Pages" })
Util.map("n", "<leader>sH", [[<cmd>Pick hl_groups<cr>]], { desc = "Highlight groups" })
Util.map("n", "<leader>sk", [[<cmd>Pick keymaps<cr>]], { desc = "Keymaps" })
Util.map("n", "<leader>sr", [[<cmd>Pick resume<cr>]], { desc = "Resume" })
Util.map("n", "<leader>so", [[<cmd>Pick visit_paths<cr>]], { desc = "Recent" })

Util.map("n", "<leader>wm", [[<cmd>lua MiniMisc.zoom()<cr>]], { desc = "Maximise window" })

local function goto_marked_file(index)
    local marked = MiniVisits.list_paths(nil, {
        filter = "core",
        sort = function(paths) return paths end,
    })
    if marked[index] then vim.cmd("edit " .. marked[index]) end
end

Util.map("n", "<leader>sm", [[<cmd>Pick visit_paths filter='core'<cr>]], { desc = "Marked files" })
Util.map("n", "<leader>ma", [[<cmd>lua MiniVisits.add_label("core")<CR>]], { desc = "Add mark" })
Util.map("n", "<leader>md", [[<cmd>lua MiniVisits.remove_label("core")<CR>]], { desc = "Delete mark" })
Util.map("n", "mq", function() goto_marked_file(1) end, { desc = "Goto mark 1" })
Util.map("n", "mw", function() goto_marked_file(2) end, { desc = "Goto mark 2" })
Util.map("n", "me", function() goto_marked_file(3) end, { desc = "Goto mark 3" })
Util.map("n", "mr", function() goto_marked_file(4) end, { desc = "Goto mark 4" })

-- undotree
Util.map("n", "<leader>U", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })

-- php
Util.map("n", "<leader>la", vim.cmd.ArtisanPicker, { desc = "Artisan commands" })

later(function()
    Util.map("n", "<leader>do", require("dbee").toggle, { desc = "Database" })
    Util.map("n", "<leader>de", function()
        local file_path = os.getenv("HOME") .. "/tmp/query_csv"
        local file_name = os.date("%Y%m%d_%H%M%S") .. ".csv"
        local full_path = file_path .. "/" .. file_name

        local dir_success = os.execute("mkdir -p " .. file_path)
        if not dir_success then
            vim.notify("Failed to create directory: " .. file_path, vim.log.levels.ERROR)
            return
        end
        local file = io.open(full_path, "w")
        if not file then
            vim.notify("Failed to create file: " .. full_path, vim.log.levels.ERROR)
            return
        end
        if file then file:close() end

        local success, err = pcall(function() require("dbee").store("csv", "file", { extra_arg = full_path }) end)

        if success then
            vim.notify("Successfully exported to: " .. full_path, vim.log.levels.INFO)
        else
            vim.notify("Failed to export: " .. tostring(err), vim.log.levels.ERROR)
        end
    end, { desc = "Database" })
end)

-- git
Util.map("n", "<leader>ghp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview hunk" })
Util.map("n", "<leader>ghi", "<cmd>Gitsigns preview_hunk_inline<cr>", { desc = "Preview hunk inline" })
Util.map("n", "<leader>gb", "<cmd>Gitsigns blame<cr>", { desc = "Blame" })
Util.map("n", "]h", [[<cmd>Gitsigns next_hunk<cr>]], { desc = "Next hunk" })
Util.map("n", "[h", [[<cmd>Gitsigns prev_hunk<cr>]], { desc = "Prev hunk" })

-- tmux
Util.map("n", "<M-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Tmux Navigate Left" })
Util.map("n", "<M-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Tmux Navigate Down" })
Util.map("n", "<M-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Tmux Navigate Up" })
Util.map("n", "<M-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Tmux Navigate Right" })
