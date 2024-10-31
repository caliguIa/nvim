return {
    "lewis6991/gitsigns.nvim",
    opts = {
        current_line_blame = false,
        current_line_blame_opts = {
            ignore_whitespace = true,
        },
        signcolumn = false,
        linehl = false,
        numhl = true,
        word_diff = false,
        sign_priority = 9,
        watch_gitdir = {
            interval = 1000,
        },
        attach_to_untracked = false,
    },
}
