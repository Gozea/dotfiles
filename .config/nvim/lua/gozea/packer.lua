-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'
    use{'mason-org/mason-lspconfig.nvim',
        requires = {
            {'neovim/nvim-lspconfig'},
            {'mason-org/mason.nvim'}
        },
        config = function()
            require('mason-lspconfig').setup()
        end,
    }

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

	use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
	use('nvim-treesitter/playground')
	use('theprimeagen/harpoon')
	use('mbbill/undotree')
	use('tpope/vim-fugitive')
	--use {
	--	'VonHeikemen/lsp-zero.nvim',
	--	branch = 'v1.x',
	--	requires = {
	--		-- LSP Support
	--		{'neovim/nvim-lspconfig'},             -- Required
	--		{'williamboman/mason.nvim'},           -- Optional
	--		{'williamboman/mason-lspconfig.nvim'}, -- Optional

	--		-- Autocompletion
	--		{'hrsh7th/nvim-cmp'},         -- Required
	--		{'hrsh7th/cmp-nvim-lsp'},     -- Required
	--		{'hrsh7th/cmp-buffer'},       -- Optional
	--		{'hrsh7th/cmp-path'},         -- Optional
	--		{'saadparwaiz1/cmp_luasnip'}, -- Optional
	--		{'hrsh7th/cmp-nvim-lua'},     -- Optional

	--		-- Snippets
	--		{'L3MON4D3/LuaSnip'},             -- Required
	--		{'rafamadriz/friendly-snippets'}, -- Optional
	--	}
	--}
    use { "beauwilliams/focus.nvim", config = function() require("focus").setup() end }
    use({ 'toppair/peek.nvim', run = 'deno task --quiet build:fast' })
    use({"kylechui/nvim-surround", tag = "*", config = function() require("nvim-surround").setup({}) end })
    -- use({
    --   "epwalsh/obsidian.nvim",
    --   tag = "*",  -- recommended, use latest release instead of latest commit
    --   requires = {
    --     -- Required.
    --     "nvim-lua/plenary.nvim",

    --     -- see below for full list of optional dependencies 👇
    --   },
    --   config = function()
    --     require("obsidian").setup({
    --       workspaces = {
    --         {
    --           name = "personal",
    --           path = "~/Reports/personal",
    --         },
    --       },

    --       -- see below for full list of options 👇
    --     })
    --   end,
    -- })
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
    end,
    })
	use('hat0uma/csvview.nvim')
end)
