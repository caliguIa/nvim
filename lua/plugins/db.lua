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
            local cmp = require 'cmp'
            local db = 'mysql://'
            cmp.setup.filetype({ 'sql' }, { sources = { { name = 'vim-dadbod-completion' }, { name = 'buffer' } } })
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.dbs = {
                {
                    name = 'ous-local',
                    url = db
                        .. os.getenv 'DB_OUS_LOCAL_USER'
                        .. ':'
                        .. os.getenv 'DB_OUS_LOCAL_PASS'
                        .. '@127.0.0.3:3306/'
                        .. os.getenv 'DB_OUS_LOCAL_NAME',
                },
                {
                    name = 'ous-staging',
                    url = db
                        .. os.getenv 'DB_OUS_STAGING_USER'
                        .. ':'
                        .. os.getenv 'DB_OUS_STAGING_PASS'
                        .. '@127.0.0.1:7002/'
                        .. os.getenv 'DB_OUS_STAGING_NAME',
                },
                {
                    name = 'ous-prod',
                    url = db
                        .. os.getenv 'DB_OUS_PROD_USER'
                        .. ':'
                        .. os.getenv 'DB_OUS_PROD_PASS'
                        .. '@127.0.0.1:7003/'
                        .. os.getenv 'DB_OUS_PROD_NAME',
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
}
