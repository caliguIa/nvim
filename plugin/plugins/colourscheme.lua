local add, later = MiniDeps.add, MiniDeps.later

local function darken(hex, amount, bg)
    local function h2d(h) return tonumber(h, 16) end
    local r1, g1, b1 = hex:lower():match("#(%x%x)(%x%x)(%x%x)")
    local r2, g2, b2 = bg:lower():match("#(%x%x)(%x%x)(%x%x)")

    local blend = function(a, b) return math.floor(math.min(255, math.max(0, amount * h2d(a) + (1 - amount) * h2d(b)))) end

    return string.format("#%02X%02X%02X", blend(r1, r2), blend(g1, g2), blend(b1, b2))
end

later(function()
    add({ source = "catppuccin/nvim", name = "catppuccin" })

    require("catppuccin").setup({
        integrations = {
            fzf = true,
            grug_far = true,
            illuminate = true,
            indent_blankline = { enabled = true },
            markdown = true,
            dropbar = true,
            mini = true,
            native_lsp = {
                enabled = true,
                underlines = {
                    errors = { "undercurl" },
                    hints = { "undercurl" },
                    warnings = { "undercurl" },
                    information = { "undercurl" },
                },
            },
            neotest = true,
            treesitter = true,
            treesitter_context = true,
        },
        custom_highlights = function(colors)
            return {
                MiniCursorwordCurrent = { bg = darken(colors.surface1, 0.7, colors.base), style = {} },
                MiniCursorword = { bg = darken(colors.surface1, 0.7, colors.base), style = {} },
            }
        end,
    })

    vim.cmd.colorscheme("catppuccin-mocha")
end)
