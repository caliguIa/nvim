local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add({ source = "neovim/nvim-lspconfig", depends = { "saghen/blink.cmp" } })

    local lspconfig = require("lspconfig")

    local clients = {
        cssls = {},
        cssmodules_ls = {},
        docker_compose_language_service = {},
        dockerls = {},
        eslint = {
            init_options = {
                provideFormatter = true,
            },
            root_dir = lspconfig.util.root_pattern(".eslintrc.json"),
            settings = {
                packageManager = "npm",
                codeActionOnSave = { enable = true },
                rulesCustomizations = {
                    {
                        rule = "no-underscore-dangle",
                        severity = "off",
                    },
                },
                workingDirectory = { mode = "auto" },
            },
        },
        intelephense = {
            init_options = {
                storagePath = "/tmp/intelephense",
                globalStoragePath = os.getenv("HOME") .. "/.cache/intelephense",
                licenceKey = os.getenv("INTELEPHENSE_KEY"),
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
        },
        jsonls = {},
        lua_ls = {
            settings = {
                Lua = {
                    runtime = {
                        version = "LuaJIT",
                        path = (function()
                            local runtime_path = vim.split(package.path, ";")
                            table.insert(runtime_path, "lua/?.lua")
                            table.insert(runtime_path, "lua/?/init.lua")
                            return runtime_path
                        end)(),
                    },
                    diagnostics = {
                        globals = { "vim" },
                        disable = { "need-check-nil" },
                        workspaceDelay = -1,
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                        ignoreSubmodules = true,
                    },
                    codeLens = {
                        enable = true,
                    },
                    completion = {
                        callSnippet = "Replace",
                    },
                    doc = {
                        privateName = { "^_" },
                    },
                    hint = {
                        enable = true,
                        setType = false,
                        paramType = true,
                        paramName = "Disable",
                        semicolon = "Disable",
                        arrayIndex = "Disable",
                    },
                },
            },
        },
        marksman = {},
        nil_ls = {},
        rust_analyzer = {
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
        },
        vtsls = {
            settings = {
                complete_function_calls = true,
                vtsls = {
                    enableMoveToFileCodeAction = true,
                    autoUseWorkspaceTsdk = true,
                    experimental = {
                        maxInlayHintLength = 30,
                        completion = {
                            enableServerSideFuzzyMatch = true,
                            entriesLimit = 20,
                        },
                    },
                },
                typescript = {
                    updateImportsOnFileMove = { enabled = "always" },
                    suggest = { completeFunctionCalls = true },
                    inlayHints = {
                        enumMemberValues = { enabled = true },
                        functionLikeReturnTypes = { enabled = true },
                        parameterNames = { enabled = true },
                        parameterTypes = { enabled = true },
                        propertyDeclarationTypes = { enabled = true },
                        variableTypes = { enabled = true },
                    },
                },
            },
        },
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

    vim.iter(clients)
        :map(function(server, config)
            config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)

            return { server = server, config = config }
        end)
        :each(function(item) lspconfig[item.server].setup(item.config) end)
end)
