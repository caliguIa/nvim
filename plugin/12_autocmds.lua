local function augroup(name) return vim.api.nvim_create_augroup(name, { clear = true }) end

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

vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup("lsp-attach"),
    callback = function(event)
        keymap("n", "K", vim.lsp.buf.hover, { buffer = event.buf })
        keymap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
        keymap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
        keymap("n", "<leader>ss", [[<cmd>Pick lsp scope='document_symbol'<cr>]], { desc = "Document LSP symbols" })
        keymap("n", "<leader>sS", [[<cmd>Pick lsp scope='workspace_symbol'<cr>]], { desc = "Workspace LSP symbols" })
        keymap("n", "gd", function() picker("definition", true) end, { desc = "Definition" })
        keymap("n", "gD", function() picker("declaration", true) end, { desc = "Declaration" })
        keymap("n", "gr", function() picker("references", true) end, { desc = "References" })
        keymap("n", "gt", function() picker("type_definition", true) end, { desc = "Type definition" })
        keymap("n", "gi", function() picker("implementation", true) end, { desc = "Implementation" })

        keymap("n", "<leader>sm", [[<cmd>Pick visit_paths filter='core'<cr>]], { desc = "Marked files" })
        keymap("n", "<leader>md", [[<cmd>lua MiniVisits.remove_label("core")<CR>]], { desc = "Delete mark" })
        keymap("n", "mq", function() goto_marked_file(1) end, { desc = "Goto mark 1" })

        local zendiagram = require("zendiagram")
        keymap("n", "<Leader>e", zendiagram.open, { desc = "Show diagnostics" })
        keymap({ "n", "x" }, "]d", function()
            vim.diagnostic.jump({ count = 1 })
            vim.schedule(function() zendiagram.open() end)
        end, { desc = "Jump to next diagnostic" })
        keymap({ "n", "x" }, "[d", function()
            vim.diagnostic.jump({ count = -1 })
            vim.schedule(function() zendiagram.open() end)
        end, { desc = "Jump to prev diagnostic" })
    end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = augroup("checktime"),
    callback = function()
        if vim.o.buftype ~= "nofile" then vim.cmd("checktime") end
    end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    callback = function() (vim.hl or vim.highlight).on_yank() end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
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
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("comment_format"),
    callback = function() vim.cmd("setlocal formatoptions-=c formatoptions-=o") end,
    desc = [[Ensure proper 'formatoptions']],
})

-- eslint fix all
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
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
vim.api.nvim_create_autocmd("BufReadPost", {
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
vim.api.nvim_create_autocmd({ "FileType" }, {
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
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = vim.api.nvim_create_augroup("bigfile", { clear = true }),
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
vim.api.nvim_create_autocmd("BufWinEnter", {
    group = vim.api.nvim_create_augroup("help_window_right", { clear = true }),
    pattern = { "*.txt" },
    callback = function()
        if vim.o.filetype == "help" then
            -- Move help window to the far right
            vim.cmd.wincmd("L")
        end
    end,
})
