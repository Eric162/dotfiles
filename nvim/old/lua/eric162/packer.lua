local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

    if fn.empty(fn.glob(install_path)) > 0 then
        print('packer not found, installing')
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    -- My plugins here
    use 'navarasu/onedark.nvim'
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })
    use 'nvim-treesitter/playground'

    use({
        'williamboman/mason.nvim',
        run = function()
            pcall(vim.cmd, 'MasonUpdate')
        end,
    })

    use({
        "jay-babu/mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        requires = {
            { "jose-elias-alvarez/null-ls.nvim" },
        },
    })

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },             -- Required

            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required
        }
    }

    use({
        "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    })

    use 'mbbill/undotree'

    -- git
    use 'tpope/vim-fugitive'
    use 'airblade/vim-gitgutter'

    use({
        'nvim-tree/nvim-tree.lua',
        requires = {
            -- Optional
            { 'nvim-tree/nvim-web-devicons' },
        },
        config = function()
            -- empty setup using defaults
            require("nvim-tree").setup({})
        end
    })


    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
