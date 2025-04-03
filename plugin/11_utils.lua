_G.Util = {}

function Util.keymap(mode, keys, cmd, opts)
    opts = opts or {}
    if opts.silent == nil then opts.silent = true end
    vim.keymap.set(mode, keys, cmd, opts)
end
