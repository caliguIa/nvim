local ft = require("guard.filetype")
ft("lua"):fmt("stylua")
ft("nix"):fmt("nixfmt")
ft("rust"):fmt("rustfmt")
ft("typescript,javascript,typescriptreact,javascriptreact,css,html,json,jsonc,markdown,scss,vue,yaml"):fmt("prettierd")
ft("sql"):fmt({ cmd = "sleek", stdin = true })
ft("php"):fmt({
    cmd = "vendor/bin/pint",
    args = { "--dirty" },
    fname = true,
    stdin = false,
})
