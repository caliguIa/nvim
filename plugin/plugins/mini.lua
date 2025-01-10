local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

add({ name = "mini.nvim", checkout = "HEAD" })

now(
    function()
        require("mini.basics").setup({
            options = { basic = false },
            mappings = { windows = true, move_with_alt = true },
            autocommands = { relnum_in_visual_mode = true },
        })
    end
)

now(function()
    local not_lua_diagnosing = function(notif) return not vim.startswith(notif.msg, "lua_ls: Diagnosing") end
    local filterout_lua_diagnosing = function(notif_arr)
        return MiniNotify.default_sort(vim.tbl_filter(not_lua_diagnosing, notif_arr))
    end
    require("mini.notify").setup({
        content = { sort = filterout_lua_diagnosing },
        window = { config = { border = "none" } },
    })
    vim.notify = MiniNotify.make_notify()
    keymap("n", "<leader>nh", MiniNotify.show_history, { desc = "Show notification history" })
end)

now(function()
    require("mini.starter").setup({
        evaluate_single = true,
        footer = "",
    })
end)

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
        n_lines = 500,
        custom_textobjects = {
            B = MiniExtra.gen_ai_spec.buffer(),
            o = ai.gen_spec.treesitter({ -- code block
                a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                i = { "@block.inner", "@conditional.inner", "@loop.inner" },
            }),
            f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
            c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
            t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
            d = { "%f[%d]%d+" }, -- digits
            e = { -- Word with case
                { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
                "^().*()$",
            },
            u = ai.gen_spec.function_call(), -- u for "Usage"
            U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
    })
end)

later(function()
    require("mini.bufremove").setup()

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
end)

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
    window = { config = { border = 'none' } },
  })
end)

later(function() require("mini.cursorword").setup() end)

later(function()
    require("mini.diff").setup()
    local function make_operator_rhs(operation)
        return function() return MiniDiff.operator(operation) .. (operation == "yank" and "gh" or "") end
    end

    keymap(
        "n",
        "<leader>ghy",
        make_operator_rhs("yank"),
        { expr = true, remap = true, desc = "Copy hunk's reference lines" }
    )
    keymap("n", "<leader>ghr", make_operator_rhs("reset"), { expr = true, remap = true, desc = "Reset hunk" })
    keymap("n", "<leader>ghs", make_operator_rhs("apply"), { expr = true, remap = true, desc = "Apply hunk" })
    keymap(
        "n",
        "<leader>go",
        function() return MiniDiff.toggle_overlay(0) end,
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

later(function()
    require("mini.indentscope").setup({ symbol = "│", options = { try_as_border = true } })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = {
            "Trouble",
            "alpha",
            "dashboard",
            "fzf",
            "help",
            "notify",
            "trouble",
        },
        callback = function() vim.b.miniindentscope_disable = true end,
    })
end)

later(function() require("mini.jump").setup() end)

later(function()
    local jump2d = require("mini.jump2d")
    jump2d.setup({
        labels = "abcdefhijklmnopqrstuvwxyz",
        allowed_lines = { blank = false },
        view = { dim = true, n_steps_ahead = 2 },
    })
end)

later(function()
    require("mini.misc").setup({ make_global = { "put", "put_text", "stat_summary", "bench_time" } })
    MiniMisc.setup_auto_root()
    MiniMisc.setup_termbg_sync()
    MiniMisc.setup_restore_cursor()
end)

later(
    function()
        require("mini.pairs").setup({
            modes = { insert = true, command = true, terminal = false },
            skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
            skip_ts = { "string" },
            skip_unbalanced = true,
            markdown = true,
        })
    end
)

later(function() require("mini.surround").setup({ search_method = "cover_or_next" }) end)
