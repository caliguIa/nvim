-- Leader key =================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- General ====================================================================
vim.o.autoread = true -- Automatically read file contents if file is changed outside of vim
vim.o.backup = false -- Don't store backup
vim.o.clipboard = "unnamedplus" -- Sync with system clipboard
vim.o.mouse = "a" -- Enable mouse
vim.o.mousescroll = "ver:25,hor:6" -- Customize mouse scroll
vim.o.swapfile = false -- Disable swap file
vim.o.switchbuf = "usetab" -- Use already opened buffers when switching
vim.o.writebackup = false -- Don't store backup
vim.o.undofile = true -- Enable persistent undo
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit what is stored in ShaDa file
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- vim.o.updatetime = 40

vim.cmd("filetype plugin indent on") -- Enable all filetype plugins

-- UI =========================================================================
vim.o.breakindent = true -- Indent wrapped lines to match line start
vim.o.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
vim.o.cursorline = true -- Enable highlighting of the current line
vim.o.hlsearch = true -- Enbable highlighting of search results
vim.o.laststatus = 2 -- Always show statusline
vim.o.linebreak = true -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.o.list = true -- Show helpful character indicators
vim.o.number = true -- Show line numbers
vim.o.ruler = false -- Don't show cursor position
vim.o.scrolloff = 4 -- Lines of visible context
vim.o.sidescrolloff = 8 -- Columns of context
vim.o.shortmess = "aoOWFcS" -- Disable certain messages from |ins-completion-menu|
vim.o.showmatch = true -- Highlight matching parentheses, etc
vim.o.showmode = false -- Don't show mode in command line
vim.o.signcolumn = "yes" -- Always show signcolumn or it would frequently shift
vim.o.splitbelow = true -- Horizontal splits will be below
vim.o.splitright = true -- Vertical splits will be to the right
vim.o.termguicolors = true -- Enable gui colors
vim.o.winblend = 0 -- Make floating windows fully opaque
vim.o.wrap = false -- Display long lines as just one line
vim.o.fillchars = table.concat({
    "foldopen:",
    "foldclose:",
    "fold: ",
    "foldsep: ",
    "diff:╱",
    "eob: ",
}, ",")
vim.o.listchars = table.concat({ "extends:…", "nbsp:␣", "precedes:…", "tab:> " }, ",")
vim.o.cursorlineopt = "screenline,number" -- Show cursor line only screen line when wrapped
vim.o.breakindentopt = "list:-1" -- Add padding for lists when 'wrap' is on

if vim.fn.has("nvim-0.9") == 1 then
    vim.opt.shortmess:append("C") -- Don't show "Scanning..." messages
    vim.o.splitkeep = "screen" -- Reduce scroll during window split
end

-- Colors =====================================================================
-- Enable syntax highlighing if it wasn't already (as it is time consuming)
-- Don't use defer it because it affects start screen appearance
if vim.fn.exists("syntax_on") ~= 1 then vim.cmd("syntax enable") end

-- Editing ====================================================================
vim.o.autoindent = true -- Use auto indent
vim.o.confirm = true -- Confirm to save changes before exiting modified buffer
vim.o.expandtab = true -- Convert tabs to spaces
vim.o.formatoptions = "rqnl1j" -- Improve comment editing
vim.o.ignorecase = true -- Ignore case when searching (use `\C` to force not doing that)
vim.o.inccommand = "nosplit" -- Show preview of :subsitute commands
vim.o.incsearch = true -- Show search results while typing
vim.o.infercase = true -- Infer letter cases for a richer built-in keyword completion
vim.o.shiftwidth = 2 -- Use this number of spaces for indentation
vim.o.smartcase = true -- Don't ignore case when searching if pattern has upper case
vim.o.smartindent = true -- Make indenting smart
vim.o.tabstop = 2 -- Insert 2 spaces for a tab
vim.o.virtualedit = "block" -- Allow going past the end of line in visual block mode

vim.opt.iskeyword:append("-") -- Treat dash separated words as a word text object

-- Spelling ===================================================================
-- vim.o.spelllang = "en,uk" -- Define spelling dictionaries
vim.o.spelloptions = "camel" -- Treat parts of camelCase words as seprate words
vim.opt.complete:append("kspell") -- Add spellcheck options for autocomplete
vim.opt.complete:remove("t") -- Don't use tags for completion

-- vim.o.dictionary = vim.fn.stdpath("config") .. "/misc/dict/english.txt" -- Use specific dictionaries

-- Folds ======================================================================
vim.o.foldmethod = "indent" -- Set 'indent' folding method
vim.o.foldlevel = 20 -- Display all folds except top ones
vim.o.foldnestmax = 2 -- Create folds only for some number of nested levels
vim.g.markdown_folding = 1 -- Use folding by heading in markdown files

if vim.fn.has("nvim-0.10") == 1 then
    vim.o.foldtext = "" -- Use underlying text with its highlighting
end

if vim.fn.has("nvim-0.11") == 1 then
    vim.opt.completeopt:append("fuzzy") -- Use fuzzy matching for built-in completion
end

-- Diagnostics ================================================================
vim.diagnostic.config({
    signs = false,
    virtual_text = false,
    underline = true,
})
