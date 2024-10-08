return {
    {
        'rcarriga/nvim-notify',
        opts = {
            stages = 'static',
            render = 'wrapped-compact',
        },
    },
    {
        'echasnovski/mini.notify',
        version = false,
        opts = {
            lsp_progress = {
                enable = true,
            },
        },
    },
}
