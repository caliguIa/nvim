local add, later = MiniDeps.add, MiniDeps.later

--stylua: ignore
local ensure_installed = {
    "bash", "c", "cpp", "css", "csv", "diff", "elixir", "git_config", "git_rebase",
    "gitcommit", "gitignore", "gleam", "go", "html", "http", "javascript", "jsdoc",
    "json", "jsonc","json", "jq", "lua", "luadoc", "luap", "make", "markdown",
    "markdown_inline", "nix", "nu", "ocaml", "php", "printf", "python", "query",
    "regex", "rst", "rust", "sql", "ssh_config", "terraform", "toml", "tsx",
    "typescript", "vim", "vimdoc", "yaml",
}

later(function()
    add({
        source = "nvim-treesitter/nvim-treesitter",
        checkout = "master",
        monitor = "main",
        hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
        depends = {
            "windwp/nvim-ts-autotag",
            "nvim-treesitter/nvim-treesitter-context",
        },
    })
    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup({
        ensure_installed = ensure_installed,
        incremental_selection = { enable = false },
        textobjects = { enable = false },
        indent = { enable = false },
        highlight = {
            enable = true,
            disable = function(_, buf)
                local max_filesize = 240 * 1024
                local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then return true end
            end,
        },
    })

    later(function() add({ source = "nvim-treesitter/nvim-treesitter-textobjects" }) end)

    require("nvim-ts-autotag").setup()

    add("folke/ts-comments.nvim")
    require("ts-comments").setup()
end)
