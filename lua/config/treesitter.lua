require("nvim-treesitter.configs").setup({
    --stylua: ignore
    ensure_installed = {
        "bash", "c", "cpp", "css", "csv", "diff", "elixir", "git_config", "git_rebase",
        "gitcommit", "gitignore", "gleam", "go", "html", "http", "javascript", "jsdoc",
        "json", "jsonc","json", "jq", "lua", "luadoc", "luap", "make", "markdown",
        "markdown_inline", "nix", "nu", "ocaml", "php", "php_only", "phpdoc", "printf", "python", "query",
        "regex", "rst", "rust", "sql", "ssh_config", "terraform", "toml", "tsx",
        "typescript", "vim", "vimdoc", "yaml", "zig",
    },
    incremental_selection = { enable = false },
    textobjects = { enable = false },
    indent = { enable = true },
    highlight = { enable = true },
})
require("ts-comments").setup()
require("nvim-ts-autotag").setup({ enable_close_on_slash = false })
