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
            cmp.setup.filetype({ 'sql' }, { sources = { { name = 'vim-dadbod-completion' }, { name = 'buffer' } } })

            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_winwidth = 40
            vim.g.db_ui_win_position = 'right'
            vim.g.db_ui_auto_execute_table_helpers = true
            vim.g.db_ui_execute_on_save = false
            vim.g.db_ui_show_database_icon = true
            vim.g.dbs = {
                {
                    name = 'ous-local',
                    url = os.getenv 'DB_OUS_LOCAL',
                },
                {
                    name = 'ous-staging',
                    url = function()
                        vim.fn.system 'timeout 1200s ssh -N ous-staging &'
                        print 'Connecting to staging tunnel for 20 minutes'
                        return os.getenv 'DB_OUS_STAGING'
                    end,
                },
                {
                    name = 'ous-prod',
                    url = function()
                        vim.fn.system 'timeout 1200s ssh -N ous-prod &'
                        print 'Connecting to prod tunnel for 20 minutes'
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
}
