local later = MiniDeps.now

later(function()
    require("zendiagram").setup()
    require("hanzel").setup()
end)
