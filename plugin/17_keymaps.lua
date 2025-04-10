local later = MiniDeps.later
local cmd = vim.cmd

local del = vim.keymap.del
local try_del = function(mode, keys) pcall(del, mode, keys) end
try_del("n", "grr")
try_del("n", "gra")
try_del("n", "gri")
try_del("n", "grn")

Util.map.nl("q", "q", "Macros", { remap = true })
Util.map.n("q", "<Nop>", "Disable macros")
Util.map.n("m", "<Nop>", "Disable marks")

Util.map.c("<C-p>", "<Up>", "Previous command")
Util.map.c("<C-n>", "<Down>", "Next command")

Util.map.x('"_x', "Delete character without copying")
Util.map.nl("X", function() cmd("!chmod +x %") end, "Make file executable")

Util.map.n("<C-d>", "<C-d>zz", "Down half-page and center")
Util.map.n("<C-u>", "<C-u>zz", "Up half-page and center")

Util.map.n("<esc>", cmd.noh, "Escape and clear hlsearch")

Util.map.n("n", "'Nn'[v:searchforward].'zv'", "Next Search Result", { expr = true })
Util.map.n("N", "'nN'[v:searchforward].'zv'", "Prev Search Result", { expr = true })

Util.map.i(",", ",<c-g>u", "Comma add undo break-point")
Util.map.i(".", ".<c-g>u", "Period add undo break-point")
Util.map.i(";", ";<c-g>u", "Semi-colon add undo break-point")

Util.map.v("<", "<gv", "Dedent reselect")
Util.map.v(">", ">gv", "Indent reselect")

Util.map.nl("fn", cmd.enew, "New File")

Util.map.nl("wd", "<C-W>c", "Delete Window", { remap = true })
Util.map.nl("w", "<c-w>", "Windows", { remap = true })
Util.map.nl("<tab>d", cmd.tabclose, "Close Tab")

Util.map.nl("co", cmd.copen, "Quickfix List")
Util.map.n("[q", cmd.cprev, "Previous Quickfix")
Util.map.n("]q", cmd.cnext, "Next Quickfix")

Util.map.nl("<tab>]", cmd.tabnext, "Next")
Util.map.nl("<tab>[", cmd.tabprevious, "Previous")
Util.map.nl("<tab>d", cmd.tabclose, "Close current")
Util.map.nl("<tab>o", cmd.tabonly, "Close other")

later(function()
    local function RunVimTest(cmd_name)
        local root = require("lspconfig").util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git")(
            vim.fn.expand("%:p")
        )
        if root then vim.g["test#project_root"] = root end

        cmd(":" .. cmd_name)
    end
    Util.map.nl("tr", function() RunVimTest("TestNearest") end, "Run nearest test")

    Util.map.nl("tf", function() RunVimTest("TestFile") end, "Run all tests in the current file")

    Util.map.nl("ta", function() RunVimTest("TestLast") end, "Run last test again")
end)

Util.map.nl("ba", function() cmd.b("#") end, "Alternate")
Util.map.nl("bd", function() MiniBufremove.delete(vim.api.nvim_get_current_buf()) end, "Delete current")
Util.map.nl("bo", function()
    local current_buf = vim.api.nvim_get_current_buf()
    local all_bufs = vim.api.nvim_list_bufs()

    for _, buf in ipairs(all_bufs) do
        -- Skip the current buffer and non-listed/invalid buffers
        if buf ~= current_buf and vim.fn.buflisted(buf) == 1 and vim.api.nvim_buf_is_valid(buf) then
            MiniBufremove.delete(buf, true) -- Using force=true to skip confirmation
        end
    end
end, "Delete others")

Util.map.nl("fe", function()
    local path = vim.bo.buftype ~= "nofile" and vim.api.nvim_buf_get_name(0) or nil
    MiniFiles.open(path)
end, "File explorer")

Util.map.nl("N", MiniNotify.show_history, "Show notification history")

-- search
Util.map.nl("cs", function() cmd.Pick("spellsuggest") end, "Spelling")
Util.map.nl("sb", function() cmd.Pick("buffers") end, "Buffers")
Util.map.nl("sf", function() cmd.Pick("files") end, "Find Files")
Util.map.nl("sg", function() cmd.Pick("grep_live") end, "Grep")
Util.map.nl("sh", function() cmd.Pick("help") end, "Help Pages")
Util.map.nl("sH", function() cmd.Pick("hl_groups") end, "Highlight groups")
Util.map.nl("sk", function() cmd.Pick("keymaps") end, "Keymaps")
Util.map.nl("sr", function() cmd.Pick("resume") end, "Resume")
Util.map.nl("so", function() cmd.Pick("visit_paths") end, "Recent")

Util.map.nl("wm", MiniMisc.zoom, "Maximise window")

local function goto_marked_file(index)
    local marked = MiniVisits.list_paths(nil, {
        filter = "core",
        sort = function(paths) return paths end,
    })
    if marked[index] then cmd("edit " .. marked[index]) end
end

Util.map.nl("sm", function() cmd.Pick("visit_paths", 'filter="core"') end, "Marked files")
Util.map.n("ma", function() MiniVisits.add_label("core") end, "Add mark")
Util.map.n("md", function() MiniVisits.remove_label("core") end, "Delete mark")
Util.map.n("mq", function() goto_marked_file(1) end, "Goto mark 1")
Util.map.n("mw", function() goto_marked_file(2) end, "Goto mark 2")
Util.map.n("me", function() goto_marked_file(3) end, "Goto mark 3")
Util.map.n("mr", function() goto_marked_file(4) end, "Goto mark 4")

Util.map.nl("u", cmd.UndotreeToggle, "Toggle undotree")

Util.map.nl("la", cmd.ArtisanPicker, "Artisan commands")

later(function() Util.map.nl("do", require("dbee").toggle, "Database") end)

Util.map.nl("gg", cmd.Neogit, "Git")
Util.map.nl("gb", function() cmd.Pick("git_branches") end, "Branches")
Util.map.nl("gB", function() cmd.Gitsigns("blame") end, "Blame")
Util.map.nl("gp", function() cmd.Gitsigns("preview_hunk") end, "Preview hunk")
Util.map.n("]h", function() cmd.Gitsigns("next_hunk") end, "Next hunk")
Util.map.n("[h", function() cmd.Gitsigns("prev_hunk") end, "Prev hunk")

Util.map.n("<M-h>", cmd.TmuxNavigateLeft, "Tmux Navigate Left")
Util.map.n("<M-j>", cmd.TmuxNavigateDown, "Tmux Navigate Down")
Util.map.n("<M-k>", cmd.TmuxNavigateUp, "Tmux Navigate Up")
Util.map.n("<M-l>", cmd.TmuxNavigateRight, "Tmux Navigate Right")

Util.map.nl("ac", cmd.CodeCompanionChat, "AI chat")
