return {
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "css-lsp",
                "cssmodules-language-server",
                "css-variables-language-server",
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                cssmodules_ls = {
                    enabled = true,
                },
                css_variables = {
                    enabled = true,
                },
                cssls = {
                    enabled = true,
                },
            },
        },
    },
}
