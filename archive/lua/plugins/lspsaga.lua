return {
  {
    "nvimdev/lspsaga.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
    },
    lazy = false,
    config = function()
      local saga = require("lspsaga")
      local setKeymaps = vim.keymap
      local opts = { noremap = true, silent = true }
      saga.setup({
        definition = {},
        diagnostic = {
          max_height = 0.8,
          keys = {
            quit = { "q", "<ESC>" },
          },
        },
        finder = {
          max_hegit = 0.6,
          keys = {
            vsplit = "v",
          },
        },
      })
      setKeymaps.set("n", "<C-d>", "<cmd>Lspsaga term_toggle<CR>", opts)
      setKeymaps.set("n", "<leader>gD", "<cmd>Lspsaga peek_definition<CR>", opts)
      setKeymaps.set("n", "<leader>gtd", "<cmd>Lspsaga peek_type_definition<CR>", opts)
    end,
    --keys = {
    --  {
    --    "<leader>gD",
    --    "<cmd>Lspsaga peek_definition<CR>",
    --  },
    --  {
    --    "<leader>gtd",
    --    "<cmd>Lspsaga peek_type_definition<CR>",
    --  },
    --  {
    --    "<C-d>",
    --    "<cmd>Lspsaga term_toggle<CR>",
    --  },
    --},
  },
}
