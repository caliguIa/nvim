-- local cmp = require 'cmp'

return {
    {
        'hrsh7th/nvim-cmp',
        enabled = false,
        -- opts = {
        --     completion = {
        --         completeopt = 'menu,menuone,noinsert,noselect',
        --     },
        --     preselect = false,
        --     mapping = cmp.mapping.preset.insert {
        --         ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        --         ['<C-f>'] = cmp.mapping.scroll_docs(4),
        --         ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
        --         ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
        --         ['<C-Space>'] = cmp.mapping.complete(),
        --         ['<C-a>'] = LazyVim.cmp.confirm { select = true },
        --         ['<C-y>'] = LazyVim.cmp.confirm { select = true },
        --         ['<CR>'] = LazyVim.cmp.confirm { select = false },
        --         ['<S-CR>'] = LazyVim.cmp.confirm { behavior = cmp.ConfirmBehavior.Replace }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        --         ['<C-CR>'] = function(fallback)
        --             cmp.abort()
        --             fallback()
        --         end,
        --     },
        --     experimental = {
        --         native_menu = false,
        --         ghost_text = false,
        --     },
        -- },
    },
    {
        'saghen/blink.cmp',
        lazy = false, -- lazy loading handled internally
        dependencies = 'rafamadriz/friendly-snippets',
        version = 'v0.*',
        opts = {
            highlight = { use_nvim_cmp_as_default = true },
            nerd_font_variant = 'normal',
            accept = { auto_brackets = { enabled = true } },
            trigger = { signature_help = { enabled = false, show_on_insert_on_trigger_character = false } },
            keymap = {
                accept = '<C-a>',
                select_prev = { '<Up>', '<C-k>', '<C-p>' },
                select_next = { '<Down>', '<C-j>', '<C-n>' },
            },
        },
    },
}
