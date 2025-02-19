return {
    cmd = { "vscode-eslint-language-server", "--stdio" },
    root_dir = function(cb)
        local bufname = vim.api.nvim_buf_get_name(0)
        local path = vim.fs.dirname(bufname)

        while path do
            local eslint_path = path .. "/.eslintrc.json"
            if vim.loop.fs_stat(eslint_path) then
                cb(path)
                return
            end

            local parent = vim.fs.dirname(path)
            if parent == path then break end
            path = parent
        end

        cb(vim.fs.dirname(bufname))
    end,
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },
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
        problems = {
            shortenToSingleLine = false,
        },
        nodePath = "",
        workingDirectory = { mode = "location" },
    },
    before_init = function(initialize_params, config)
        local root_dir = config.root_dir
        initialize_params.workspaceFolders = {
            {
                uri = vim.uri_from_fname(root_dir),
                name = vim.fs.basename(root_dir),
            },
        }
        initialize_params.capabilities = vim.tbl_deep_extend("force", initialize_params.capabilities or {}, {
            workspace = {
                configuration = true,
            },
        })
    end,
    on_new_config = function(config, new_root_dir)
        -- Set workspace folder
        config.settings.workspaceFolder = {
            uri = new_root_dir,
            name = vim.fs.basename(new_root_dir),
        }

        -- Set parser options
        config.settings.typescript = {
            tsconfigRootDir = new_root_dir,
            tsserver = {
                path = new_root_dir .. "/tsconfig.json",
            },
        }

        -- Set working directory
        config.settings.workingDirectory = {
            mode = "location",
            directory = new_root_dir,
        }

        -- Set node path
        config.settings.nodePath = new_root_dir .. "/node_modules"

        -- Set parser options
        config.settings.parserOptions = {
            tsconfigRootDir = new_root_dir,
            project = new_root_dir .. "/tsconfig.json",
        }
    end,
    handlers = {
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
        ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
            vim.lsp.handlers["textDocument/publishDiagnostics"](err, result, ctx, config)
        end,
    },
}
