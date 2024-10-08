return {
    -- {
    --     'mrcjkb/rustaceanvim',
    --     config = function(_, opts)
    --         if vim.fn.executable 'rust-analyzer' == 0 then
    --             LazyVim.error(
    --                 '**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/',
    --                 { title = 'rustaceanvim' }
    --             )
    --         end
    --
    --         local mason_registry = require 'mason-registry'
    --         local codelldb = mason_registry.get_package 'codelldb'
    --         local extension_path = codelldb:get_install_path() .. '/extension/'
    --         local codelldb_path = extension_path .. 'adapter/codelldb'
    --         local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'
    --         local cfg = require 'rustaceanvim.config'
    --
    --         vim.g.rustaceanvim = vim.tbl_deep_extend('keep', vim.g.rustaceanvim or {}, opts or {})
    --         vim.g.rustaceanvim.dap.adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
    --     end,
    -- },
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                rust = { "rustfmt" },
            },
        },
    },
}
