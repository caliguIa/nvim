local function clone_paq()
    local path = vim.fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
    local is_installed = vim.fn.empty(vim.fn.glob(path)) == 0
    if not is_installed then
        vim.fn.system({ "git", "clone", "--depth=1", "https://github.com/savq/paq-nvim.git", path })
        return true
    end
end

local function bootstrap_paq(packages)
    local first_install = clone_paq()
    vim.cmd.packadd("paq-nvim")
    local paq = require("paq")
    if first_install then vim.notify("Installing plugins... If prompted, hit Enter to continue.") end

    paq(packages)
end

bootstrap_paq({
    "savq/paq-nvim",
    "mbbill/undotree",
    "nvim-lua/plenary.nvim",
    "NeogitOrg/neogit",
    "echasnovski/mini.nvim",
    "nvimdev/indentmini.nvim",
    "stevearc/conform.nvim",
    "akinsho/git-conflict.nvim",
    "windwp/nvim-ts-autotag",
    "folke/ts-comments.nvim",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "neovim/nvim-lspconfig",
    "rafamadriz/friendly-snippets",
    "vim-test/vim-test",
    "aidancz/buvvers.nvim",
    "christoomey/vim-tmux-navigator",
    "MunifTanjim/nui.nvim",
    "Goose97/timber.nvim",
    "olimorris/codecompanion.nvim",
    "bhugovilela/palette.nvim",
    "alexxGmZ/e-ink.nvim",
    "sphamba/smear-cursor.nvim",
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "glacambre/firenvim", build = ":call firenvim#install(0)" },
    {
        "kndndrj/nvim-dbee",
        build = function()
            local ok, _
            require("dbee")
            if ok then ok.install() end
        end,
    },
})
