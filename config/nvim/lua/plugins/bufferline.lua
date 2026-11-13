  -- buffer line
  return {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = { "VeryLazy", "BufReadPre", "BufNewFile" },
    config = function()
      local bufferline = require("bufferline")
      bufferline.setup({
        options = {
          style_preset = bufferline.style_preset.minimal,
          always_show_bufferline = false,
          color_icons = true,
          diagnositcs = "nvim_lsp",
        }
      })
      
      local keymap = vim.api.nvim_set_keymap
      local opt = { noremap = true, silent = true }
      keymap("n", "gt", ":BufferLineCycleNext<CR>", opt)
      keymap("n", "gf", ":BufferLineCyclePrev<CR>", opt)
    end
  }
