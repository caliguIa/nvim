local M = {}
local ts_utils = require "nvim-treesitter.ts_utils"

local function get_variable_under_cursor(variable_types)
    local node = ts_utils.get_node_at_cursor()
    if not node then return nil end

    local variable_name = nil
    local primary_type = variable_types[1]
    local secondary_type = variable_types[2]

    if node:type() == primary_type then
        variable_name = vim.treesitter.get_node_text(node, 0)
    elseif secondary_type and node:type() == secondary_type then
        -- Look for the primary type in the parent nodes
        local parent = node:parent()
        while parent do
            if parent:type() == primary_type then
                variable_name = vim.treesitter.get_node_text(parent, 0)
                break
            end
            parent = parent:parent()
        end
    end

    return variable_name, node
end

local function insert_debug_statement(node, debug_statement)
    -- Find the end of the current statement
    local statement_node = node
    while
        statement_node
        and not vim.tbl_contains(
            { "variable_declarator", "expression_statement", "declaration", "assignment_expression" },
            statement_node:type()
        )
    do
        statement_node = statement_node:parent()
    end

    local insert_row
    if statement_node then
        local _, _, end_row = statement_node:range()
        insert_row = end_row + 1
    else
        -- If we can't find a suitable statement, insert on the next line
        local cursor_row = unpack(vim.api.nvim_win_get_cursor(0))
        insert_row = cursor_row
    end

    -- Get the indentation of the original node
    local start_row = node:range()
    local line_content = vim.api.nvim_buf_get_lines(0, start_row, start_row + 1, false)[1]
    local indentation = line_content:match "^%s*"

    -- Insert the debug statement on the next line with proper indentation
    local indented_debug_statement = indentation .. debug_statement
    vim.api.nvim_buf_set_lines(0, insert_row, insert_row, false, { indented_debug_statement })

    -- Move the cursor to the end of the inserted line
    vim.api.nvim_win_set_cursor(0, { insert_row + 1, #indented_debug_statement })
end

function M.setup_debug_keymap(variable_types, print_function)
    _G.debug_variable_under_cursor = function()
        local variable_name, node = get_variable_under_cursor(variable_types)

        if not variable_name then return end

        local debug_statement = print_function(variable_name)
        insert_debug_statement(node, debug_statement)
    end

    vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "<leader>cl",
        ":lua debug_variable_under_cursor()<CR>",
        { noremap = true, silent = true }
    )
end

return M
