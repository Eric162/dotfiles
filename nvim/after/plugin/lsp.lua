local lsp = require('lsp-zero').preset({})

lsp.ensure_installed({
    'tsserver',
    'eslint',
    -- 'rust-analyzer',
    -- 'lua-language-server',
    'svelte',

    -- TODO make sure these linters are installed
    -- 'eslint_d',
    -- 'selene',

    -- TODO make sure these formatters are installed
    -- 'rustfmt',
    -- 'jq',
    -- 'black',
    -- 'prettierd',
    -- 'stylua'
})

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

vim.keymap.set('n', '<leader>p', ':LspZeroFormat <CR>')
