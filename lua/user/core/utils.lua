_G.Util = {}

---@param mode string Mode to add mapping to
---@param prefix ?string Optional prefix to add to all keys (e.g., "<leader>")
---@return function Keymap function with consistent signature
local function create_mapper(mode, prefix)
    prefix = prefix or ""

    ---@param keys string Keys to map
    ---@param cmd function|string Function to call
    ---@param desc ?string Keymap description
    ---@param opts ?table Optional opts table
    return function(keys, cmd, desc, opts)
        vim.keymap.set(
            mode,
            (prefix or "") .. keys,
            cmd,
            vim.tbl_extend("force", { desc = desc, silent = true }, opts or {})
        )
    end
end

_G.Util.map = {
    n = create_mapper("n"), -- Normal mode
    nl = create_mapper("n", "<leader>"), -- Normal mode with leader prefix
    i = create_mapper("i"), -- Insert mode
    v = create_mapper("v"), -- Visual mode
    c = create_mapper("c"), -- Command mode
    x = create_mapper("x"), -- Visual block mode
}
