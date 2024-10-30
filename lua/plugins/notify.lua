return {
    {
        "echasnovski/mini.notify",
        version = false,
        opts = function() vim.notify = require("mini.notify").make_notify() end,
    },
}
