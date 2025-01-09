local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add("MagicDuck/grug-far.nvim")
    require("grug-far").setup({
        headerMaxWidth = 80,
        keymap({ "n", "v" }, "<leader>cr", function()
            local grug = require("grug-far")
            local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
            grug.open({
                transient = true,
                prefills = {
                    filesFilter = ext and ext ~= "" and "*." .. ext or nil,
                },
            })
        end, { desc = "Search and Replace" }),
    })
end)
