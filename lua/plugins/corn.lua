local icons = LazyVim.config.icons.diagnostics

return {
    'RaafatTurki/corn.nvim',
    cmd = 'Corn',
    event = 'LspAttach',
    opts = {
        icons = {
            error = icons.Error,
            warn = icons.Warn,
            hint = icons.Hint,
            info = icons.Info,
        },
        item_preprocess_func = function(item) return item end,
    },
    keys = {
        {
            'n',
            '<leader>E',
            '<cmd>lua require("corn").toggle()<CR>',
            { noremap = true, silent = true, desc = '[E]rrors [t]oggle' },
        },
    },
}
