return {
    cmd = { "intelephense", "--stdio" },
    filetypes = { "php", "blade", "php_only" },
    -- root_dir = find_root_pattern({ "composer.json" }),
    root_markers = { "composer.json" },
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
        php = { completion = { callSnippet = "Replace" } },
    },
    on_attach = function(client) client.server_capabilities.workspaceSymbolProvider = false end,
}
