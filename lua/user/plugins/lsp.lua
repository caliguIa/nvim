local lspconfig = require("lspconfig")

local function augroup(name) return vim.api.nvim_create_augroup(name, { clear = true }) end
local autocmd = vim.api.nvim_create_autocmd

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
    phpactor = {
        on_attach = function(client, bufnr)
            client.server_capabilities.completionProvider = false
            client.server_capabilities.hoverProvider = false
            client.server_capabilities.implementationProvider = false
            client.server_capabilities.referencesProvider = false
            client.server_capabilities.renameProvider = false
            client.server_capabilities.selectionRangeProvider = false
            client.server_capabilities.signatureHelpProvider = false
            client.server_capabilities.typeDefinitionProvider = false
            client.server_capabilities.workspaceSymbolProvider = false
            client.server_capabilities.definitionProvider = false
            client.server_capabilities.documentHighlightProvider = false
            client.server_capabilities.documentSymbolProvider = false
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
        end,
        init_options = {
            ["language_server_phpstan.enabled"] = false,
            ["language_server_psalm.enabled"] = false,
        },
        handlers = {
            ["textDocument/publishDiagnostics"] = function() end,
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

-- Open LSP picker for the given scope
---@param scope "declaration" | "definition" | "document_symbol" | "implementation" | "references" | "type_definition" | "workspace_symbol"
---@param autojump boolean? If there is only one result it will jump to it.
local function picker(scope, autojump)
    ---@return string
    local function get_symbol_query() return vim.fn.input("Symbol: ") end

    if not autojump then
        local opts = { scope = scope }

        if scope == "workspace_symbol" then opts.symbol_query = get_symbol_query() end

        require("mini.extra").pickers.lsp(opts)
        return
    end

    local function on_list(opts)
        vim.fn.setqflist({}, " ", opts)

        if #opts.items == 1 then
            vim.cmd.cfirst()
        else
            require("mini.extra").pickers.list({ scope = "quickfix" }, { source = { name = opts.title } })
        end
    end

    if scope == "references" then
        vim.lsp.buf.references(nil, { on_list = on_list })
        return
    end

    if scope == "workspace_symbol" then
        vim.lsp.buf.workspace_symbol(get_symbol_query(), { on_list = on_list })
        return
    end

    vim.lsp.buf[scope]({ on_list = on_list })
end

autocmd("LspAttach", {
    group = augroup("lsp-attach"),
    callback = function(event)
        local zendiagram = require("zendiagram")
        Util.map.n("K", vim.lsp.buf.hover, "Hover", { buffer = event.buf })
        Util.map.nl("rn", vim.lsp.buf.rename, "Rename")
        Util.map.nl("ca", vim.lsp.buf.code_action, "Code action")
        Util.map.nl("ss", [[<cmd>Pick lsp scope='document_symbol'<cr>]], "Document LSP symbols")
        Util.map.nl("sS", [[<cmd>Pick lsp scope='workspace_symbol'<cr>]], "Workspace LSP symbols")
        Util.map.n("gd", function() picker("definition", true) end, "Definition")
        Util.map.n("gD", function() picker("declaration", true) end, "Declaration")
        Util.map.n("gr", function() picker("references", true) end, "References")
        Util.map.n("gt", function() picker("type_definition", true) end, "Type definition")
        Util.map.n("gi", function() picker("implementation", true) end, "Implementation")
        Util.map.nl("e", function()
            vim.schedule(function() zendiagram.open() end)
        end, "Diagnostics float")
        Util.map.n("]d", function()
            vim.diagnostic.jump({ count = 1 })
            vim.schedule(function() zendiagram.open() end)
        end, "Next diagnostic")
        Util.map.n("[d", function()
            vim.diagnostic.jump({ count = -1 })
            vim.schedule(function() zendiagram.open() end)
        end, "Prev diagnostic")

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
                group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
                end,
            })
        end

        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_foldingRange) then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldmethod = "expr"
            vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"

            autocmd("LspDetach", { group = augroup("lsp-folds-unset"), command = "setl foldexpr<" })
        end
    end,
})

-- eslint fix all
autocmd({ "BufWritePost" }, {
    group = augroup("eslint_fix"),
    pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
    command = "silent! EslintFixAll",
})
