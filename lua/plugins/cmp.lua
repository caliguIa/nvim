local cmp = require 'cmp'

return {
    'hrsh7th/nvim-cmp',
    opts = {
        completion = {
            completeopt = 'menu,menuone,noinsert,noselect',
        },
        preselect = false,
        mapping = cmp.mapping.preset.insert {
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
            ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-a>'] = LazyVim.cmp.confirm { select = true },
            ['<C-y>'] = LazyVim.cmp.confirm { select = true },
            ['<CR>'] = LazyVim.cmp.confirm { select = false },
            ['<S-CR>'] = LazyVim.cmp.confirm { behavior = cmp.ConfirmBehavior.Replace }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            ['<C-CR>'] = function(fallback)
                cmp.abort()
                fallback()
            end,
        },
        experimental = {
            native_menu = false,
            ghost_text = false,
        },
    },
}
