local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add({
        source = "nvim-neotest/neotest",
        depends = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "olimorris/neotest-phpunit",
            "marilari88/neotest-vitest",
        },
    })

    local opts = {
        adapters = {
            ["neotest-phpunit"] = {},
            ["neotest-vitest"] = {
                cwd = function(file)
                    local util = require("neotest-vitest.util")
                    return util.find_node_modules_ancestor(file)
                end,
            },
        },
        output = { open_on_run = true },
    }

    if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
            if type(name) == "number" then
                if type(config) == "string" then config = require(config) end
                adapters[#adapters + 1] = config
            elseif config ~= false then
                local adapter = require(name)
                if type(config) == "table" and not vim.tbl_isempty(config) then
                    local meta = getmetatable(adapter)
                    if adapter.setup then
                        adapter.setup(config)
                    elseif adapter.adapter then
                        adapter.adapter(config)
                        adapter = adapter.adapter
                    elseif meta and meta.__call then
                        adapter = adapter(config)
                    else
                        error("Adapter " .. name .. " does not support setup")
                    end
                end
                adapters[#adapters + 1] = adapter
            end
        end
        opts.adapters = adapters
    end

    require("neotest").setup(opts)

    keymap(
        "n",
        "<leader>tf",
        function() require("neotest").run.run(vim.fn.expand("%")) end,
        { desc = "Run File (Neotest)" }
    )
    keymap(
        "n",
        "<leader>tF",
        function() require("neotest").run.run(vim.fn.expand("%:h")) end,
        { desc = "Run Directory (Neotest)" }
    )
    keymap("n", "<leader>tr", function() require("neotest").run.run() end, { desc = "Run Nearest (Neotest)" })
    keymap("n", "<leader>tl", function() require("neotest").run.run_last() end, { desc = "Run Last (Neotest)" })
    keymap("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Toggle Summary (Neotest)" })
    keymap(
        "n",
        "<leader>to",
        function() require("neotest").output.open({ enter = true, auto_close = true }) end,
        { desc = "Show Output (Neotest)" }
    )
    keymap(
        "n",
        "<leader>tO",
        function() require("neotest").output_panel.toggle() end,
        { desc = "Toggle Output Panel (Neotest)" }
    )
    keymap("n", "<leader>tS", function() require("neotest").run.stop() end, { desc = "Stop (Neotest)" })
    keymap(
        "n",
        "<leader>tw",
        function() require("neotest").watch.toggle(vim.fn.expand("%")) end,
        { desc = "Toggle Watch (Neotest)" }
    )
end)
