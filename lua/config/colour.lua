require("e-ink").setup()

vim.cmd.colorscheme("e-ink")
vim.opt.background = "light"

local C = require("e-ink.palette").everforest()
local function highlight(group, opts) vim.api.nvim_set_hl(0, group, opts) end
highlight("DiagnosticUnderlineError", { sp = C.red, undercurl = true })
highlight("DiagnosticUnderlineWarn", { sp = C.yellow, undercurl = true })
highlight("DiagnosticUnderlineInfo", { sp = C.blue, undercurl = true })
highlight("DiagnosticUnderlineHint", { sp = C.blue, undercurl = true })

-- vim.cmd.colorscheme("llanura")
