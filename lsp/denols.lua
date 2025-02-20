local lsp = vim.lsp
local api = vim.api

local function virtual_text_document_handler(uri, res, client)
    if not res then return nil end

    local lines = vim.split(res.result, "\n")
    local bufnr = vim.uri_to_bufnr(uri)

    local current_buf = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    if #current_buf ~= 0 then return nil end

    api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    api.nvim_set_option_value("readonly", true, { buf = bufnr })
    api.nvim_set_option_value("modified", false, { buf = bufnr })
    api.nvim_set_option_value("modifiable", false, { buf = bufnr })
    lsp.buf_attach_client(bufnr, client.id)
end

local function virtual_text_document(uri, client)
    local params = {
        textDocument = {
            uri = uri,
        },
    }
    local result = client.request_sync("deno/virtualTextDocument", params)
    virtual_text_document_handler(uri, result, client)
end

local function denols_handler(err, result, ctx, config)
    if not result or vim.tbl_isempty(result) then return nil end

    local client = lsp.get_client_by_id(ctx.client_id)
    for _, res in pairs(result) do
        local uri = res.uri or res.targetUri
        if uri:match("^deno:") then
            virtual_text_document(uri, client)
            res["uri"] = uri
            res["targetUri"] = uri
        end
    end

    lsp.handlers[ctx.method](err, result, ctx, config)
end

return {
    cmd = { "deno", "lsp" },
    cmd_env = { NO_COLOR = true },
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },
    root_dir = find_root_pattern({ "deno.json", "deno.jsonc" }),
    settings = {
        deno = {
            enable = true,
            suggest = {
                imports = {
                    hosts = {
                        ["https://deno.land"] = true,
                    },
                },
            },
        },
    },
    init_options = {
        enable = true,
        lint = true,
        unstable = true,
    },
    handlers = {
        ["textDocument/definition"] = denols_handler,
        ["textDocument/typeDefinition"] = denols_handler,
        ["textDocument/references"] = denols_handler,
    },
}
