local keymap = vim.keymap

-- Remove default keymaps
keymap.del('n', 'g%')
keymap.del('n', '<leader>K')
keymap.del('n', '<leader>L')
keymap.del('n', '<leader>`')
keymap.del('n', '<leader>ft')

keymap.set('n', '<leader>X', '<cmd>!chmod +x %<CR>', { desc = 'Make file executable' })

keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line down' })
keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line up' })

keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'move [d]own half-page and center' })
keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'move [u]p half-page and center' })
keymap.set('n', '<C-f>', '<C-f>zz', { desc = 'move DOWN [f]ull-page and center' })
keymap.set('n', '<C-b>', '<C-b>zz', { desc = 'move UP full-page and center' })

keymap.set('n', '<leader>e', function()
    local _, winid = vim.diagnostic.open_float(nil, {})
    if not winid then return end
    vim.api.nvim_win_set_config(winid or 0, { focusable = true })
end, { noremap = true, silent = true, desc = 'Diagnostics' })

keymap.set('n', '<leader>ft', function() LazyVim.terminal() end, { desc = 'Terminal' })
