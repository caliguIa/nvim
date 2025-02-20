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
    local statusline = require("mini.statusline")

    statusline.setup({
        content = {
            active = function()
                local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
                local git = MiniStatusline.section_git({ trunc_width = 40 })
                local diff = MiniStatusline.section_diff({ trunc_width = 75 })
                local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
                local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
                local filename = MiniStatusline.section_filename({ trunc_width = 140 })
                local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
                local location = MiniStatusline.section_location({ trunc_width = 75 })
                local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

                return MiniStatusline.combine_groups({
                    { hl = mode_hl, strings = { mode } },
                    { hl = "MiniStatuslineDevinfo", strings = { git, diff } },
                    "%<", -- Mark general truncate point
                    { hl = "MiniStatuslineFilename", strings = { diagnostics, filename } },
                    "%=", -- End left alignment
                    { hl = "MiniStatuslineFileinfo", strings = { fileinfo, lsp } },
                    { hl = mode_hl, strings = { search, location } },
                })
            end,
        },
    })
    statusline.section_filename = function() return "%f %m" end

    statusline.section_lsp = function()
        local attached_clients = vim.lsp.get_clients()
        local client_names = {}

        for _, client in pairs(attached_clients) do
            table.insert(client_names, client.name)
        end

        if vim.tbl_count(client_names) == 0 then return "" end

        return string.format("[ %s ]", table.concat(client_names, " | "))
    end

    statusline.section_fileinfo = function()
        local filetype = vim.bo.filetype
        if (filetype == "") or vim.bo.buftype ~= "" then return "" end
        return string.format("%s%%r", filetype)
    end

    statusline.section_location = function() return "[%p%% %L]" end
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

later(function() require("mini.bufremove").setup() end)

later(function()
    local miniclue = require("mini.clue")
    miniclue.setup({
        clues = {
            Config.leader_group_clues,
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

later(function() require("mini.diff").setup() end)

later(function() require("mini.git").setup() end)

later(function()
    require("mini.misc").setup({ make_global = { "put", "put_text", "stat_summary", "bench_time" } })
    MiniMisc.setup_auto_root()
    MiniMisc.setup_termbg_sync()
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
