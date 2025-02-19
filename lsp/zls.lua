vim.g.zig_fmt_parse_errors = 0
vim.g.zig_fmt_autosave = 0

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
    cmd = { "zls" },
    root_dir = find_root({ "zls.json", "build.zig", ".git" }),
    -- root_dir = Util.root_pattern("zls.json", "build.zig", ".git"),
    -- root_dir = function(cb)
    --     local root = Util.root_pattern("zls.json", "build.zig", ".git")(vim.api.nvim_buf_get_name(0))
    --     cb(root)
    -- end,
    filetypes = { "zig", "zir" },
    on_new_config = function(new_config, new_root_dir)
        if vim.fn.filereadable(vim.fs.joinpath(new_root_dir, "zls.json")) ~= 0 then
            new_config.cmd = { "zls", "--config-path", "zls.json" }
        end
    end,
    single_file_support = true,
    settings = {
        zls = {
            enable_inlay_hints = true,
            enable_snippets = true,
            warn_style = true,
        },
    },
}
