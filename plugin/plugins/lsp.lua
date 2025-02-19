local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add("folke/lazydev.nvim")
    add("Bilal2453/luvit-meta")
    add({ source = "neovim/nvim-lspconfig", depends = { "saghen/blink.cmp" } })

    require("lazydev").setup({
        runtime = vim.env.VIMRUNTIME,
        integrations = {
            lspconfig = true,
            cmp = true,
            coq = false,
        },
        enabled = function() return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled end,
        debug = false,
        library = {
            { path = "luvit-meta/library", words = { "vim%.uv" } },
        },
    })

    local lspconfig = require("lspconfig")
    local base_capabilities = vim.lsp.protocol.make_client_capabilities()

    local clients = {
        lua_ls = {
            settings = {
                Lua = {
                    workspace = {
                        checkThirdParty = false,
                    },
                    codeLens = {
                        enable = false,
                    },
                    completion = {
                        callSnippet = "Replace",
                    },
                    doc = {
                        privateName = { "^_" },
                    },
                    hint = {
                        enable = false,
                        setType = false,
                        paramType = false,
                        paramName = "Disable",
                        semicolon = "Disable",
                        arrayIndex = "Disable",
                    },
                },
            },
        },
        intelephense = {
            enabled = true,
            init_options = {
                storagePath = "/tmp/intelephense",
                globalStoragePath = os.getenv("HOME") .. "/.cache/intelephense",
                licenceKey = os.getenv("HOME") .. "/.local/auth/intelephense.txt" or "",
                ["language_server_configuration.auto_config"] = true,
                ["code_transform.import_globals"] = true,
            },
            filetypes = { "php", "blade", "php_only" },
            settings = {
                intelephense = {
                    diagnostics = {
                        enable = true,
                    },
                    filetypes = { "php", "blade", "php_only" },
                    format = { enable = false },
                    files = {
                        associations = { "*.php", "*.blade.php" },
                        maxSize = 5000000,
                    },
                },
            },
        },
        ts_ls = { enabled = false },
        denols = {
            root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
            init_options = {
                enable = true,
                lint = true,
                unstable = true,
            },
        },
        vtsls = {
            filetypes = {
                "javascript",
                "javascriptreact",
                "javascript.jsx",
                "typescript",
                "typescriptreact",
                "typescript.tsx",
            },
            settings = {
                complete_function_calls = true,
                vtsls = {
                    enableMoveToFileCodeAction = true,
                    autoUseWorkspaceTsdk = true,
                    experimental = {
                        maxInlayHintLength = 30,
                        completion = {
                            enableServerSideFuzzyMatch = true,
                        },
                    },
                },
                typescript = {
                    updateImportsOnFileMove = { enabled = "always" },
                    suggest = {
                        completeFunctionCalls = true,
                    },
                    inlayHints = {
                        enumMemberValues = { enabled = false },
                        functionLikeReturnTypes = { enabled = false },
                        parameterNames = { enabled = false },
                        parameterTypes = { enabled = false },
                        propertyDeclarationTypes = { enabled = false },
                        variableTypes = { enabled = false },
                    },
                },
            },
        },
        eslint = {
            init_options = {
                provideFormatter = true,
            },
            root_dir = lspconfig.util.root_pattern(".eslintrc.json"),
            settings = {
                codeAction = {
                    disableRuleComment = {
                        enable = true,
                        location = "separateLine",
                    },
                    showDocumentation = {
                        enable = true,
                    },
                },
                packageManager = "npm",
                codeActionOnSave = {
                    enable = true,
                    mode = "all",
                },
                onIgnoredFiles = "off",
                problems = {
                    shortenToSingleLine = false,
                },
                rulesCustomizations = {
                    {
                        rule = "no-underscore-dangle",
                        severity = "off",
                    },
                },
                validate = "on",
                format = true,
                workingDirectories = { mode = "auto" },
            },
            on_new_config = function(config, new_root_dir)
                config.settings.workspaceFolder = {
                    uri = new_root_dir,
                    name = vim.fs.basename(new_root_dir),
                }
            end,
        },
        nil_ls = {},
        zls = {
            settings = {
                zls = {
                    enable_inlay_hints = true,
                    enable_snippets = true,
                    warn_style = true,
                },
            },
        },
    }

    vim.g.zig_fmt_parse_errors = 0
    vim.g.zig_fmt_autosave = 0

    for server, config in pairs(clients) do
        local server_config = { capabilities = base_capabilities }

        if type(config) == "table" then
            for k, v in pairs(config) do
                server_config[k] = v
            end
        end

        server_config.capabilities = require("blink.cmp").get_lsp_capabilities(server_config.capabilities)

        lspconfig[server].setup(server_config)
    end
end)
