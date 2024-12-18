local lspconfig = require "lspconfig"
local ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" }

return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                denols = {
                    root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
                    init_options = {
                        enable = true,
                        lint = true,
                        unstable = true,
                    },
                },
                vtsls = {
                    settings = {
                        typescript = {
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
                    keys = {
                        { "<leader>co", false },
                    },
                },
                eslint = {
                    init_options = {
                        provideFormatter = true,
                    },
                    root_dir = lspconfig.util.root_pattern ".eslintrc.json",
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
            },
        },
    },
    {
        "stevearc/conform.nvim",
        opts = {
            stop_after_first = true,
            formatters_by_ft = {
                typescript = { "deno_fmt", "prettier" },
                typescriptreact = { "deno_fmt", "prettier" },
            },
            formatters = {
                deno_fmt = {
                    cwd = require("conform.util").root_file {
                        "deno.json",
                    },
                    require_cwd = true,
                },
            },
        },
    },
    {
        "dmmulroy/ts-error-translator.nvim",
        enabled = false,
        ft = ft,
        opts = {},
    },
}
