local status, packer = pcall(require, 'packer')
if (not status) then
  print("Packer is not installed")
  return
end

vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'windwp/nvim-autopairs'

  -- status line
  use {
    'nvim-lualine/lualine.nvim',
    requires = {
      'kyazdani42/nvim-web-devicons',
      opt = true
    },
  }

  -- nvim-tree
  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons'}
  }

  -- lsp
  use {
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  }

  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp_luasnip',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-emoji',
      'hrsh7th/vim-vsnip',
      'hrsh7th/cmp-vsnip',
      'onsails/lspkind.nvim',
    }
  }

  -- Fuzy finder
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    requires = {
      {'nvim-lua/plenary.nvim'},
      {'nvim-telescope/telescope-file-browser.nvim', opt = true},
      {'nvim-telescope/telescope-ghq.nvim', opt = true },
      {'nvim-telescope/telescope-z.nvim', opt = true },
    },
    wants = {
      "telescope-file-browser.nvim",
      "telescope-ghq.nvim",
      "telescope-z.nvim",
    },
  }

  -- nvim-treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    tun = ':TSUpdate'
  }

  -- copilot
  use {
    'github/copilot.vim',
    requires = {
      'nvim-treesitter/nvim-treesitter'
    }
  }

  -- comment out
  use 'preservim/nerdcommenter'

end)
