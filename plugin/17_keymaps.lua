vim.keymap.del("n", "grr")
vim.keymap.del("n", "gra")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grn")

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

-- flash
keymap("n", "<cr>", function() require("flash").jump() end, { desc = "Flash" })
keymap("n", "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
keymap("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })

-- Easy insertion of a trailing ; or , from insert mode.
keymap("i", ";;", "<Esc>A;<Esc>")
keymap("i", ",,", "<Esc>A,<Esc>")

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
keymap(
    "n",
    "<leader>tw",
    function() require("neotest").watch.toggle(vim.fn.expand("%")) end,
    { desc = "Toggle Watch (Neotest)" }
)

keymap("n", "<Leader>fe", function() MiniFiles.open() end, { desc = "File explorer" })

-- search
keymap("n", "<leader>cs", [[<cmd>Pick spellsuggest<cr>]], { desc = "Spelling" })
keymap("n", "<leader>sb", [[<cmd>Pick buffers<cr>]], { desc = "Buffers" })
keymap("n", "<leader>sf", [[<cmd>Pick files<cr>]], { desc = "Find Files" })
keymap("n", "<leader>sg", [[<cmd>Pick grep_live<cr>]], { desc = "Grep" })
keymap("n", "<leader>sh", [[<cmd>Pick help<cr>]], { desc = "Help Pages" })
keymap("n", "<leader>sH", [[<cmd>Pick hl_groups<cr>]], { desc = "Highlight groups" })
keymap("n", "<leader>sk", [[<cmd>Pick keymaps<cr>]], { desc = "Keymaps" })
keymap("n", "<leader>sr", [[<cmd>Pick resume<cr>]], { desc = "Resume" })
keymap("n", "<leader>so", [[<cmd>Pick visit_paths<cr>]], { desc = "Recent" })

local function goto_marked_file(index)
    local marked = MiniVisits.list_paths(nil, {
        filter = "core",
        sort = function(paths) return paths end,
    })
    if marked[index] then vim.cmd("edit " .. marked[index]) end
end

keymap("n", "<leader>sm", [[<cmd>Pick visit_paths filter='core'<cr>]], { desc = "Marked files" })
keymap("n", "<leader>ma", [[<cmd>lua MiniVisits.add_label("core")<CR>]], { desc = "Add mark" })
keymap("n", "<leader>md", [[<cmd>lua MiniVisits.remove_label("core")<CR>]], { desc = "Delete mark" })
keymap("n", "mq", function() goto_marked_file(1) end, { desc = "Goto mark 1" })
keymap("n", "mw", function() goto_marked_file(2) end, { desc = "Goto mark 2" })
keymap("n", "me", function() goto_marked_file(3) end, { desc = "Goto mark 3" })
keymap("n", "mr", function() goto_marked_file(4) end, { desc = "Goto mark 4" })

-- undotree
keymap("n", "<leader>U", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })

--php
keymap("n", "<leader>la", ":Laravel artisan<cr>", { desc = "Laravel artisan" })
keymap("n", "<leader>lsr", ":Laravel routes<cr>", { desc = "Laravel routes" })
keymap("n", "<leader>lsm", ":Laravel related<cr>", { desc = "Laravel related" })

local function get_color(v)
    local color = {}
    for _, c in ipairs({ "fg", "bg" }) do
        if v[c] then
            local name = v[c]
            local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
            local hl_color
            if c == "fg" then
                hl_color = hl and hl.fg
            else
                hl_color = hl and hl.bg
            end
            if hl_color then table.insert(color, string.format("#%06x", hl_color)) end
        end
    end
    if v.bold then table.insert(color, "bold") end
    return color
end

local function create_config()
    local theme = {
        [241] = { fg = "Special" },
        activeBorderColor = { fg = "MatchParen", bold = true },
        cherryPickedCommitBgColor = { fg = "Identifier" },
        cherryPickedCommitFgColor = { fg = "Function" },
        defaultFgColor = { fg = "Normal" },
        inactiveBorderColor = { fg = "FloatBorder" },
        optionsTextColor = { fg = "Function" },
        searchingActiveBorderColor = { fg = "MatchParen", bold = true },
        selectedLineBgColor = { bg = "Visual" },
        unstagedChangesColor = { fg = "DiagnosticError" },
    }

    local theme_colors = {}
    for k, v in pairs(theme) do
        if type(k) == "number" then
            local color = get_color(v)
            pcall(io.write, ("\27]4;%d;%s\7"):format(k, color[1]))
        else
            theme_colors[k] = get_color(v)
        end
    end

    local config = {
        gui = {
            theme = theme_colors,
            nerdFontsVersion = "3",
        },
        os = {
            editPreset = "nvim-remote",
        },
    }

    local function yaml_val(val)
        if type(val) == "boolean" then return tostring(val) end
        return type(val) == "string" and not val:find("^\"'`") and ("%q"):format(val) or val
    end

    local function to_yaml(tbl, indent)
        indent = indent or 0
        local lines = {}
        for k, v in pairs(tbl) do
            table.insert(lines, string.rep(" ", indent) .. k .. (type(v) == "table" and ":" or ": " .. yaml_val(v)))
            if type(v) == "table" then
                if vim.islist(v) then
                    for _, item in ipairs(v) do
                        table.insert(lines, string.rep(" ", indent + 2) .. "- " .. yaml_val(item))
                    end
                else
                    vim.list_extend(lines, to_yaml(v, indent + 2))
                end
            end
        end
        return lines
    end

    local theme_path = vim.fn.stdpath("cache") .. "/lazygit-theme.yml"
    vim.fn.writefile(to_yaml(config), theme_path)
    return theme_path
end

local function lazygit()
    if vim.fn.executable("lazygit") ~= 1 then
        vim.notify("LazyGit is not installed", vim.log.levels.ERROR)
        return
    end

    local theme_path = create_config()
    local out = vim.fn.system({ "lazygit", "-cd" })
    local config_dir = vim.split(vim.split(out, "\n", { plain = true })[1], "\n", { plain = true })[1]

    local config_files = vim.tbl_filter(
        function(v) return v:match("%S") end,
        vim.split(vim.env.LG_CONFIG_FILE or "", ",", { plain = true })
    )

    if #config_files == 0 then config_files[1] = config_dir .. "/config.yml" end
    if not vim.tbl_contains(config_files, theme_path) then table.insert(config_files, theme_path) end
    vim.env.LG_CONFIG_FILE = table.concat(config_files, ",")

    local buf = vim.api.nvim_create_buf(false, true)
    local width = math.floor(vim.o.columns * 0.9)
    local height = math.floor(vim.o.lines * 0.9)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
    })
    vim.api.nvim_set_option_value(
        "winhighlight",
        "Normal:Normal,FloatBorder:FloatBorder",
        { scope = "local", win = win }
    )

    vim.fn.termopen("lazygit", {
        on_exit = function() vim.api.nvim_win_close(win, true) end,
    })
    vim.cmd("startinsert")
end

-- git
keymap("n", "<leader>gg", lazygit, { desc = "LazyGit" })
keymap("n", "<leader>ghp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview hunk" })
keymap("n", "<leader>ghi", "<cmd>Gitsigns preview_hunk_inline<cr>", { desc = "Preview hunk inline" })
keymap("n", "<leader>gb", "<cmd>Gitsigns blame<cr>", { desc = "Blame" })
keymap("n", "]h", [[<cmd>Gitsigns next_hunk<cr>]], { desc = "Next hunk" })
keymap("n", "[h", [[<cmd>Gitsigns prev_hunk<cr>]], { desc = "Prev hunk" })
