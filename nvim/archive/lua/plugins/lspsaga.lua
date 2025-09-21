return {
  {
    "nvimdev/lspsaga.nvim",
    config = function()
      require("lspsaga").setup({
        definition = {
          keys = {
            edit = "o",
          },
        },
        diaagnostic = {
          max_height = 0.8,
          keys = {
            quit = { "q", "<esc>" },
          },
        },
        finder = {
          max_hegiht = 0.6,
          keys = {
            vsplit = "v",
          },
        },
      })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "<leader>gr",
        ":Lspsaga finder ref<cr>",
      },
      {
        "<leader>gD",
        ":Lspsaga definition<cr>",
      },
      {
        "<C-d>",
        "<cmd>Lspsaga term_toggle<cr>",
      },
      {
        "K",
        "<cmd>Lspsaga hover_doc<cr>",
      },
      {
        "rn",
        ":Lspsaga rename<cr>",
      },
    },
  },
}
