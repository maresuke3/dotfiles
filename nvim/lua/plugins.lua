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
    'mfussenegger/nvim-lint',
    'mhartington/formatter.nvim',
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui'
  }

  -- lsp sapport
  use({
    'nvimdev/lspsaga.nvim',
    after = 'nvim-lspconfig',
    config = function()
      require('lspsaga').setup({
        border_style = "single",
        symbol_in_winbar = {
          enabled = false,
          icon = "",
          -- symbol used for show diagnostic in the winbar
          -- by default: ''
        },
        code_action_lightbulb = {
          enable = true,
        },
        show_outline = {
          win_width = 50,
          auto_preview = false,
        },
        finder = {
          max_height = 0.6,
          keys = {
            vsplit = 'v',
          }
        }
      })
    end,
  })
  -- github copilot
  use({
    'github/copilot.vim',
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.api.nvim_set_keymap(
        "i",
        "<C-g>",
        'copilot#Accept("<CR>")',
        { silent = true, expr = true, script = true, replace_keycodes = false }
      )

      local keymap = vim.keymap.set

      --
      keymap("i", "<C-j>", "<Plug>(copilot-next)")
      keymap("i", "<C-k>", "<Plug>(copilot-previous)")
      keymap("i", "<C-o>", "<Plug>(copilot-dismiss)")
      keymap("i", "<C-s>", "<Plug>(copilot-suggest)")
    end,
  })
  -- file tree
  use {
    'nvim-neo-tree/neo-tree.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim'
    },
    config = function()
      require('neo-tree').setup({
        filesystem = {
          filtered_items = {
            visible = true,
            show_hidden_count = true,
            hide_dotfiles = false,
            hide_gitignore = true,
            never_show = {}
          }
        }
      })
    end,
  }

  -- syntax highlight
  use 'nvim-treesitter/nvim-treesitter'

  use {
    "nvim-telescope/telescope-file-browser.nvim",
    requires = {
      "nvim-telescope/telescope.nvim",
      --"nvim-telescope/telescope-fzf-native.nvim",
      "nvim-lua/plenary.nvim"
    },
  }

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
  use({
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    requires = {
      "nvim-lua/plenary.nvim",
    },
  })

  -- anotation comment
  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim"
  }

  -- toggle terminal
  use {
    'akinsho/toggleterm.nvim',
    tag = '*',
    config = function()
      require('toggleterm').setup()
    end
  }

  -- color theme
  use('Tsuzat/NeoSolarized.nvim')

  -- colorhighliter
  use 'uga-rosa/ccc.nvim'

  -- markdown auto_preview
  use("echasnovski/mini.nvim", { opt = true })
  use({
    'MeanderingProgrammer/render-markdown.nvim',
    after = { 'nvim-treesitter' },
    requires = {
      'echasnovski/mini.nvim',
      opt = true
    },
    config = function()
      require('render-markdown').setup({})
    end
  })

  --use {
  --  "3rd/image.nvim",
  --  config = function()
  --    require("image").setup({
  --      markdown = {
  --        enable = true,
  --      }
  --    })
  --  end,
  --}
  --use {
  --  "3rd/diagram.nvim",
  --  requires = { "3rd/image.nvim" },
  --  config = function()
  --    require("diagram").setup({
  --      integrations = {
  --        require("diagram.integrations.markdown"),
  --        require("diagram.integrations.neorg"),
  --      },
  --      render_options = {
  --        mermaid = {
  --          background = "transparent",
  --          theme = "dark",
  --          scale = 1,
  --        },
  --        plantuml = {
  --          charset = "utf-8",
  --        },
  --        d2 = {
  --          theme_id = 1,
  --          dark_theme_id = 200,
  --          scale = -1,
  --          layout = nil,
  --          sketch = nil,
  --        }
  --      }
  --    })
  --  end,
  --}
end)
