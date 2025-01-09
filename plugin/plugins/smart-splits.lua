local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add("mrjones2014/smart-splits.nvim")
    require("smart-splits").setup({
        ignored_buftypes = {
            "nofile",
            "quickfix",
            "prompt",
        },
        ignored_filetypes = { "NvimTree" },
        default_amount = 3,
        at_edge = "wrap",
        float_win_behavior = "previous",
        move_cursor_same_row = false,
        cursor_follows_swapped_bufs = false,
        resize_mode = {
            quit_key = "<ESC>",
            resize_keys = { "h", "j", "k", "l" },
            silent = false,
            hooks = {
                on_enter = nil,
                on_leave = nil,
            },
        },
        ignored_events = {
            "BufEnter",
            "WinEnter",
        },
        multiplexer_integration = nil,
        disable_multiplexer_nav_when_zoomed = true,
        kitty_password = nil,
        log_level = "info",
    })

    keymap("n", "<A-h>", function() require("smart-splits").move_cursor_left() end, { desc = "Move to left pane" })
    keymap("n", "<A-j>", function() require("smart-splits").move_cursor_down() end, { desc = "Move to bottom pane" })
    keymap("n", "<A-k>", function() require("smart-splits").move_cursor_up() end, { desc = "Move to top pane" })
    keymap("n", "<A-l>", function() require("smart-splits").move_cursor_right() end, { desc = "Move to right pane" })
    keymap(
        "n",
        "<A-\\>",
        function() require("smart-splits").move_cursor_previous() end,
        { desc = "Move to previous pane" }
    )
end)
