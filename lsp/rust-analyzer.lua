return {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    single_file_support = true,
    root_markers = { ".git", "Cargo.toml" },
    settings = {
        diagnostics = {
            enable = true,
            experimental = {
                enable = true,
            },
        },
        assist = {
            importEnforceGranularity = true,
            importPrefix = "crate",
        },
        cargo = {
            allFeatures = true,
        },
        checkOnSave = {
            command = "clippy",
        },
    },
    capabilities = {
        experimental = {
            serverStatusNotification = true,
        },
    },
    before_init = function(init_params, config)
        -- See https://github.com/rust-lang/rust-analyzer/blob/eb5da56d839ae0a9e9f50774fa3eb78eb0964550/docs/dev/lsp-extensions.md?plain=1#L26
        if config.settings and config.settings["rust-analyzer"] then
            init_params.initializationOptions = config.settings["rust-analyzer"]
        end
    end,
}
