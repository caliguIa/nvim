return {
    {
        "akinsho/bufferline.nvim",
        opts = {
            options = {
                max_name_length = 25,
                max_prefix_length = 15, -- prefix path used when a buffer is de-duplicated
                truncate_names = true,
                tab_size = 25,
                show_buffer_icons = false, -- disable filetype icons for buffers
                show_buffer_close_icons = false,
                show_close_icon = false,
                color_icons = false,
                diagnostics_indicator = nil,
                custom_filter = nil,
            },
        },
    },
}
