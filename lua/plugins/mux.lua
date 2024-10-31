return {
    {
        "mrjones2014/smart-splits.nvim",
        lazy = false,
        opts = {},
        keys = {
            { "<A-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move to left pane" },
            { "<A-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move to bottom pane" },
            { "<A-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move to top pane" },
            { "<A-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move to right pane" },
            { "<A-\\>", function() require("smart-splits").move_cursor_previous() end, desc = "Move to previous pane" },
        },
    },
}
