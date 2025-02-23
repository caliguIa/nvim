local function augroup(name) return vim.api.nvim_create_augroup(name, { clear = true }) end

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
    group = augroup("resize_splits"),
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
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
    pattern = {
        "PlenaryTestPopup",
        "checkhealth",
        "dbout",
        "gitsigns-blame",
        "grug-far",
        "help",
        "lspinfo",
        "neotest-output",
        "neotest-output-panel",
        "neotest-summary",
        "notify",
        "qf",
        "spectre_panel",
        "startuptime",
        "tsplayground",
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

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("man_unlisted"),
    pattern = { "man" },
    callback = function(event) vim.bo[event.buf].buflisted = false end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = augroup("json_conceal"),
    pattern = { "json", "jsonc", "json5" },
    callback = function() vim.opt_local.conceallevel = 0 end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = augroup("auto_create_dir"),
    callback = function(event)
        if event.match:match("^%w%w+:[\\/][\\/]") then return end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- Run Eslint automatically on certain filetypes
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = augroup("eslint_fix"),
    pattern = "*.{js,ts,jsx,tsx}",
    callback = function()
        if vim.fn.exists(":EslintFixAll") > 0 then
            vim.cmd("silent! EslintFixAll")
            return
        end
    end,
})

-- LspRestart eslint on saving package.json
vim.api.nvim_create_autocmd("BufWritePost", {
    group = augroup("lsprestart_eslint"),
    pattern = { "package.json" },
    command = "LspRestart eslint",
})

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("comment_format"),
    callback = function() vim.cmd("setlocal formatoptions-=c formatoptions-=o") end,
    desc = [[Ensure proper 'formatoptions']],
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup("lsp-attach"),
    callback = function(event)
        --stylua: ignore start
        keymap("n", "<Leader>e", require('zendiagram').open, { desc = "Show diagnostics" })
        keymap("n", "K", vim.lsp.buf.hover, { buffer = event.buf })
        keymap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
        keymap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
        keymap("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
        keymap("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration" })
        keymap("n", "gr", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "References" })
        keymap("n", "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
        keymap("n", "gt", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
        keymap("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
        keymap("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })
        keymap("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
        keymap("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })
        --stylua: ignore end

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.name == "vtsls" then vim.env.ESLINT_D_ROOT = client.root_dir end

        if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
            --stylua: ignore start
            keymap("n", "<leader>\\i", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })) end, { desc = "[T]oggle inlay hints" })
        end

        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens, event.buf) then
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                buffer = event.buf,
                callback = vim.lsp.codelens.refresh,
            })
            --stylua: ignore
            keymap("n", "<leader>\\l", function() vim.lsp.codelens.refresh() end, { desc = "[T]oggle code lens refresh" })
        end

        if client and client.server_capabilities.documentHighlightProvider then
            local group = vim.api.nvim_create_augroup("lsp_highlight", { clear = false })
            vim.api.nvim_clear_autocmds({ buffer = event.buf, group = group })

            local timer = vim.loop.new_timer()
            local HOVER_DELAY = 100 -- 100ms delay

            -- Track last position to prevent unnecessary updates
            local last_line = 0
            local last_col = 0

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                group = group,
                buffer = event.buf,
                callback = function()
                    -- Get current position
                    local pos = vim.api.nvim_win_get_cursor(0)
                    local curr_line, curr_col = pos[1], pos[2]

                    -- Only proceed if position actually changed
                    if curr_line ~= last_line or curr_col ~= last_col then
                        last_line, last_col = curr_line, curr_col

                        vim.lsp.buf.clear_references()
                        timer:stop()
                        timer:start(
                            HOVER_DELAY,
                            0,
                            vim.schedule_wrap(function()
                                -- Check if cursor position is still the same
                                local new_pos = vim.api.nvim_win_get_cursor(0)
                                if new_pos[1] == curr_line and new_pos[2] == curr_col then
                                    vim.lsp.buf.document_highlight()
                                end
                            end)
                        )
                    end
                end,
            })

            vim.api.nvim_create_autocmd("BufUnload", {
                group = group,
                buffer = event.buf,
                callback = function()
                    timer:stop()
                    timer:close()
                end,
            })
        end
    end,
})

-- eslint_d linting
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave", "TextChanged", "LspAttach" }, {
    group = augroup("lint-eslint"),
    pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
    callback = function(event)
        local client = vim.lsp.get_clients({ name = "vtsls" })[1]
        if client then require("lint").try_lint("eslint_d", { cwd = client.root_dir }) end
    end,
})

-- clippy lintin
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave", "TextChanged", "LspAttach" }, {
    group = augroup("lint-clippy"),
    pattern = { "*.rs" },
    callback = function(event) require("lint").try_lint("clippy") end,
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
