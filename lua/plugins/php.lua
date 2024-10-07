local util = require 'conform.util'

return {
    {
        'neovim/nvim-lspconfig',
        opts = {
            servers = {
                -- phpactor = {
                --     enabled = true,
                --     filetypes = { "php", "blade", "php_only" },
                --     init_options = {
                --         ["language_server_worse_reflection.inlay_hints.enable"] = true,
                --         ["language_server_worse_reflection.inlay_hints.params"] = true,
                --         ["language_server_worse_reflection.inlay_hints.types"] = false,
                --         ["language_server_phpstan.enabled"] = false,
                --         ["language_server_psalm.enabled"] = false,
                --     },
                --     handlers = {
                --         ["textDocument/publishDiagnostics"] = function() end,
                --         ["textDocument/codeAction"] = function() end,
                --         ["textDocument/documentSymbol"] = function() end,
                --         ["textDocument/definition"] = function() end,
                --         ["textDocument/references"] = function() end,
                --         ["textDocument/hover"] = function() end,
                --         ["textDocument/rename"] = function()
                --             print("fuck offffffffffffffffffffffffff")
                --         end,
                --     },
                -- },

                intelephense = {
                    enabled = true,
                    init_options = {
                        storagePath = '/tmp/intelephense',
                        globalStoragePath = os.getenv 'HOME' .. '/.cache/intelephense',
                        licenceKey = os.getenv 'HOME' .. '/.local/auth/intelephense.txt' or '',
                        ['language_server_configuration.auto_config'] = true,
                        ['code_transform.import_globals'] = true,
                    },
                    filetypes = { 'php', 'blade', 'php_only' },
                    settings = {
                        intelephense = {
                            diagnostics = {
                                enable = true,
                            },
                            filetypes = { 'php', 'blade', 'php_only' },
                            format = { enable = false },
                            files = {
                                associations = { '*.php', '*.blade.php' }, -- Associating .blade.php files as well
                                maxSize = 5000000,
                            },
                        },
                    },
                },
            },
        },
        -- setup = {
        -- phpactor = function()
        --     LazyVim.lsp.on_attach(function(client)
        --         -- client.server_capabilities.documentDiagnosticsProvider = false -- Diagnostics handled by intelephense
        --         client.server_capabilities.renameProvider = false
        --         -- client.server_capabilities.hoverProvider = false
        --         -- client.server_capabilities.implementationProvider = false
        --         -- client.server_capabilities.referencesProvider = false
        --         -- client.server_capabilities.selectionRangeProvider = false
        --         -- client.server_capabilities.typeDefinitionProvider = false
        --         -- client.server_capabilities.workspaceSymbolProvider = false
        --         -- client.server_capabilities.definitionProvider = false
        --         -- client.server_capabilities.documentHighlightProvider = false
        --         -- client.server_capabilities.documentSymbolProvider = false
        --         client.server_capabilities.documentFormattingProvider = false
        --         client.server_capabilities.documentRangeFormattingProvider = false
        --     end, "phpactor")
        -- end,
        -- intelephense = function()
        --     LazyVim.lsp.on_attach(function(client, bufnr)
        --         client.server_capabilities.definitionProvider = true
        --         client.server_capabilities.referencesProvider = true
        --         client.server_capabilities.inlineCompletionProvider = true
        --         client.server_capabilities.documentSymbolProvider = true
        --         client.server_capabilities.workspaceSymbolProvider = true
        --         client.server_capabilities.documentFormattingProvider = false
        --         client.server_capabilities.documentRangeFormattingProvider = false
        --         if client.server_capabilities.inlayHintProvider then
        --             vim.lsp.buf.inlay_hint(bufnr, true)
        --         end
        --     end, "intelephense")
        -- end,
        -- },
    },
    {
        'stevearc/conform.nvim',
        opts = {
            formatters_by_ft = {
                php = { 'pint' },
            },
            formatters = {
                injected = { options = { ignore_errors = true } },
                pint = {
                    meta = {
                        url = 'https://github.com/laravel/pint',
                        description = 'Laravel Pint is an opinionated PHP code style fixer for minimalists. Pint is built on top of PHP-CS-Fixer and makes it simple to ensure that your code style stays clean and consistent.',
                    },
                    command = util.find_executable({
                        vim.fn.stdpath 'data' .. '/mason/bin/pint',
                        'vendor/bin/pint',
                    }, 'pint'),
                    args = { '$FILENAME' },
                    stdin = false,
                },
            },
        },
    },
    {
        'adalessa/laravel.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'tpope/vim-dotenv',
            'MunifTanjim/nui.nvim',
        },
        cmd = { 'Sail', 'Artisan', 'Composer', 'Npm', 'Yarn', 'Laravel' },
        keys = {
            { '<leader>La', ':Laravel artisan<cr>' },
            { '<leader>Lr', ':Laravel routes<cr>' },
            { '<leader>Lm', ':Laravel related<cr>' },
        },
        event = { 'VeryLazy' },
        opts = {
            lsp_server = 'intelephense',
            features = {
                null_ls = {
                    enable = false,
                },
                route_info = {
                    enable = true, --- to enable the laravel.nvim virtual text
                    position = 'right', --- where to show the info (available options 'right', 'top')
                    middlewares = true, --- wheather to show the middlewares section in the info
                    method = true, --- wheather to show the method section in the info
                    uri = true, --- wheather to show the uri section in the info
                },
            },
        },
        config = true,
    },
}
