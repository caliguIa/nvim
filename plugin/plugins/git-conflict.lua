local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add({ source = "akinsho/git-conflict.nvim", checkout = "v2.1.0" })
    ---@diagnostic disable-next-line: missing-parameter
    require("git-conflict").setup()
end)
