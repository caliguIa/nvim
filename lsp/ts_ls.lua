return {
    enabled = false,
    root_dir = find_root_pattern({ "tsconfig.json", "package.json", "jsconfig.json", ".git" }),
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
    single_file_support = true,
}
