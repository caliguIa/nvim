-- --- Don't create a comment string when hitting <Enter> on a comment line
vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("DisableNewLineAutoCommentString", {}),
    callback = function() vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" } end,
})
-- Disable corn errors when in insert mode
-- vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
--     group = vim.api.nvim_create_augroup("DisableCornInsert", {}),
--     callback = function() require("corn").toggle() end,
-- })
