local add, later = MiniDeps.add, MiniDeps.now

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
    }

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

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
            local bufnr = event.buf
            local client = vim.lsp.get_client_by_id(event.data.client_id)

            vim.api.nvim_create_autocmd("WinEnter", {
                callback = function()
                    local win = vim.api.nvim_get_current_win()
                    local win_config = vim.api.nvim_win_get_config(win)

                    if win_config.relative ~= "" then
                        local float_bufnr = vim.api.nvim_win_get_buf(win)

                        vim.keymap.set("n", "K", function()
                            local type_name = vim.fn.expand("<cword>")
                            print("Looking up type: " .. type_name)

                            -- Get the vtsls client
                            local ts_client
                            for _, c in ipairs(vim.lsp.get_active_clients({ bufnr = bufnr })) do
                                if c.name == "vtsls" then
                                    ts_client = c
                                    break
                                end
                            end

                            if not ts_client then
                                print("No TypeScript LSP client found")
                                return
                            end

                            ts_client.request("workspace/symbol", {
                                query = type_name,
                            }, function(err, symbols, ctx)
                                if symbols and #symbols > 0 then
                                    for _, symbol in ipairs(symbols) do
                                        if symbol.name == type_name then
                                            local loc = symbol.location
                                            local types_uri = loc.uri
                                            local types_bufnr = vim.uri_to_bufnr(types_uri)

                                            if not vim.api.nvim_buf_is_loaded(types_bufnr) then
                                                vim.fn.bufload(types_bufnr)
                                            end

                                            -- Get the lines from the buffer
                                            local lines = vim.api.nvim_buf_get_lines(types_bufnr, 0, -1, false)
                                            for i, line in ipairs(lines) do
                                                if line:match("type%s+" .. type_name) then
                                                    -- Extract the type definition
                                                    local type_def = line:match("=%s*(.+);")
                                                    if type_def then
                                                        -- Close the original hover window
                                                        pcall(vim.api.nvim_win_close, win, false)

                                                        -- Create our own hover window with the type information
                                                        local markdown_lines = {
                                                            "```typescript",
                                                            "type " .. type_name .. " = " .. type_def,
                                                            "```",
                                                        }

                                                        vim.lsp.util.open_floating_preview(markdown_lines, "markdown", {
                                                            border = "single",
                                                            focus = false,
                                                        })
                                                    end
                                                    break
                                                end
                                            end
                                            return
                                        end
                                    end
                                end
                            end)
                        end, { buffer = float_bufnr, silent = true })
                    end
                end,
            })
            -- Normal hover keymap for regular buffers
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })

            keymap(
                "n",
                "gd",
                "<cmd>FzfLua lsp_definitions jump_to_single_result=true ignore_current_line=true<cr>",
                { desc = "Goto Definition" }
            )
            keymap(
                "n",
                "gr",
                "<cmd>FzfLua lsp_references jump_to_single_result=true ignore_current_line=true<cr>",
                { desc = "References", nowait = true }
            )
            keymap(
                "n",
                "gI",
                "<cmd>FzfLua lsp_implementations jump_to_single_result=true ignore_current_line=true<cr>",
                { desc = "Goto Implementation" }
            )
            keymap(
                "n",
                "gt",
                "<cmd>FzfLua lsp_typedefs jump_to_single_result=true ignore_current_line=true<cr>",
                { desc = "Goto Type Definition" }
            )
            keymap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
            keymap("n", "<leader>ca", "<cmd>FzfLua lsp_code_actions<cr>", { desc = "Code Action" })
            keymap("n", "<leader>e", function() vim.diagnostic.open_float() end, { noremap = true, silent = true })

            vim.diagnostic.config({
                underline = true,
                update_in_insert = false,
                virtual_text = false,
                severity_sort = true,
                signs = false,
                float = {
                    focusable = true,
                    style = "minimal",
                    border = "none",
                    source = "if_many",
                    header = "",
                    prefix = "",
                },
            })

            if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                keymap(
                    "n",
                    "<leader>\\i",
                    function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })) end,
                    { desc = "[T]oggle inlay hints" }
                )
            end

            if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
                vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                    buffer = event.buf,
                    callback = vim.lsp.codelens.refresh,
                })
                keymap(
                    "n",
                    "<leader>\\l",
                    function() vim.lsp.codelens.refresh() end,
                    { desc = "[T]oggle code lens refresh" }
                )
            end
        end,
    })
end)
