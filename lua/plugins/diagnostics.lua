-- local icons = LazyVim.config.icons.diagnostics

return {
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "LspAttach",
        opts = {},
    },
}
