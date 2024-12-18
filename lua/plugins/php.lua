local util = require "conform.util"

return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                intelephense = {
                    enabled = true,
                    init_options = {
                        storagePath = "/tmp/intelephense",
                        globalStoragePath = os.getenv "HOME" .. "/.cache/intelephense",
                        licenceKey = os.getenv "HOME" .. "/.local/auth/intelephense.txt" or "",
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
                                associations = { "*.php", "*.blade.php" }, -- Associating .blade.php files as well
                                maxSize = 5000000,
                            },
                        },
                    },
                },
            },
        },
    },
    {
        "stevearc/conform.nvim",
        opts = {
            notify_on_error = false,
            formatters_by_ft = {
                php = { "pint" },
            },
            formatters = {
                injected = { options = { ignore_errors = true } },
                pint = {
                    meta = {
                        url = "https://github.com/laravel/pint",
                        description = "Laravel Pint is an opinionated PHP code style fixer for minimalists. Pint is built on top of PHP-CS-Fixer and makes it simple to ensure that your code style stays clean and consistent.",
                    },
                    command = util.find_executable({
                        "vendor/bin/pint",
                        vim.fn.stdpath "data" .. "/mason/bin/pint",
                    }, "pint"),
                    args = { "$FILENAME" },
                    stdin = false,
                },
            },
        },
    },
    {
        -- Remove phpcs linter.
        "mfussenegger/nvim-lint",
        optional = true,
        opts = {
            linters_by_ft = {
                php = {},
            },
        },
    },
    -- {
    --     "adalessa/laravel.nvim",
    --     dependencies = {
    --         "tpope/vim-dotenv",
    --         "nvim-telescope/telescope.nvim",
    --         "MunifTanjim/nui.nvim",
    --         "kevinhwang91/promise-async",
    --     },
    --     cmd = { "Laravel" },
    --     keys = {
    --         { "<leader>La", ":Laravel artisan<cr>" },
    --         { "<leader>Lr", ":Laravel routes<cr>" },
    --         { "<leader>Lm", ":Laravel related<cr>" },
    --     },
    --     event = { "VeryLazy" },
    --     opts = {
    --         lsp_server = "intelephense",
    --         features = {
    --             route_info = {
    --                 middlewares = false, --- wheather to show the middlewares section in the info
    --                 method = true, --- wheather to show the method section in the info
    --                 uri = true, --- wheather to show the uri section in the info
    --             },
    --         },
    --     },
    --     config = true,
    -- },
}
