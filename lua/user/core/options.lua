local g = vim.g
local o = vim.o
local opt = vim.opt

g.mapleader = vim.keycode("<space>")
g.maplocalleader = vim.keycode("<space>")

--disable_distribution_plugins
g.loaded_gzip = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_matchit = 1
g.loaded_2html_plugin = 1
g.loaded_rrhelper = 1
g.loaded_netrwPlugin = 1
g.loaded_matchparen = 1

o.autoread = true -- Automatically read file contents if file is changed outside of vim
o.backup = false -- Don't store backup
vim.schedule(function()
    o.clipboard = "unnamedplus" -- Sync with system clipboard (scheduled as it can delay startup)
end)
o.mouse = "a" -- Enable mouse
o.swapfile = false -- Disable swap file
o.switchbuf = "usetab" -- Use already opened buffers when switching
o.writebackup = false -- Don't store backup
o.undofile = true -- Enable persistent undo
o.updatetime = 200
o.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit what is stored in ShaDa file
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.cmd("filetype plugin indent on") -- Enable all filetype plugins

o.breakindent = true -- Indent wrapped lines to match line start
o.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
o.cursorline = true -- Enable highlighting of the current line
o.hlsearch = true -- Enbable highlighting of search results
o.laststatus = 2 -- Always show statusline
o.linebreak = true -- Wrap long lines at 'breakat' (if 'wrap' is set)
o.list = true -- Show helpful character indicators
o.number = true -- Show line numbers
o.ruler = false -- Don't show cursor position
o.scrolloff = 4 -- Lines of visible context
o.sidescrolloff = 8 -- Columns of context
o.shortmess = "aoOWFcS" -- Disable certain messages from |ins-completion-menu|
o.showmatch = true -- Highlight matching parentheses, etc
o.showmode = false -- Don't show mode in command line
o.signcolumn = "yes" -- Always show signcolumn or it would frequently shift
o.splitbelow = true -- Horizontal splits will be below
o.splitright = true -- Vertical splits will be to the right
o.termguicolors = true -- Enable gui colors
o.winblend = 0 -- Make floating windows fully opaque
o.winborder = "single" -- Use no borders
o.wrap = false -- Display long lines as just one line
o.listchars = table.concat({ "extends:…", "nbsp:␣", "precedes:…", "tab:> " }, ",")
o.cursorlineopt = "screenline,number" -- Show cursor line only screen line when wrapped
o.breakindentopt = "list:-1" -- Add padding for lists when 'wrap' is on

if vim.fn.exists("syntax_on") ~= 1 then vim.cmd("syntax enable") end

o.autoindent = true -- Use auto indent
o.confirm = true -- Confirm to save changes before exiting modified buffer
o.expandtab = true -- Convert tabs to spaces
o.formatoptions = "rqnl1j" -- Improve comment editing
o.ignorecase = true -- Ignore case when searching (use `\C` to force not doing that)
o.inccommand = "split" -- Show preview of :subsitute commands
o.incsearch = true -- Show search results while typing
o.infercase = true -- Infer letter cases for a richer built-in keyword completion
o.shiftwidth = 0 -- Use this number of spaces for indentation
o.smartcase = true -- Don't ignore case when searching if pattern has upper case
o.smartindent = true -- Make indenting smart
o.tabstop = 4 -- Insert 2 spaces for a tab
o.virtualedit = "block" -- Allow going past the end of line in visual block mode

-- o.spelllang = "en,uk" -- Define spelling dictionaries
o.spelloptions = "camel" -- Treat parts of camelCase words as seprate words
opt.complete:append("kspell") -- Add spellcheck options for autocomplete
opt.complete:remove("t") -- Don't use tags for completion

o.foldenable = true -- enable fold
o.foldlevel = 99 -- start editing with all folds opened
o.foldmethod = "expr" -- use tree-sitter for folding method
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldtext = ""
opt.foldcolumn = "0"
opt.fillchars:append({
    fold = " ",
    foldopen = "",
    foldclose = "",
    foldsep = " ",
    diff = "╱",
    eob = " ",
})

o.completeopt = "menu,menuone,noselect,popup,fuzzy"

vim.diagnostic.config({
    signs = false,
    virtual_text = false,
    underline = true,
})
