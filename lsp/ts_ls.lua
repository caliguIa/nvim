local function find_root(patterns)
    return function(cb)
        local bufname = vim.api.nvim_buf_get_name(0)
        local path = vim.fs.dirname(bufname)

        -- Search up the directory tree for the patterns
        while path do
            for _, pattern in ipairs(patterns) do
                local file_path = path .. "/" .. pattern
                if vim.loop.fs_stat(file_path) then
                    cb(path)
                    return
                end
            end

            -- Move up one directory
            local parent = vim.fs.dirname(path)
            if parent == path then break end
            path = parent
        end

        -- If no root found, use the current file's directory
        cb(vim.fs.dirname(bufname))
    end
end

return {
    enabled = false,
    init_options = { hostInfo = "neovim" },
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },
    -- root_dir = Util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
    root_dir = find_root({ "tsconfig.json", "package.json", "jsconfig.json", ".git" }),
    single_file_support = true,
}
