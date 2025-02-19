_G.Util = {}
_G.keymap = function(mode, keys, cmd, opts)
    opts = opts or {}
    if opts.silent == nil then opts.silent = true end
    vim.keymap.set(mode, keys, cmd, opts)
end

local function escape_wildcards(path) return path:gsub("([%[%]%?%*])", "\\%1") end

local function search_ancestors(startpath, func)
    vim.validate("func", func, "function")
    if func(startpath) then return startpath end
    local guard = 100
    for path in vim.fs.parents(startpath) do
        -- Prevent infinite recursion if our algorithm breaks
        guard = guard - 1
        if guard == 0 then return end

        if func(path) then return path end
    end
end

local function strip_archive_subpath(path)
    -- Matches regex from zip.vim / tar.vim
    path = vim.fn.substitute(path, "zipfile://\\(.\\{-}\\)::[^\\\\].*$", "\\1", "")
    path = vim.fn.substitute(path, "tarfile:\\(.\\{-}\\)::.*$", "\\1", "")
    return path
end

_G.Util.root_pattern = function(...)
    local patterns = vim.iter({ ... }):flatten(math.huge):totable()
    return function(startpath)
        startpath = strip_archive_subpath(startpath)
        for _, pattern in ipairs(patterns) do
            local match = search_ancestors(startpath, function(path)
                for _, p in ipairs(vim.fn.glob(table.concat({ escape_wildcards(path), pattern }, "/"), true, true)) do
                    if vim.loop.fs_stat(p) then return path end
                end
            end)

            if match ~= nil then return match end
        end
    end
end

_G.Util.is_descendant = function(root, path)
    if not path then return false end

    -- Normalize paths to remove any '..' or '.'
    root = vim.fs.normalize(root)
    path = vim.fs.normalize(path)

    -- Check if path starts with root
    return vim.startswith(path, root)
end

_G.Util.insert_package_json = function(config_files, field, fname)
    local path = vim.fn.fnamemodify(fname, ":h")
    local root_with_package = vim.fs.dirname(vim.fs.find("package.json", { path = path, upward = true })[1])

    if root_with_package then
        local path_sep = "/"
        for line in io.lines(root_with_package .. path_sep .. "package.json") do
            if line:find(field) then
                config_files[#config_files + 1] = "package.json"
                break
            end
        end
    end
    return config_files
end

_G.Util.get_active_client_by_name = function(bufnr, servername)
    return vim.lsp.get_clients({
        bufnr = bufnr,
        name = servername,
    })[1]
end
_G.Util.validate_bufnr = function(bufnr)
    vim.validate("bufnr", bufnr, "number")
    return bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr
end
