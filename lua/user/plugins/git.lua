local cmd = vim.cmd

require("git-conflict").setup()
require("neogit").setup()

Util.map.nl("gg", cmd.Neogit, "Git")
