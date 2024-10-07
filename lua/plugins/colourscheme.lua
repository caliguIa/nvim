return {
    {
        'olivercederborg/poimandres.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            local p = require 'poimandres.palette'
            require('poimandres').setup {
                highlight_groups = {
                    LspReferenceText = { bg = p.background1 },
                    LspReferenceRead = { bg = p.background1 },
                    LspReferenceWrite = { bg = p.background1 },
                },
            }
        end,
    },
    {
        'LazyVim/LazyVim',
        opts = {
            colorscheme = 'catppuccin-mocha',
        },
    },
}
