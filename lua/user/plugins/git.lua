local cmd = vim.cmd

require("git-conflict").setup()
require("neogit").setup()
require("gitsigns").setup({
    signs_staged_enable = false,
    signcolumn = false,
    numhl = true,
})

Util.map.nl("gg", cmd.Neogit, "Git")
Util.map.nl("gB", function() cmd.Gitsigns("blame") end, "Blame")
Util.map.nl("gp", function() cmd.Gitsigns("preview_hunk") end, "Preview hunk")
Util.map.n("]h", function() cmd.Gitsigns("next_hunk") end, "Next hunk")
Util.map.n("[h", function() cmd.Gitsigns("prev_hunk") end, "Prev hunk")
