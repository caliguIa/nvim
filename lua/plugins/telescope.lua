return {
    "nvim-telescope/telescope.nvim",
    keys = function()
        return {
            { "<leader>sb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
            { "<leader>sf", LazyVim.pick("files", { root = false }), desc = "Files" },
            { "<leader>sg", LazyVim.pick("live_grep", { root = false }), desc = "Grep" },
            { "<leader>sc", "<cmd>Telescope resume<cr>", desc = "Continue" },
            { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
            { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
            { "<leader>sw", LazyVim.pick("grep_string", { root = false, word_match = "-w" }), desc = "Word" },
            { "<leader>sw", LazyVim.pick("grep_string", { root = false }), mode = "v", desc = "Selection" },
            { "<leader>uC", LazyVim.pick("colorscheme", { enable_preview = true }), desc = "Colorscheme with Preview" },
        }
    end,
    config = function()
        require("telescope").setup {
            defaults = {
                path_display = { "smart" },
            },
        }
    end,
}
