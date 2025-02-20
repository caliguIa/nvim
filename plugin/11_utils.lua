_G.Util = {}

_G.keymap = function(mode, keys, cmd, opts)
    opts = opts or {}
    if opts.silent == nil then opts.silent = true end
    vim.keymap.set(mode, keys, cmd, opts)
end

_G.find_root_pattern = function(patterns)
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
