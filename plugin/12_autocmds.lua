local function augroup(name) return vim.api.nvim_create_augroup(name, { clear = true }) end
local autocmd = vim.api.nvim_create_autocmd

-- Open LSP picker for the given scope
---@param scope "declaration" | "definition" | "document_symbol" | "implementation" | "references" | "type_definition" | "workspace_symbol"
---@param autojump boolean? If there is only one result it will jump to it.
local function picker(scope, autojump)
    ---@return string
    local function get_symbol_query() return vim.fn.input("Symbol: ") end

    if not autojump then
        local opts = { scope = scope }

        if scope == "workspace_symbol" then opts.symbol_query = get_symbol_query() end

        require("mini.extra").pickers.lsp(opts)
        return
    end

    ---@param opts vim.lsp.LocationOpts.OnList
    local function on_list(opts)
        vim.fn.setqflist({}, " ", opts)

        if #opts.items == 1 then
            vim.cmd.cfirst()
        else
            require("mini.extra").pickers.list({ scope = "quickfix" }, { source = { name = opts.title } })
        end
    end

    if scope == "references" then
        vim.lsp.buf.references(nil, { on_list = on_list })
        return
    end

    if scope == "workspace_symbol" then
        vim.lsp.buf.workspace_symbol(get_symbol_query(), { on_list = on_list })
        return
    end

    vim.lsp.buf[scope]({ on_list = on_list })
end

local function goto_marked_file(index)
    local marked = MiniVisits.list_paths(nil, {
        filter = "core",
        sort = function(paths) return paths end,
    })
    if marked[index] then vim.cmd("edit " .. marked[index]) end
end

autocmd("LspAttach", {
    group = augroup("lsp-attach"),
    callback = function(event)
        Util.keymap("n", "K", vim.lsp.buf.hover, { buffer = event.buf })
        Util.keymap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
        Util.keymap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
        Util.keymap("n", "<leader>ss", [[<cmd>Pick lsp scope='document_symbol'<cr>]], { desc = "Document LSP symbols" })
        Util.keymap(
            "n",
            "<leader>sS",
            [[<cmd>Pick lsp scope='workspace_symbol'<cr>]],
            { desc = "Workspace LSP symbols" }
        )
        Util.keymap("n", "gd", function() picker("definition", true) end, { desc = "Definition" })
        Util.keymap("n", "gD", function() picker("declaration", true) end, { desc = "Declaration" })
        Util.keymap("n", "gr", function() picker("references", true) end, { desc = "References" })
        Util.keymap("n", "gt", function() picker("type_definition", true) end, { desc = "Type definition" })
        Util.keymap("n", "gi", function() picker("implementation", true) end, { desc = "Implementation" })

        Util.keymap("n", "<leader>sm", [[<cmd>Pick visit_paths filter='core'<cr>]], { desc = "Marked files" })
        Util.keymap("n", "<leader>md", [[<cmd>lua MiniVisits.remove_label("core")<CR>]], { desc = "Delete mark" })
        Util.keymap("n", "mq", function() goto_marked_file(1) end, { desc = "Goto mark 1" })

        local zendiagram = require("zendiagram")
        Util.keymap("n", "<Leader>e", zendiagram.open, { desc = "Show diagnostics" })
        Util.keymap({ "n", "x" }, "]d", function()
            vim.diagnostic.jump({ count = 1 })
            vim.schedule(function() zendiagram.open() end)
        end, { desc = "Jump to next diagnostic" })
        Util.keymap({ "n", "x" }, "[d", function()
            vim.diagnostic.jump({ count = -1 })
            vim.schedule(function() zendiagram.open() end)
        end, { desc = "Jump to prev diagnostic" })
    end,
})

autocmd("LspAttach", {
    group = augroup("lsp-folds-set"),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client:supports_method("textDocument/foldingRange") then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldmethod = "expr"
            vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
        end
    end,
})
autocmd("LspDetach", { group = augroup("lsp-folds-unset"), command = "setl foldexpr<" })

-- Check if we need to reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = augroup("checktime"),
    callback = function()
        if vim.o.buftype ~= "nofile" then vim.cmd("checktime") end
    end,
})

-- Highlight on yank
autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    callback = function() (vim.hl or vim.highlight).on_yank() end,
})

-- close some filetypes with <q>
autocmd("FileType", {
    group = augroup("close_with_q"),
    -- stylua: ignore
    pattern = {
        "PlenaryTestPopup", "checkhealth", "dbout", "gitsigns-blame", "grug-far",
        "help", "lspinfo", "neotest-output", "neotest-output-panel", "neotest-summary",
        "notify", "qf", "spectre_panel", "startuptime", "tsplayground"
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.schedule(function()
            vim.keymap.set("n", "q", function()
                vim.cmd("close")
                pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
            end, {
                buffer = event.buf,
                silent = true,
                desc = "Quit buffer",
            })
        end)
    end,
})

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'
autocmd("FileType", {
    group = augroup("comment_format"),
    callback = function() vim.cmd("setlocal formatoptions-=c formatoptions-=o") end,
    desc = [[Ensure proper 'formatoptions']],
})

-- eslint fix all
autocmd({ "BufWritePost" }, {
    group = augroup("eslint_fix"),
    pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
    callback = function()
        local client = unpack(vim.lsp.get_clients({ bufnr = 0, name = "eslint" }))
        if client then
            client:request_sync("workspace/executeCommand", {
                command = "eslint.applyAllFixes",
                arguments = {
                    {
                        uri = vim.uri_from_bufnr(0),
                        version = vim.lsp.util.buf_versions[0],
                    },
                },
            }, nil, 0)
        end
    end,
})

-- go to last loc when opening a buffer
autocmd("BufReadPost", {
    group = augroup("last_loc"),
    callback = function(event)
        local exclude = { "gitcommit" }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then return end
        vim.b[buf].last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
    end,
})

-- Fix conceallevel for json files
autocmd({ "FileType" }, {
    group = augroup("json_conceal"),
    pattern = { "json", "jsonc", "json5" },
    callback = function() vim.opt_local.conceallevel = 0 end,
})

-- Disable certain features on large files
vim.filetype.add({
    pattern = {
        [".*"] = {
            function(path, buf)
                if not path or not buf or vim.bo[buf].filetype == "bigfile" then return end
                if path ~= vim.api.nvim_buf_get_name(buf) then return end
                local size = vim.fn.getfsize(path)
                if size <= 0 then return end
                if size > 0.5 * 1024 * 1024 then return "bigfile" end
                local lines = vim.api.nvim_buf_line_count(buf)
                return (size - lines) / lines > 1000 and "bigfile" or nil
            end,
        },
    },
})
autocmd({ "FileType" }, {
    group = augroup("bigfile"),
    pattern = "bigfile",
    callback = function(ev)
        local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(ev.buf), ":p:~:.")
        vim.notify(("Big file detected `%s`."):format(path), vim.log.levels.WARN)
        vim.api.nvim_buf_call(ev.buf, function()
            if vim.fn.exists(":NoMatchParen") ~= 0 then vim.cmd([[NoMatchParen]]) end
            vim.wo.foldmethod = "manual"
            vim.wo.foldexpr = "0"
            vim.wo.statuscolumn = ""
            vim.wo.conceallevel = 0
            vim.schedule(function()
                if vim.api.nvim_buf_is_valid(ev.buf) then
                    vim.bo[ev.buf].syntax = vim.filetype.match({ buf = ev.buf }) or ""
                end
            end)
        end)
    end,
})

-- Make help buffers open in vertical split
autocmd("BufWinEnter", {
    group = augroup("help_window_right"),
    pattern = { "*.txt" },
    callback = function()
        if vim.o.filetype == "help" then
            -- Move help window to the far right
            vim.cmd.wincmd("L")
        end
    end,
})

local ous_ssh_group = augroup("OusSSHTunnel")
local ssh_handles = {}
autocmd("VimEnter", {
    group = ous_ssh_group,
    callback = function()
        if not vim.startswith(vim.fn.getcwd(), os.getenv("HOME") .. "/ous") then return end

        for _, env in ipairs({ "staging", "prod" }) do
            local handle, _ = vim.uv.spawn("ssh", {
                args = { "-N", "ous-" .. env },
                stdio = { nil, nil, nil },
                detached = false,
            })
            if handle then
                ssh_handles[env] = handle
                vim.notify(env .. " SSH tunnel started", vim.log.levels.INFO)
            else
                vim.notify(env .. " SSH tunnel failed to start", vim.log.levels.ERROR)
            end
        end
    end,
})
autocmd("VimLeave", {
    group = ous_ssh_group,
    callback = function()
        for _, handle in pairs(ssh_handles) do
            if handle then
                handle:kill(9)
                handle:close()
            end
        end
    end,
})
