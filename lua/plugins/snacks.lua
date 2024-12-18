local logo = [[ neobim ]]

return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        lazygit = { enabled = false },
        terminal = { enabled = false },
        animate = { enabled = false },
        dim = { enabled = false },
        zen = { enabled = false },
        dashboard = { enabled = false, preset = { header = logo } },
    },
}
