-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    -- LSP manager
    use({'mason-org/mason-lspconfig.nvim',
        requires = {
            {'neovim/nvim-lspconfig'},
            {'mason-org/mason.nvim'}
        },
        config = function()
            require('mason').setup()
            require('mason-lspconfig').setup()
        end
    })
    -- Autocomplete
    use('hrsh7th/nvim-cmp')
    use('hrsh7th/cmp-nvim-lsp')
    use('hrsh7th/cmp-buffer')
    use('hrsh7th/cmp-path')
    use('hrsh7th/cmp-cmdline')
    use('dense-analysis/ale')
    -- Comments
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }
    -- Snippets
    use('L3MON4D3/LuaSnip')

    --Telescope
    use {
        'nvim-telescope/telescope.nvim',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use({
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    })

    use('tpope/vim-fugitive')
	use {
		'nvim-treesitter/nvim-treesitter',
		run = function()
			local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
			ts_update()
		end,
	}
    use('theprimeagen/harpoon')
	use({
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({})
		end
	})
    use('mbbill/undotree')
    use { "beauwilliams/focus.nvim", config = function() require("focus").setup() end }
    use({ 'toppair/peek.nvim', run = 'deno task --quiet build:fast' })
    use({"kylechui/nvim-surround", tag = "*", config = function() require("nvim-surround").setup({}) end })
    use({
        'MeanderingProgrammer/render-markdown.nvim',
        after = { 'nvim-treesitter' },
        requires = { 'echasnovski/mini.nvim', opt = true }, -- if you use the mini.nvim suite
        -- requires = { 'echasnovski/mini.icons', opt = true }, -- if you use standalone mini plugins
        -- requires = { 'nvim-tree/nvim-web-devicons', opt = true }, -- if you prefer nvim-web-devicons
        config = function()
            require('render-markdown').setup({})
        end,
    })
    use ({"ziontee113/color-picker.nvim",
    config = function()
        require("color-picker")
    end
    })
    use('hat0uma/csvview.nvim')
    use('vimwiki/vimwiki')
    use({
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true },
        config = function ()
            require('lualine').setup({
                options = { theme = 'ayu_mirage' }
            })
        end
    })
    use('lewis6991/gitsigns.nvim')
end)
