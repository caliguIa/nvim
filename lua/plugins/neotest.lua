return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "olimorris/neotest-phpunit",
        "marilari88/neotest-vitest",
    },
    opts = {
        adapters = {
            ["rustaceanvim.neotest"] = {},
            ["neotest-phpunit"] = {},
            ["neotest-vitest"] = {
                -- vitestCommand = "bunx vitest",
                cwd = function(file)
                    local util = require "neotest-vitest.util"
                    return util.find_node_modules_ancestor(file)
                end,
            },
        },
    },
}
