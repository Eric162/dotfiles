vim.keymap.set("n", "<leader>w", ":tabclose <CR>")


vim.keymap.set("n", "j", "jzz")
vim.keymap.set("n", "k", "kzz")
vim.keymap.set("n", "G", "Gzz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "}", "}zz")
vim.keymap.set("n", "{", "{zz")

-- these should allow moving entire lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- format a file
vim.keymap.set("x", "<leader>p", [["_dP_dP]])

vim.keymap.set("n", "Q", "<nop>")
