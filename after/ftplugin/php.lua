-- local ft = require("guard.filetype")
-- ft("php"):fmt({
--     cmd = "vendor/bin/pint",
--     args = { "--dirty" },
--     fname = true,
--     stdin = false,
-- })

local set = vim.opt_local

set.commentstring = "//%s"
