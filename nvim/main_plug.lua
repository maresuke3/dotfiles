return {
  -- color theme
  {
    'Tsuzat/NeoSolarized.nvim',
  },

  -- plugin manager
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "NeoSolarized",
    }
  },

  {
    "folke/trouble.nvim",
    opts = {
      use_diagnostic_signs = true,
    }
  },

  {
    "folke/trouble.nvim",
    opts = {
      enable = false,
    }
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
      }
    end,
  }

}
