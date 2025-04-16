local function augroup(name) return vim.api.nvim_create_augroup(name, { clear = true }) end
local autocmd = vim.api.nvim_create_autocmd

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
        "checkhealth", "dbout", "git", "help", "lspinfo",
        "notify", "qf", "startuptime", "tsplayground"
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.schedule(function()
            Util.map.n("q", function()
                vim.cmd.close()
                pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
            end, "Close buffer", { buffer = event.buf })
        end)
    end,
})

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'
autocmd("FileType", {
    group = augroup("comment_format"),
    callback = function() vim.cmd("setlocal formatoptions-=c formatoptions-=o") end,
    desc = [[Ensure proper 'formatoptions']],
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
        if vim.o.filetype == "help" then vim.cmd.wincmd("L") end
    end,
})
