vim.lsp.enable({
    "cssls",
    "cssmodules_ls",
    "docker_compose_language_service",
    "dockerls",
    "eslint",
    "intelephense",
    "phpactor",
    "jsonls",
    "lua_ls",
    "marksman",
    "nil_ls",
    "rust_analyzer",
    "vtsls",
    "zls",
})

local function augroup(name) return vim.api.nvim_create_augroup(name, { clear = true }) end
local autocmd = vim.api.nvim_create_autocmd

autocmd("LspAttach", {
    callback = function(args) vim.bo[args.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp" end,
})

local function picker(scope, autojump)
    ---@return string
    local function get_symbol_query() return vim.fn.input("Symbol: ") end

    if not autojump then
        local opts = { scope = scope }

        if scope == "workspace_symbol" then opts.symbol_query = get_symbol_query() end

        require("mini.extra").pickers.lsp(opts)
        return
    end

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

autocmd("LspAttach", {
    group = augroup("lsp-attach"),
    callback = function(event)
        local zendiagram = require("zendiagram")
        Util.map.n("K", vim.lsp.buf.hover, "Hover", { buffer = event.buf })
        Util.map.nl("rn", vim.lsp.buf.rename, "Rename")
        Util.map.nl("ca", vim.lsp.buf.code_action, "Code action")
        Util.map.nl("ss", [[<cmd>Pick lsp scope='document_symbol'<cr>]], "Document LSP symbols")
        Util.map.nl("sS", [[<cmd>Pick lsp scope='workspace_symbol'<cr>]], "Workspace LSP symbols")
        Util.map.n("gd", function() picker("definition", true) end, "Definition")
        Util.map.n("gD", function() picker("declaration", true) end, "Declaration")
        Util.map.n("gr", function() picker("references", true) end, "References")
        Util.map.n("gt", function() picker("type_definition", true) end, "Type definition")
        Util.map.n("gi", function() picker("implementation", true) end, "Implementation")
        Util.map.nl("e", function()
            vim.schedule(function() zendiagram.open() end)
        end, "Diagnostics float")
        Util.map.n("]d", function()
            vim.diagnostic.jump({ count = 1 })
            vim.schedule(function() zendiagram.open() end)
        end, "Next diagnostic")
        Util.map.n("[d", function()
            vim.diagnostic.jump({ count = -1 })
            vim.schedule(function() zendiagram.open() end)
        end, "Prev diagnostic")

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
                group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
                end,
            })
        end

        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_foldingRange) then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldmethod = "expr"
            vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"

            autocmd("LspDetach", { group = augroup("lsp-folds-unset"), command = "setl foldexpr<" })
        end
    end,
})

-- eslint fix all
autocmd({ "BufWritePost" }, {
    group = augroup("eslint_fix"),
    pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
    command = "silent! EslintFixAll",
})
