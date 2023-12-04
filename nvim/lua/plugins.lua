local status, packer = pcall(require, 'packer')
if (not status) then
  print("Packer is not installed")
  return
end

vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- lsp
  use {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
  }

  -- lsp sapport
  use({
    'nvimdev/lspsaga.nvim',
    after = 'nvim-lspconfig',
  })

  -- syntax highlight
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use {
    "nvim-telescope/telescope-file-browser.nvim",
    requires = {
      "nvim-telescope/telescope.nvim",
      --"nvim-telescope/telescope-fzf-native.nvim",
      "nvim-lua/plenary.nvim"
    },
  }
  -- use {
  --   "glepnir/lspsaga.nvim",
  --   opt = true,
  --   branch = "main",
  --   event = "LspAttach",
  --   requires = {
  --     {"nvim-tree/nvim-web-devicons"},
  --     --Please make sure you install markdown and markdown_inline parser
  --     {"nvim-treesitter/nvim-treesitter"}
  --   }
  -- }

  -- auto tag or pair
  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'

  -- status line
  use 'kyazdani42/nvim-web-devicons'
  use {
    'nvim-lualine/lualine.nvim',
    requires = {
      'kyazdani42/nvim-web-devicons',
      opt = true
    }
  }

  -- auto complete
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-emoji',
      'hrsh7th/vim-vsnip',
      'hrsh7th/cmp-vsnip',
      'onsails/lspkind.nvim',
    }
  }

  -- snipet
  use 'L3MON4D3/LuaSnip'

  -- git
  use {
    'lewis6991/gitsigns.nvim',
    'dinhhuy258/git.nvim',
  }

  -- anotation comment
  use {
    "folke/todo-comments.nvim"
  }

  -- color theme
  use {
    'svrana/neosolarized.nvim',
    requires = { 'tjdevries/colorbuddy.nvim' }
  }
end)
