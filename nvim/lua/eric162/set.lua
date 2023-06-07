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

vim.g.mapleader = " "
