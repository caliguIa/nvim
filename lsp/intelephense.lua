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
    cmd = { "intelephense", "--stdio" },
    filetypes = { "php", "blade", "php_only" },
    root_dir = find_root({ "composer.json", ".git" }),
    -- root_dir = Util.root_pattern("composer.json", ".git"),
    -- root_dir = function(pattern)
    --     local cwd = vim.loop.cwd()
    --     local root = Util.root_pattern("composer.json", ".git")(pattern)
    --
    --     -- prefer cwd if root is a descendant
    --     return Util.is_descendant(cwd, root) and cwd or root
    -- end,
    init_options = {
        storagePath = "/tmp/intelephense",
        globalStoragePath = os.getenv("HOME") .. "/.cache/intelephense",
        licenceKey = os.getenv("HOME") .. "/.local/auth/intelephense.txt" or "",
        ["language_server_configuration.auto_config"] = true,
        ["code_transform.import_globals"] = true,
    },
    settings = {
        intelephense = {
            diagnostics = { enable = true },
            filetypes = { "php", "blade", "php_only" },
            format = { enable = false },
            files = {
                associations = { "*.php", "*.blade.php" },
                maxSize = 5000000,
            },
        },
    },
}
