add({ name = "mini.nvim", checkout = "HEAD" })

now(function()
    local filterout_lua_diagnosing = function(notif_arr)
        local not_diagnosing = function(notif) return not vim.startswith(notif.msg, "lua_ls: Diagnosing") end
        notif_arr = vim.tbl_filter(not_diagnosing, notif_arr)
        return MiniNotify.default_sort(notif_arr)
    end
    require("mini.notify").setup({
        content = { sort = filterout_lua_diagnosing },
        window = { config = { border = "single" } },
    })
    vim.notify = MiniNotify.make_notify()
end)

-- now(function() require("mini.sessions").setup() end)

now(function() require("mini.starter").setup() end)

now(function() require("mini.statusline").setup() end)

now(function()
    require("mini.icons").setup({
        use_file_extension = function(ext, _)
            local suf3, suf4 = ext:sub(-3), ext:sub(-4)
            return suf3 ~= "scm" and suf3 ~= "txt" and suf3 ~= "yml" and suf4 ~= "json" and suf4 ~= "yaml"
        end,
    })
    MiniIcons.mock_nvim_web_devicons()
    later(MiniIcons.tweak_lsp_kind)
end)

later(function() require("mini.extra").setup() end)

later(function()
    local ai = require("mini.ai")
    ai.setup({
        custom_textobjects = {
            B = MiniExtra.gen_ai_spec.buffer(),
            F = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
        },
    })
end)

later(function()
    require("mini.basics").setup({
        options = {
            -- Manage options manually
            basic = false,
        },
        mappings = {
            windows = true,
            move_with_alt = true,
        },
        autocommands = {
            relnum_in_visual_mode = true,
        },
    })
    vim.o.pumblend = 0
    vim.o.winblend = 0
end)

later(function() require("mini.bufremove").setup() end)

later(function()
    local miniclue = require("mini.clue")
  --stylua: ignore
  miniclue.setup({
    clues = {
      Config.leader_group_clues,
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
    },
    triggers = {
      { mode = 'n', keys = '<Leader>' }, -- Leader triggers
      { mode = 'x', keys = '<Leader>' },
      { mode = 'n', keys = [[\]] },      -- mini.basics
      { mode = 'n', keys = '[' },        -- mini.bracketed
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = '[' },
      { mode = 'x', keys = ']' },
      { mode = 'i', keys = '<C-x>' },    -- Built-in completion
      { mode = 'n', keys = 'g' },        -- `g` key
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = "'" },        -- Marks
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      { mode = 'n', keys = '"' },        -- Registers
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' },    -- Window commands
      { mode = 'n', keys = 'z' },        -- `z` key
      { mode = 'x', keys = 'z' },
    },
    window = { config = { border = 'single' } },
  })
end)

later(function() require("mini.comment").setup() end)

later(function()
    require("mini.cursorword").setup()
    vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { bg = "#45475a" })
    vim.api.nvim_set_hl(0, "MiniCursorword", { bg = "#45475a" })
end)

later(function()
    require("mini.diff").setup()
    local function make_operator_rhs(operation)
        return function() return MiniDiff.operator(operation) .. (operation == "yank" and "gh" or "") end
    end

    keymap("n", "ghy", make_operator_rhs("yank"), { expr = true, remap = true, desc = "Copy hunk's reference lines" })
    keymap("n", "ghr", make_operator_rhs("reset"), { expr = true, remap = true, desc = "Reset hunk" })
    keymap("n", "ghs", make_operator_rhs("apply"), { expr = true, remap = true, desc = "Apply hunk" })
    keymap(
        "n",
        "ghp",
        function() return MiniDiff.toggle_overlay() end,
        { expr = true, remap = true, desc = "Toggle diff overlay" }
    )
end)

later(function() require("mini.git").setup() end)

later(function()
    local hipatterns = require("mini.hipatterns")
    local hi_words = MiniExtra.gen_highlighter.words
    hipatterns.setup({
        highlighters = {
            fixme = hi_words({ "FIXME", "Fixme", "fixme" }, "MiniHipatternsFixme"),
            hack = hi_words({ "HACK", "Hack", "hack" }, "MiniHipatternsHack"),
            todo = hi_words({ "TODO", "Todo", "todo" }, "MiniHipatternsTodo"),
            note = hi_words({ "NOTE", "Note", "note" }, "MiniHipatternsNote"),

            hex_color = hipatterns.gen_highlighter.hex_color(),
        },
    })
end)

later(function() require("mini.indentscope").setup() end)

later(function() require("mini.jump").setup() end)

later(function()
    local jump2d = require("mini.jump2d")
    jump2d.setup({
        spotter = jump2d.gen_pattern_spotter("[^%s%p]+"),
        view = { dim = true, n_steps_ahead = 2 },
    })
end)

later(function()
    local map = require("mini.map")
    local gen_integr = map.gen_integration
    local encode_symbols = map.gen_encode_symbols.dot("3x2")
    map.setup({
        symbols = { encode = encode_symbols },
        integrations = { gen_integr.builtin_search(), gen_integr.diff(), gen_integr.diagnostic() },
    })
    vim.keymap.set("n", [[\h]], ":let v:hlsearch = 1 - v:hlsearch<CR>", { desc = "Toggle hlsearch" })
    for _, key in ipairs({ "n", "N", "*" }) do
        vim.keymap.set("n", key, key .. "zv<Cmd>lua MiniMap.refresh({}, { lines = false, scrollbar = false })<CR>")
    end
end)

later(function()
    require("mini.misc").setup({ make_global = { "put", "put_text", "stat_summary", "bench_time" } })
    MiniMisc.setup_auto_root()
    MiniMisc.setup_termbg_sync()
end)

later(function()
    local remap = function(mode, lhs_from, lhs_to)
        local keymap = vim.fn.maparg(lhs_from, mode, false, true)
        local rhs = keymap.callback or keymap.rhs
        if rhs == nil then error("Could not remap from " .. lhs_from .. " to " .. lhs_to) end
        vim.keymap.set(mode, lhs_to, rhs, { desc = keymap.desc })
    end
    remap("n", "gx", "<Leader>ox")
    remap("x", "gx", "<Leader>ox")

    require("mini.operators").setup()
end)

later(function() require("mini.pairs").setup({ modes = { insert = true, command = true } }) end)

later(function() require("mini.splitjoin").setup() end)

later(function() require("mini.surround").setup({ search_method = "cover_or_next" }) end)

-- later(function() require("mini.visits").setup() end)
