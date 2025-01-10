---@class PathConfig
---@field separator string
---@field full boolean Show full path or just filename
---@field format_dirname? fun(dirname: string): string Function to format directory names
---@field format_filename? fun(filename: string): string Function to format file name

---@class IconsConfig
---@field dir boolean
---@field file boolean

---@class Config
---@field icons boolean|IconsConfig
---@field path PathConfig
---@field show_extension boolean
---@field disabled_filetypes string[]

local M = {}

local ICON_TYPES = {
    file = {
        highlight = "HanzelFileIcon",
        text_highlight = "HanzelFile",
        config_key = "file",
    },
    directory = {
        highlight = "HanzelFolderIcon",
        text_highlight = "HanzelDirectory",
        config_key = "dir",
    },
}

local PROVIDERS = {
    mini = {
        module = "mini.icons",
        get = function(icon_type, name)
            local mini = require("mini.icons")
            return mini.get(icon_type, icon_type == "directory" and "default" or name)
        end,
    },
    devicons = {
        module = "nvim-web-devicons",
        get = function(icon_type, name)
            if icon_type == "directory" then return "" end
            return require("nvim-web-devicons").get_icon(name)
        end,
    },
}

local DEFAULT_CONFIG = {
    icons = true,
    path = {
        separator = " > ",
        full = true,
        format_dirname = function(dir_name) return dir_name end,
        format_filename = function(file_name) return file_name end,
    },
    show_extension = true,
    disabled_filetypes = {
        "help",
        "ministarter",
        "lazy",
        "mason",
        "oil",
        "alpha",
        "dashboard",
        "neo-tree",
        "nvim-tree",
        "nerdtree",
        "telescope",
        "qf",
        "trouble",
        "prompt",
    },
}

local icon_provider = nil

local function setup_highlights()
    local highlights = {
        HanzelFile = "Directory",
        HanzelDirectory = "Directory",
        HanzelFileIcon = "Special",
        HanzelFolderIcon = "Special",
        HanzelSeparator = "Comment",
    }

    for group, link in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, { link = link })
    end
end

local function init_icons()
    for name, provider in pairs(PROVIDERS) do
        local ok = pcall(require, provider.module)
        if ok then
            icon_provider = name
            return
        end
    end
end

local function get_icon(name, icon_type)
    if type(M.config.icons) == "boolean" and not M.config.icons then return "" end
    if type(M.config.icons) == "table" and not M.config.icons[ICON_TYPES[icon_type].config_key] then return "" end
    if not icon_provider then return "" end

    local icon = PROVIDERS[icon_provider].get(icon_type, name)
    if not icon then return "" end

    return string.format("%%#%s#%s%%#%s# ", ICON_TYPES[icon_type].highlight, icon, ICON_TYPES[icon_type].text_highlight)
end

---@param filename string
---@return string
local function process_filename(filename)
    local name = M.config.show_extension and filename or vim.fn.fnamemodify(filename, ":r")
    return M.config.path.format_filename(name)
end

---@param icons_config boolean|table
---@return IconsConfig
local function process_icons_config(icons_config)
    if type(icons_config) == "boolean" then return {
        dir = icons_config,
        file = icons_config,
    } end
    return vim.tbl_deep_extend("force", { dir = true, file = true }, icons_config or {})
end

function M.generate_path_string()
    local filetype = vim.bo.filetype
    if vim.tbl_contains(M.config.disabled_filetypes, filetype) then return "" end

    local file = vim.fn.expand("%:p")
    if file == "" then return "" end

    local relative = vim.fn.fnamemodify(file, ":.")
    local parts = vim.split(relative, "/")
    local result = " "

    if not M.config.path.full then
        local filename = parts[#parts]
        local icon = get_icon(filename, "file")
        local formatted_name = process_filename(filename)
        return result .. icon .. "%#HanzelFile#" .. formatted_name .. "%*"
    end

    for i, part in ipairs(parts) do
        if i == #parts then
            local icon = get_icon(part, "file")
            local formatted_name = process_filename(part)
            result = result .. icon .. "%#HanzelFile#" .. formatted_name
        else
            local icon = get_icon(part, "directory")
            local formatted_dirname = M.config.path.format_dirname(part)
            result = result
                .. icon
                .. "%#HanzelDirectory#"
                .. formatted_dirname
                .. "%#HanzelSeparator#"
                .. M.config.path.separator
        end
    end

    return result .. "%*"
end

---@param opts? Config
function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", DEFAULT_CONFIG, opts or {})

    if opts and opts.icons ~= nil then
        M.config.icons = type(opts.icons) == "boolean" and opts.icons or process_icons_config(opts.icons)
    end

    init_icons()
    setup_highlights()
    vim.o.winbar = "%{%v:lua.require'hanzel'.generate_path_string()%}"
end

return M
