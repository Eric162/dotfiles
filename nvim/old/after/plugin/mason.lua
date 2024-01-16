local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.completion.spell,
    },
})

require("mason").setup({
    ensure_installed = {
        -- make sure these linters are installed
        'eslint_d',
        'selene',

        -- make sure these formatters are installed
        'rustfmt',
        'jq',
        'black',
        'prettierd',
        'stylua'
    }
})

require("mason-null-ls").setup({
    automatic_setup = true,
})
