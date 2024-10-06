local logo = [[ neobim ]]

return {
    'nvimdev/dashboard-nvim',
    opts = {
        config = {
            header = vim.split(string.rep('\n', 8) .. logo .. '\n\n', '\n'),
        },
    },
}
