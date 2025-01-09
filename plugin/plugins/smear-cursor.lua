local add, later = MiniDeps.add, MiniDeps.later
later(function()
    add("sphamba/smear-cursor.nvim")
    require("smear_cursor").setup({
        hide_target_hack = true,
        cursor_color = "none",
        -- cursor_color = "#f1e1dd",
        distance_stop_animating = 1, -- Isn't as annoying when doing small jumps
        -- Smear cursor when switching buffers or windows.
        smear_between_buffers = true,
        -- Smear cursor when moving within line or to neighbor lines.
        smear_between_neighbor_lines = false,
        legacy_computing_symbols_support = true,
    })
end)
