local root_patterns = {
    ".eslintrc.json",
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    "eslint.config.js",
    "eslint.config.mjs",
    "eslint.config.cjs",
    "eslint.config.ts",
    "eslint.config.mts",
    "eslint.config.cts",
}

local function get_project_root()
    local current_file = vim.fn.expand("%:p")
    local root = vim.fs.find(root_patterns, {
        path = current_file,
        upward = true,
    })[1]

    return root and vim.fs.dirname(root) or vim.fn.getcwd()
end

---@type vim.lsp.Config
return {
    cmd = { "vscode-eslint-language-server", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "html",
    },
    root_markers = root_patterns,
    init_options = {
        provideFormatter = true,
    },
    settings = {
        validate = "on",
        packageManager = "npm",
        useESLintClass = false,
        experimental = {
            useFlatConfig = false,
        },
        codeActionOnSave = {
            enable = true,
            mode = "all",
        },
        format = true,
        quiet = false,
        onIgnoredFiles = "off",
        rulesCustomizations = {},
        run = "onType",
        options = {
            parserOptions = {
                project = get_project_root() .. "/tsconfig.json",
            },
        },
        problems = {
            shortenToSingleLine = false,
        },
        nodePath = "",
        workingDirectory = { mode = "auto" },
        codeAction = {
            disableRuleComment = {
                enable = true,
                location = "separateLine",
            },
            showDocumentation = {
                enable = true,
            },
        },
    },
    on_new_config = function(config, new_root_dir)
        config.settings.workspaceFolder = {
            uri = new_root_dir,
            name = vim.fs.basename(new_root_dir),
        }
    end,
    handlers = {
        ["eslint/openDoc"] = function(_, result)
            if result then vim.ui.open(result.url) end
            return {}
        end,
        ["eslint/confirmESLintExecution"] = function(_, result)
            if not result then return end
            return 4 -- approved
        end,
        ["eslint/probeFailed"] = function()
            vim.notify("[lspconfig] ESLint probe failed.", vim.log.levels.WARN)
            return {}
        end,
        ["eslint/noLibrary"] = function()
            vim.notify("[lspconfig] Unable to find ESLint library.", vim.log.levels.WARN)
            return {}
        end,
    },
}
