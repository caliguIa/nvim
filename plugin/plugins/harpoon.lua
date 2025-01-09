local add, later = MiniDeps.add, MiniDeps.now

later(function()
    add({ source = "ThePrimeagen/harpoon", checkout = "harpoon2", depends = { "nvim-lua/plenary.nvim" } })

    local harpoon = require("harpoon")
    harpoon:setup()

    keymap("n", "ma", function() harpoon:list():add() end, { desc = "Mark Add" })

    keymap(
        "n",
        "<leader>h",
        function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
        { desc = "Harpoon Quick Menu" }
    )

    keymap("n", "mj", function() harpoon:list():select(1) end, { desc = "Jump to Mark 1" })

    keymap("n", "mk", function() harpoon:list():select(2) end, { desc = "Jump to Mark 2" })

    keymap("n", "ml", function() harpoon:list():select(3) end, { desc = "Jump to Mark 3" })

    keymap("n", "m;", function() harpoon:list():select(4) end, { desc = "Jump to Mark 4" })
end)
