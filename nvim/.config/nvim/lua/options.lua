-- Disable netrw for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.compatible = false

-- Change highlighting of cursor line when entering/leaving Insert Mode
vim.filetype.plugin_indent_on = true

-- Indentation settings
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true

-- General settings
vim.opt.smartindent = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.colorcolumn = "80"

-- Spell checking
vim.opt.spell = false
vim.opt.spelllang = "en_us"

-- Show line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- Backspace and editing options
vim.opt.backspace = "indent,eol,start"
vim.opt.hidden = true
vim.opt.laststatus = 2
vim.opt.display = "lastline"

-- Display options
vim.opt.showmode = true
vim.opt.showcmd = true

-- Search options
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- Performance options
vim.opt.ttyfast = true
vim.opt.lazyredraw = true

-- Window management
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Path and file settings
vim.opt.path:append "**"
vim.opt.wildignore:append "**/node_modules/**,**/__pycache__/**"
vim.opt.wrapscan = true
vim.opt.report = 0
vim.opt.synmaxcol = 200

-- List characters
if vim.fn.has('multi_byte') and vim.opt.encoding == 'utf-8' then
    vim.opt.listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
else
    vim.opt.listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
end
vim.o.mouse = ''

-- Theme
vim.cmd.colorscheme("catppuccin-mocha")
vim.cmd([[set spell]])
