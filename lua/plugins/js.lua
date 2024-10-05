local lspconfig = require("lspconfig")

return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            -- @type lspconfig.options
            servers = {
                vtsls = {
                    settings = {
                        typescript = {
                            inlayHints = {
                                enumMemberValues = { enabled = true },
                                functionLikeReturnTypes = { enabled = false },
                                parameterNames = { enabled = "literals" },
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
            },
        },
    },
}
