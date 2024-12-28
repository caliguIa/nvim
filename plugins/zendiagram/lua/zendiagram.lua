local M = {}

-- Default configuration
local defaults = {
    prefix = "󰧞 ", -- Prefix character for diagnostic messages
    clear_on_insert = true, -- Clear virtual text when entering insert mode
    display_mode = "overlay", -- Options: "shift" (default) or "overlay"
    max_diagnostics = 3, -- Maximum number of diagnostics to show
    update_events = { -- Events that trigger updates
        "CursorMoved",
        "DiagnosticChanged",
        "InsertLeave",
        "TextChanged",
        "TextChangedI",
        "InsertChange",
    },
}

-- Module state
local config = {}
local ns_id = vim.api.nvim_create_namespace("cursor_line_diagnostics")

-- Generate unique key for diagnostic
local function diagnostic_key(diagnostic, line)
    return string.format("%d:%s:%s", line, diagnostic.message, diagnostic.severity or "")
end

-- Utility function to clear diagnostics
local function clear_virtual_text() vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1) end

-- Main function to show diagnostics
local function handle_diagnostics()
    if vim.fn.mode():match("^i") then
        clear_virtual_text()
        return
    end

    local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1
    clear_virtual_text()
    local displayed_diagnostics = {}
    local diagnostics = vim.diagnostic.get(0, { lnum = cursor_line })

    if #diagnostics > 0 then
        -- Limit number of diagnostics shown
        diagnostics = vim.list_slice(diagnostics, 1, config.max_diagnostics)

        local line_text = vim.api.nvim_get_current_line()

        -- Get window information
        local win = vim.api.nvim_get_current_win()
        local win_height = vim.api.nvim_win_get_height(win)

        -- Get the window-relative position of the cursor
        local win_top = vim.fn.line("w0") - 1 -- Get first line visible in window
        local cursor_relative_pos = cursor_line - win_top

        if config.display_mode == "shift" then
            local first_diagnostic = diagnostics[1]
            local first_key = diagnostic_key(first_diagnostic, cursor_line)

            local padding = string.rep(" ", vim.fn.strdisplaywidth(line_text))

            if not displayed_diagnostics[first_key] then
                local first_virt_text = {
                    {
                        config.prefix .. first_diagnostic.message,
                        "DiagnosticVirtualText" .. vim.diagnostic.severity[first_diagnostic.severity],
                    },
                }
                displayed_diagnostics[first_key] = true

                local virt_lines = {}
                if #diagnostics > 1 then
                    for i = 2, #diagnostics do
                        local d = diagnostics[i]
                        local key = diagnostic_key(d, cursor_line)
                        if not displayed_diagnostics[key] then
                            table.insert(virt_lines, {
                                { padding, "" },
                                {
                                    config.prefix .. d.message,
                                    "DiagnosticVirtualText" .. vim.diagnostic.severity[d.severity],
                                },
                            })
                            displayed_diagnostics[key] = true
                        end
                    end
                end

                vim.api.nvim_buf_set_extmark(0, ns_id, cursor_line, 0, {
                    virt_text = first_virt_text,
                    virt_text_pos = "eol",
                    virt_lines = #virt_lines > 0 and virt_lines or nil,
                })
            end
        else
            -- Overlay behavior
            -- Calculate the position for the first diagnostic
            local first_diagnostic = diagnostics[1]
            local first_key = diagnostic_key(first_diagnostic, cursor_line)

            -- Calculate the col position where EOL virtual text would appear
            local eol_col = vim.fn.strdisplaywidth(line_text) + 1

            -- Calculate available space
            local needed_lines = #diagnostics
            local lines_below = win_height - cursor_relative_pos

            -- Only show diagnostics if we have space
            if needed_lines <= lines_below then
                if not displayed_diagnostics[first_key] then
                    -- Place first diagnostic
                    vim.api.nvim_buf_set_extmark(0, ns_id, cursor_line, 0, {
                        virt_text = {
                            {
                                config.prefix .. first_diagnostic.message,
                                "DiagnosticVirtualText" .. vim.diagnostic.severity[first_diagnostic.severity],
                            },
                        },
                        virt_text_pos = "overlay",
                        virt_text_win_col = eol_col,
                        priority = 100,
                    })
                    displayed_diagnostics[first_key] = true

                    -- Place subsequent diagnostics
                    local line_offset = 1 -- Track actual position independent of loop index
                    for i = 2, #diagnostics do
                        local d = diagnostics[i]
                        local key = diagnostic_key(d, cursor_line)
                        if not displayed_diagnostics[key] then
                            vim.api.nvim_buf_set_extmark(0, ns_id, cursor_line + line_offset, 0, {
                                virt_text = {
                                    {
                                        config.prefix .. d.message,
                                        "DiagnosticVirtualText" .. vim.diagnostic.severity[d.severity],
                                    },
                                },
                                virt_text_pos = "overlay",
                                virt_text_win_col = eol_col,
                                priority = 100 + line_offset, -- Use line_offset for priority too
                            })
                            displayed_diagnostics[key] = true
                            line_offset = line_offset + 1 -- Only increment when we actually place a diagnostic
                        end
                    end
                end
            end
        end
    end
end

function M.setup(opts)
    -- Merge user config with defaults
    config = vim.tbl_deep_extend("force", defaults, opts or {})

    -- Disable default virtual text
    vim.diagnostic.config({
        virtual_text = false,
    })

    -- Create augroup for our autocommands
    local group = vim.api.nvim_create_augroup("ZenDiagram", { clear = true })

    -- Setup autocommands based on config
    if config.clear_on_insert then
        vim.api.nvim_create_autocmd("InsertEnter", {
            group = group,
            callback = clear_virtual_text,
        })
    end

    vim.api.nvim_create_autocmd(config.update_events, {
        group = group,
        callback = handle_diagnostics,
    })
end

return M
