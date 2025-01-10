local add, later = MiniDeps.add, MiniDeps.later

local function plugin_dir(name) return vim.fn.expand("~/dev/nvim-plugins/" .. name) end

later(function()
    add({
        source = plugin_dir("hanzel.nvim"),
        name = "hanzel",
    })
    add({
        source = plugin_dir("zendiagram.nvim"),
        name = "zendiagram",
    })

    require("hanzel").setup()
    require("zendiagram").setup()
end)
