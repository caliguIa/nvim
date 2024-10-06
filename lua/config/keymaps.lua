local set = vim.keymap.set
local delete = vim.keymap.del

delete('n', 'g%')
delete('n', '<leader>K')
delete('n', '<leader>L')
delete('n', '<leader>`')
delete('n', '<leader>ft')

set('n', 'q', '<Nop>', { desc = 'Disable macro recording because I do not use it' })
set('n', 'm', '<Nop>', { desc = 'Disable marks ecause I do not use them' })
set('n', 'x', '"_x', { desc = 'Delete character without copying' })

set('n', '<leader>X', '<cmd>!chmod +x %<CR>', { desc = 'Make file executable' })

set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line down' })
set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line up' })

set('n', '<C-d>', '<C-d>zz', { desc = 'move [d]own half-page and center' })
set('n', '<C-u>', '<C-u>zz', { desc = 'move [u]p half-page and center' })
set('n', '<C-f>', '<C-f>zz', { desc = 'move DOWN [f]ull-page and center' })
set('n', '<C-b>', '<C-b>zz', { desc = 'move UP full-page and center' })

set('n', '<leader>e', function()
    local _, winid = vim.diagnostic.open_float(nil, {})
    if not winid then return end
    vim.api.nvim_win_config(winid or 0, { focusable = true })
end, { noremap = true, silent = true, desc = 'Diagnostics' })

set('n', '<leader>ft', function() LazyVim.terminal() end, { desc = 'Terminal' })
