local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

add({ name = "mini.nvim", checkout = "HEAD" })

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
end)

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

now(function()
    require("mini.misc").setup()
    MiniMisc.setup_auto_root()
    MiniMisc.setup_restore_cursor()
end)

now(
    function()
        require("mini.files").setup({
            mappings = {
                go_in = "",
                go_in_plus = "<CR>",
                go_out = "",
                go_out_plus = "-",
            },
        })
    end
)

later(function() require("mini.extra").setup() end)
later(function() require("mini.visits").setup() end)
later(function()
    require("mini.pick").setup()
    vim.ui.select = MiniPick.ui_select
end)
later(function() require("mini.bufremove").setup() end)
later(function() require("mini.surround").setup() end)
later(
    function()
        require("mini.indentscope").setup({
            symbol = "│",
            draw = { animation = require("mini.indentscope").gen_animation.none() },
            options = {
                border = "both",
                try_as_border = true,
            },
        })
    end
)

later(function()
    local statusline = require("mini.statusline")
    statusline.setup({
        content = {
            active = function()
                local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
                local git = MiniStatusline.section_git({ trunc_width = 40 })
                local diff = MiniStatusline.section_diff({ trunc_width = 75 })
                local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
                local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
                local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
                local location = MiniStatusline.section_location({ trunc_width = 75 })
                local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

                return MiniStatusline.combine_groups({
                    { hl = mode_hl, strings = { mode } },
                    { hl = "MiniStatuslineDevinfo", strings = { git, diff } },
                    "%<", -- Mark general truncate point
                    { hl = "MiniStatuslineDevinfo", strings = { diagnostics } },
                    "%=", -- End left alignment
                    { hl = "MiniStatuslineDevinfo", strings = { lsp } },
                    { hl = "MiniStatuslineDevinfo", strings = { fileinfo } },
                    { hl = mode_hl, strings = { search, location } },
                })
            end,
            inactive = function()
                return MiniStatusline.combine_groups({
                    { hl = "MiniStatuslineDevinfo", strings = { "" } },
                })
            end,
        },
    })

    statusline.section_fileinfo = function() return vim.bo.filetype end
    statusline.section_location = function() return "%p%% %L" end
end)

later(function()
    local ai = require("mini.ai")
    ai.setup({
        n_lines = 500,
        custom_textobjects = {
            B = MiniExtra.gen_ai_spec.buffer(),
            f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
            c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
            F = ai.gen_spec.function_call(),
        },
    })
end)

later(function()
    local miniclue = require("mini.clue")
    miniclue.setup({
        clues = {
            {
                { mode = "n", keys = "<Leader>a", desc = "+AI" },
                { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
                { mode = "n", keys = "<Leader>c", desc = "+Code" },
                { mode = "n", keys = "<Leader>d", desc = "+DB" },
                { mode = "n", keys = "<Leader>f", desc = "+File" },
                { mode = "n", keys = "<Leader>g", desc = "+Git" },
                { mode = "n", keys = "<Leader>l", desc = "+Laravel" },
                { mode = "n", keys = "m", desc = "+Marks" },
                { mode = "n", keys = "<Leader>r", desc = "+Rename" },
                { mode = "n", keys = "<Leader>s", desc = "+Search" },
                { mode = "n", keys = "<Leader>t", desc = "+Test" },
                { mode = "n", keys = "<Leader>w", desc = "+Window" },
                { mode = "n", keys = "<Leader><tab>", desc = "+Tabs" },
            },
            miniclue.gen_clues.builtin_completion(),
            miniclue.gen_clues.g(),
            miniclue.gen_clues.windows({ submode_resize = true }),
            miniclue.gen_clues.z(),
        },
        triggers = {
            { mode = "n", keys = "<Leader>" }, -- Leader triggers
            { mode = "x", keys = "<Leader>" },
            { mode = "n", keys = [[\]] }, -- mini.basics
            { mode = "n", keys = "[" }, -- mini.bracketed
            { mode = "n", keys = "]" },
            { mode = "n", keys = "g" }, -- `g` key
            { mode = "n", keys = "s" }, -- mini.surround
            { mode = "v", keys = "s" }, -- mini.surround
            { mode = "n", keys = "w" }, -- mini.windows
            { mode = "n", keys = "<C-w>" }, -- Window commands
            { mode = "n", keys = "z" }, -- `z` key
        },
        window = { config = { border = "none" } },
    })
end)

later(
    function()
        require("mini.pairs").setup({
            modes = { insert = true, command = false, terminal = false },
            skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
            skip_ts = { "string" },
            skip_unbalanced = true,
            markdown = true,
            mappings = {
                [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
                ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
                ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
                [">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },
                ["("] = { action = "open", pair = "()", neigh_pattern = ".[%s%z%)]", register = { cr = false } },
                ["["] = { action = "open", pair = "[]", neigh_pattern = ".[%s%z%)}%]]", register = { cr = false } },
                ["{"] = { action = "open", pair = "{}", neigh_pattern = ".[%s%z%)}%]]", register = { cr = false } },
                ["<"] = { action = "open", pair = "<>", neigh_pattern = ".[%s%z%)}%]]", register = { cr = false } },
                ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^%w\\][^%w]", register = { cr = false } },
                ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%w\\][^%w]", register = { cr = false } },
                ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^%w\\][^%w]", register = { cr = false } },
            },
        })
    end
)
