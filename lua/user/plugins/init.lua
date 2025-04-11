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
    "lukas-reineke/indent-blankline.nvim",
    "mbbill/undotree",
    "nvim-lua/plenary.nvim",
    "NeogitOrg/neogit",
    "echasnovski/mini.nvim",
    "akinsho/git-conflict.nvim",
    "lewis6991/gitsigns.nvim",
    "stevearc/conform.nvim",
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    "windwp/nvim-ts-autotag",
    "folke/ts-comments.nvim",
    "nvim-treesitter/nvim-treesitter-textobjects",
    {
        "saghen/blink.cmp",
        build = function()
            vim.notify("Building blink.cmp", vim.log.levels.INFO)
            local obj = vim.system(
                { "nix", "run", ".#build-plugin" },
                { cwd = vim.fn.stdpath("data") .. "/site/pack/paqs/start/blink.cmp/" }
            ):wait()
            if obj.code == 0 then
                vim.notify("Building blink.cmp done", vim.log.levels.INFO)
            else
                vim.notify("Building blink.cmp failed", vim.log.levels.ERROR)
            end
        end,
    },
    "neovim/nvim-lspconfig",
    "rafamadriz/friendly-snippets",
    "ku1ik/vim-pasta",
    "vim-test/vim-test",
    "christoomey/vim-tmux-navigator",
    {
        "kndndrj/nvim-dbee",
        build = function()
            local ok, _
            pcall(require, "dbee")
            if ok then ok.install() end
        end,
    },
    "MunifTanjim/nui.nvim",
    "Goose97/timber.nvim",
    "olimorris/codecompanion.nvim",
})

local plugin_path = vim.fn.stdpath("config") .. "/lua/user/plugins"
vim.iter(vim.split(vim.fn.glob(plugin_path .. "/*.lua"), "\n"))
    :filter(function(file) return file ~= "" and file:match("init.lua$") == nil end)
    :each(function(file)
        local module_name = vim.fn.fnamemodify(file, ":t:r")
        local module = "user.plugins." .. module_name
        pcall(require, module)
    end)
