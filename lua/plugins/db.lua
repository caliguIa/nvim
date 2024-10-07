local util = require 'conform.util'
local uv = vim.loop
local function notify_user(msg) print(msg) end

return {
    {
        'kristijanhusak/vim-dadbod-ui',
        dependencies = {
            { 'tpope/vim-dadbod', lazy = true },
            { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
        },
        cmd = {
            'DBUI',
            'DBUIToggle',
            'DBUIAddConnection',
            'DBUIFindBuffer',
        },
        init = function()
            local base = vim.fs.joinpath(os.getenv 'HOME', 'tmp', 'queries')
            local cmp = require 'cmp'
            cmp.setup.filetype({ 'sql' }, { sources = { { name = 'vim-dadbod-completion' }, { name = 'buffer' } } })

            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_winwidth = 40
            vim.g.db_ui_win_position = 'right'
            vim.g.db_ui_auto_execute_table_helpers = true
            vim.g.db_ui_execute_on_save = false
            vim.g.db_ui_show_database_icon = true
            vim.g.db_ui_save_location = base
            vim.g.db_ui_tmp_query_location = vim.fs.joinpath(base, 'tmp')
            vim.g.dbs = {
                {
                    name = 'ous-local',
                    url = os.getenv 'DB_OUS_LOCAL',
                },
                {
                    name = 'ous-staging',
                    url = function()
                        local handle
                        handle = uv.spawn('timeout', {
                            args = { '1200s', 'ssh', '-N', 'ous-staging' },
                            stdio = { nil, nil, nil },
                        }, function()
                            handle:close()
                            notify_user 'Timeout hit for SSH tunnel.'
                        end)

                        return os.getenv 'DB_OUS_STAGING'
                    end,
                },
                {
                    name = 'ous-prod',
                    url = function()
                        local handle
                        handle = uv.spawn('timeout', {
                            args = { '1200s', 'ssh', '-N', 'ous-prod' },
                            stdio = { nil, nil, nil },
                        }, function() handle:close() end)

                        return os.getenv 'DB_OUS_PROD'
                    end,
                },
            }
        end,
        keys = {
            {
                '<leader>db',
                '<CMD>DBUIToggle<CR>',
                desc = 'Toggle database',
            },
        },
    },
    {
        'stevearc/conform.nvim',
        opts = {
            formatters_by_ft = {
                sql = { 'sqlfluff' },
            },
            formatters = {
                sqlfluff = {
                    command = 'sqlfluff',
                    args = {
                        'format',
                        '-',
                    },
                    cwd = util.root_file {
                        '.sqlfluff',
                    },
                },
            },
        },
    },
}
