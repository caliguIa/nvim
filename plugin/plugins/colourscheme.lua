local add, later = MiniDeps.add, MiniDeps.later
local x = function(style) return { style } end

---@param hex_str string hexadecimal value of a color
local hex_to_rgb = function(hex_str)
    local hex = "[abcdef0-9][abcdef0-9]"
    local pat = "^#(" .. hex .. ")(" .. hex .. ")(" .. hex .. ")$"
    hex_str = string.lower(hex_str)

    assert(string.find(hex_str, pat) ~= nil, "hex_to_rgb: invalid hex_str: " .. tostring(hex_str))

    local red, green, blue = string.match(hex_str, pat)
    return { tonumber(red, 16), tonumber(green, 16), tonumber(blue, 16) }
end
---@param fg string forecrust color
---@param bg string background color
---@param alpha number number between 0 and 1. 0 results in bg, 1 results in fg
local function blend(fg, bg, alpha)
    bg = hex_to_rgb(bg)
    fg = hex_to_rgb(fg)

    local blendChannel = function(i)
        local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
        return math.floor(math.min(math.max(0, ret), 255) + 0.5)
    end

    return string.format("#%02X%02X%02X", blendChannel(1), blendChannel(2), blendChannel(3))
end

local function darken(hex, amount, bg) return blend(hex, bg or bg, math.abs(amount)) end

later(function()
    add({ source = "catppuccin/nvim", name = "catppuccin" })

    require("catppuccin").setup({
        integrations = {
            fzf = true,
            grug_far = true,
            illuminate = true,
            indent_blankline = { enabled = true },
            markdown = true,
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
                MiniCursorwordCurrent = { bg = darken(colors.surface1, 0.7, colors.base), style = x("standout") },
                MiniCursorword = { bg = darken(colors.surface1, 0.7, colors.base), style = x() },
                -- bg = U.darken(C.surface1, 0.7, C.base)
            }
        end,
    })

    vim.cmd.colorscheme("catppuccin-latte")
end)
