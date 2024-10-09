return {
    {
        "rcarriga/nvim-notify",
        opts = {
            stages = "static",
            render = "wrapped-compact",
        },
    },
    {
        "echasnovski/mini.notify",
        version = false,
        opts = function() vim.notify = require("mini.notify").make_notify() end,
    },
}
