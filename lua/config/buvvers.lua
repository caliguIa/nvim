require("buvvers").setup({
    buffer_handle_list_to_buffer_name_list = function(handle_l)
        local name_l

        local default_function = require("buvvers.buffer_handle_list_to_buffer_name_list")
        name_l = default_function(handle_l)

        for n, name in ipairs(name_l) do
            local icon, hl = MiniIcons.get("file", name)
            name_l[n] = {
                { icon .. " ", hl },
                name,
            }
        end

        return name_l
    end,
})

Util.map.nl("be", require("buvvers").toggle)

Util.au.cmd("User", {
    group = Util.au.group("buvvers_config", { clear = true }),
    pattern = "BuvversBufEnabled",
    callback = function()
        local opts = { buffer = require("buvvers").buvvers_get_buf(), nowait = true }

        Util.map.n("q", require("buvvers").close, "Close window", {
            buffer = require("buvvers").buvvers_get_buf(),
            nowait = true,
        })

        Util.map.n("d", function()
            local cursor_buf_handle = require("buvvers").buvvers_buf_get_buf(vim.fn.line("."))
            MiniBufremove.delete(cursor_buf_handle, false)
        end, "Delete buffer", opts)

        Util.map.n("o", function()
            local cursor_buf_handle = require("buvvers").buvvers_buf_get_buf(vim.fn.line("."))
            local previous_win_handle = vim.fn.win_getid(vim.fn.winnr("#"))
            vim.api.nvim_win_set_buf(previous_win_handle, cursor_buf_handle)
            vim.api.nvim_set_current_win(previous_win_handle)
        end, "Open buffer", opts)
    end,
})
