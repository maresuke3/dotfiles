return {
  {
    "nvimdev/lspsaga.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
    },
    config = function()
      require("lspsaga").setup({
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
    end,
    keys = {
      {
        "<leader>gD",
        "<cmd>Lspsaga peek_definition<CR>",
      },
      {
        "<C-d>",
        "<cmd>Lspsaga term_toggle<cr>",
      },
    },
  },
}
