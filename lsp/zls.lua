vim.g.zig_fmt_parse_errors = 0
vim.g.zig_fmt_autosave = 0

return {
    cmd = { "zls" },
    -- root_dir = find_root_pattern({ "zls.json", "build.zig", ".git" }),
    root_markers = { "zls.json", "build.zig", ".git" },
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
