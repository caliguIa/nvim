return {
    {
        "aktersnurra/no-clown-fiesta.nvim",
        opts = {
            transparent = false, -- Enable this to disable the bg color
            styles = {
                lsp = {
                    undercurl = true,
                },
            },
        },
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "no-clown-fiesta",
        },
    },
}
