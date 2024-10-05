return {
    "lewis6991/gitsigns.nvim",
    opts = {
        current_line_blame = false,
        current_line_blame_opts = {
            ignore_whitespace = true,
        },
        signcolumn = false, -- Toggle with `:Gitsigns toggle_signs`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        numhl = true, -- Toggle with `:Gitsigns toggle_nunhl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        sign_priority = 9,
        watch_gitdir = {
            interval = 1000,
        },
        attach_to_untracked = false,
    },
}
