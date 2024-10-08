local cmd = vim.cmd
local o = vim.o
local g = vim.g

g.mapleader = ' '
g.maplocalleader = ' '
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.lazyvim_php_lsp = 'intelephense'
g.lazyvim_picker = 'telescope'
g.lazyvim_prettier_needs_config = true -- If no prettier config file is found, the formatter will not be used

o.spelllang = 'en,uk' -- Define spelling dictionaries
o.spelloptions = 'camel' -- Treat parts of camelCase words as seprate words
vim.opt.complete:append 'kspell' -- Add spellcheck options for autocomplete
vim.opt.complete:remove 't' -- Don't use tags for completion

o.compatible = false

-- Search down into subfolders
o.path = vim.o.path .. '**'

o.number = true
o.relativenumber = true
o.cursorline = true
o.showmatch = true -- Highlight matching parentheses, etc
o.incsearch = true
o.hlsearch = true

o.autoindent = true
o.expandtab = true
o.tabstop = 4
o.shiftwidth = 4
o.foldenable = true
o.history = 2000
o.nrformats = 'bin,hex' -- 'octal'
o.undofile = true
o.undodir = os.getenv 'HOME' .. '/.vim/undodir'
o.splitright = true
o.splitbelow = true
o.cmdheight = 0

o.inccommand = 'split'
o.mouse = 'a'
o.clipboard = 'unnamedplus'
o.breakindent = true
o.autoread = true
o.ignorecase = true
o.smartcase = true
o.scrolloff = 10
o.updatetime = 50
o.timeout = true
o.timeoutlen = 300
o.completeopt = 'menuone,noselect'
o.termguicolors = true
o.swapfile = false
o.wrap = false
o.showmode = false

vim.opt.formatoptions:remove 'o'

vim.diagnostic.config {
    virtual_text = false,
    signs = false,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = 'minimal',
        border = 'single',
        source = 'if_many',
        header = '',
        prefix = '',
    },
}

g.editorconfig = true

-- Native plugins
cmd.filetype('plugin', 'indent', 'on')
cmd.packadd 'cfilter' -- Allows filtering the quickfix list with :cfdo
