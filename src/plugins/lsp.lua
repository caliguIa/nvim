later(function()
    add("folke/lazydev.nvim")
    add("Bilal2453/luvit-meta")
    add("neovim/nvim-lspconfig")

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
        ts_ls = {},
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
                workingDirecotry = {
                    mode = "auto",
                },
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
        local server_config = {
            capabilities = base_capabilities,
        }

        if type(config) == "table" then
            for k, v in pairs(config) do
                server_config[k] = v
            end
        end

        lspconfig[server].setup(server_config)
    end

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
            local client = vim.lsp.get_client_by_id(event.data.client_id)

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
            keymap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
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

            local ns = vim.api.nvim_create_namespace("cursor_line_diagnostics")
            local diagnostic_prefix = "󰧞 "

            local function show_diagnostics_on_line()
                local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1

                -- Clear any existing virtual text
                vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

                -- Get diagnostics for the current line
                local diagnostics = vim.diagnostic.get(0, { lnum = cursor_line })

                if #diagnostics > 0 then
                    -- Get the current line's text width for padding subsequent lines
                    local line_text = vim.api.nvim_get_current_line()
                    local padding = string.rep(" ", vim.fn.strdisplaywidth(line_text) + 1)

                    -- First diagnostic goes at the end of the line
                    local first_diagnostic = {
                        {
                            diagnostic_prefix .. diagnostics[1].message,
                            "DiagnosticVirtualText" .. vim.diagnostic.severity[diagnostics[1].severity],
                        },
                    }

                    -- Additional diagnostics go on virtual lines below
                    local virt_lines = {}
                    if #diagnostics > 1 then
                        for i = 2, #diagnostics do
                            local d = diagnostics[i]
                            table.insert(virt_lines, {
                                { padding, "" }, -- Add padding first
                                {
                                    diagnostic_prefix .. d.message,
                                    "DiagnosticVirtualText" .. vim.diagnostic.severity[d.severity],
                                },
                            })
                        end
                    end

                    -- Apply the extmark with both virt_text and virt_lines
                    vim.api.nvim_buf_set_extmark(0, ns, cursor_line, 0, {
                        virt_text = first_diagnostic,
                        virt_text_pos = "eol",
                        virt_lines = #virt_lines > 0 and virt_lines or nil,
                    })
                end
            end

            -- Create autocommands for cursor movement and diagnostic changes
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "DiagnosticChanged" }, {
                callback = show_diagnostics_on_line,
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
