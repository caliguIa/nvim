return {
    'ThePrimeagen/harpoon',
    opts = {},
    keys = function()
        return {
            {
                '<leader>ma',
                function() require('harpoon'):list():add() end,
                desc = 'Mark Add',
            },
            {
                '<leader>h',
                function()
                    local harpoon = require 'harpoon'
                    harpoon.ui:toggle_quick_menu(harpoon:list())
                end,
                desc = 'Harpoon Quick Menu',
            },
            {
                '<leader>mj',
                function()
                    local harpoon = require 'harpoon'
                    harpoon:list():select(1)
                end,
                desc = 'Jump to Mark 1',
            },
            {
                '<leader>mk',
                function()
                    local harpoon = require 'harpoon'
                    harpoon:list():select(2)
                end,
                desc = 'Jump to Mark 2',
            },
            {
                '<leader>ml',
                function()
                    local harpoon = require 'harpoon'
                    harpoon:list():select(3)
                end,
                desc = 'Jump to Mark 3',
            },
            {
                '<leader>m;',
                function()
                    local harpoon = require 'harpoon'
                    harpoon:list():select(4)
                end,
                desc = 'Jump to Mark 4',
            },
        }
    end,
}
