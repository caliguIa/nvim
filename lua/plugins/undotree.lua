return {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    opts = {},
    keys = {
        {
            "<leader>U",
            vim.cmd.UndotreeToggle,
            desc = "Toggle undotree",
        },
    },
}
