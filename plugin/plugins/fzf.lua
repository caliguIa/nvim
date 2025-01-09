local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add("ibhagwan/fzf-lua")
    local fzf = require("fzf-lua")

    local prompt = " "

    local function ivy(opts, ...)
        opts = opts or {}
        opts["winopts"] = opts.winopts or {}

        return vim.tbl_deep_extend("force", {
            prompt = prompt,
            cwd_prompt = false,
            fzf_opts = { ["--layout"] = "reverse" },
            winopts = {
                title_pos = opts["winopts"].title and "center" or nil,
                height = 0.40,
                width = 1.00,
                row = 1,
                col = 1,
                border = { " ", " ", " ", " ", " ", " ", " ", " " },
                preview = {
                    layout = "flex",
                    hidden = "nohidden",
                    flip_columns = 130,
                    scrollbar = "float",
                    scrolloff = "-1",
                    scrollchars = { "█", "░" },
                },
            },
        }, opts, ...)
    end

    local function dropdown(opts, ...)
        opts = opts or {}
        opts["winopts"] = opts.winopts or {}
        opts["winopts"]["preview"] = opts.winopts.preview or {}

        return vim.tbl_deep_extend("force", {
            prompt = prompt,
            fzf_opts = { ["--layout"] = "reverse" },
            winopts = {
                title_pos = opts["winopts"].title and "center" or nil,
                height = 0.70,
                width = 0.45,
                row = 0.1,
                col = 0.5,
                preview = {
                    hidden = opts["winopts"].preview.hidden or "hidden",
                    layout = "vertical",
                    vertical = "up:50%",
                },
            },
        }, opts, ...)
    end

    local function cursor_dropdown(opts)
        return dropdown({
            winopts = {
                row = 1,
                relative = "cursor",
                height = 0.20,
                width = 0.60,
            },
        }, opts)
    end

    local function file_picker(opts_or_cwd)
        if type(opts_or_cwd) == "table" then
            opts_or_cwd.prompt = prompt
            fzf.files(ivy(opts_or_cwd))
        else
            fzf.files(ivy({ cwd = opts_or_cwd, prompt = prompt }))
        end
    end

    fzf.setup({
        "default-title",
        fzf_colors = true,
        fzf_opts = {
            ["--no-scrollbar"] = true,
            ["--info"] = "default", -- hidden OR inline:⏐
            ["--reverse"] = false,
            ["--layout"] = "reverse", -- "default" or "reverse"
            ["--ellipsis"] = "…",
        },
        defaults = {
            -- formatter = "path.filename_first",
            formatter = "path.dirname_first",
            file_icons = false,
        },
        winopts = {
            title_pos = nil,
            height = 0.35,
            width = 1.00,
            row = 1,
            col = 1,
            border = { " ", " ", " ", " ", " ", " ", " ", " " },
            hls = {
                border = "TelescopeBorder",
                header_bind = "NonText",
                header_text = "NonText",
                help_normal = "NonText",
                normal = "TelescopeNormal",
                preview_border = "TelescopePreviewBorder",
                preview_normal = "TelescopePreviewNormal",
                search = "CmpItemAbbrMatch",
                title = "TelescopeTitle",
            },
            preview = {
                layout = "flex",
                flip_columns = 130,
                scrollbar = "float",
                scrolloff = "-1",
                scrollchars = { "█", "░" },
            },
        },
        border = { "", "", "", "", "", "", "", "" },
        previewers = {
            builtin = {
                toggle_behavior = "extend",
                syntax_limit_l = 0, -- syntax limit (lines), 0=nolimit
                syntax_limit_b = 1024 * 100, -- syntax limit (bytes), 0=nolimit
                limit_b = 1024 * 100, -- preview limit (bytes), 0=nolimit
            },
        },
        grep = ivy({
            multiprocess = true,
            stat_file = false, -- verify files exist on disk
            prompt = prompt,
            winopts = { title = "Grep" },
            rg_opts = "--hidden --column --line-number --no-ignore-vcs --no-heading --color=always --smart-case -g '!.git'",
            rg_glob = true, -- enable glob parsing by default to all
            glob_flag = "--iglob", -- for case sensitive globs use '--glob'
            glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
            actions = { ["ctrl-g"] = fzf.actions.grep_lgrep },
            rg_glob_fn = function(query, opts)
                -- this enables all `rg` arguments to be passed in after the `--` glob separator
                local search_query, glob_str = query:match("(.*)" .. opts.glob_separator .. "(.*)")
                local glob_args = glob_str:gsub("^%s+", ""):gsub("-", "%-") .. " "

                return search_query, glob_args
            end,
        }),
        highlights = {
            prompt = prompt,
            winopts = { title = "Highlights" },
        },
        helptags = {
            prompt = prompt,
            winopts = { title = "Help" },
        },
        oldfiles = dropdown({
            cwd_only = true,
            stat_file = true, -- verify files exist on disk
            include_current_session = false, -- include bufs from current session
            winopts = { title = "History" },
        }),
        files = ivy({
            prompt = prompt,
            winopts = { title = "Files" },
        }),
        buffers = dropdown({
            fzf_opts = { ["--delimiter"] = " ", ["--with-nth"] = "-1.." },
            winopts = { title = "Buffers" },
        }),
        keymaps = dropdown({
            winopts = { title = "Keymaps" },
        }),
        registers = cursor_dropdown({
            winopts = { title = "Registers", width = 0.6 },
        }),
        lsp = {
            cwd_only = true,
            symbols = {
                symbol_hl = function(s) return "TroubleIcon" .. s end,
                symbol_fmt = function(s) return s:lower() .. "\t" end,
                child_prefix = false,
            },
            code_actions = cursor_dropdown({
                winopts = {
                    title = "Code actions",
                    -- preview = { hidden = "nohidden", layout = "vertical" },
                    -- width = 0.60,
                    -- height = 0.45,
                },
                previewer = "codeaction_native",
                preview_pager = "delta --dark --features=+ --file-style=omit ",
            }),
            references = ivy({
                winopts = { title = "References" },
            }),
        },
        jumps = dropdown({
            winopts = { title = "Jumps", preview = { hidden = "nohidden" } },
        }),
        changes = dropdown({
            prompt = "",
            winopts = { title = "Changes", preview = { hidden = "nohidden" } },
        }),
        diagnostics = ivy({
            winopts = { title = "Diagnostics" },
        }),
        git = {
            files = dropdown({
                path_shorten = false, -- this doesn't use any clever strategy unlike telescope so is somewhat useless
                cmd = "git ls-files --others --cached --exclude-standard",
                winopts = { title = "Git files" },
            }),
            branches = dropdown({
                winopts = { title = "Branches", height = 0.3, row = 0.4 },
            }),
            status = {
                prompt = "",
                preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
                winopts = { title = "Git status" },
            },
            bcommits = {
                prompt = "",
                preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
                winopts = { title = "Buffer commits" },
            },
            commits = {
                prompt = "",
                preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
                winopts = { title = "Commits" },
            },
        },
    })

    fzf.register_ui_select(dropdown({
        winopts = { title = "Select", height = 0.33, row = 0.5 },
    }))

    keymap("n", "<leader>:", fzf.command_history, { desc = "Command History" })
    keymap("n", "<leader>s,", fzf.builtin, { desc = "Builtins" })
    keymap("n", "<leader>sa", fzf.autocmds, { desc = "Auto Commands" })
    --stylua: ignore
    keymap("n", "<leader>sb", function() fzf.buffers({ sort_mru = true, sort_lastused = true }) end, { desc = "Buffers" })
    keymap("n", "<leader>sd", fzf.diagnostics_document, { desc = "Document Diagnostics" })
    keymap("n", "<leader>sD", fzf.diagnostics_workspace, { desc = "Workspace Diagnostics" })
    keymap("n", "<leader>sf", fzf.files, { desc = "Files" })
    keymap("n", "<leader>sg", fzf.live_grep_glob, { desc = "Grep" })
    keymap("n", "<leader>sh", fzf.help_tags, { desc = "Help Pages" })
    keymap("n", "<leader>sH", fzf.highlights, { desc = "Search Highlight Groups" })
    keymap("n", "<leader>sj", fzf.jumps, { desc = "Jumplist" })
    keymap("n", "<leader>sk", fzf.keymaps, { desc = "Key Maps" })
    keymap("n", "<leader>sM", fzf.man_pages, { desc = "Man Pages" })
    keymap("n", "<leader>so", fzf.oldfiles, { desc = "Recent" })
    keymap("n", "<leader>sr", fzf.resume, { desc = "Resume" })
    keymap("n", "<leader>sq", fzf.quickfix, { desc = "Quickfix List" })
    keymap("n", "<leader>sw", fzf.grep_cword, { desc = "Word" })
    keymap("v", "<leader>sw", fzf.grep_visual, { desc = "Selection" })
end)
