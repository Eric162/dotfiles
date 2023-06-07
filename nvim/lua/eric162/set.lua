local opt = vim.opt

opt.nu = true
opt.relativenumber = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.smartindent = true

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.scrolloff = 8

opt.incsearch = true

opt.termguicolors = true
opt.colorcolumn = "80,120"

opt.updatetime = 50

opt.ic = true
opt.smartcase = true -- case sensitive search when uppercase letters typed

-- Highlight current row in insert mode
vim.cmd("autocmd InsertEnter * set cul")
vim.cmd("autocmd InsertLeave * set nocul")

-- spell checking in markdown files
vim.cmd("autocmd BufRead,BufNewFile *.md setlocal spell")

vim.g.mapleader = " "
