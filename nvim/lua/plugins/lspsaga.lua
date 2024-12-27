return {

  -- lsp action support
  {
    "nvimdev/lspsaga.nvim",
    lazy = true,
    keys = { -- lspsaga's keymaps
      { "K", "<cmd>Lspsaga hover_doc<cr>" },
      { "gr", "<cmd>Lspsaga lsp_finder ref<cr>" },
      { "gD", "<cmd>Lspsaga peek_definition<CR>" },
      { "ga", "<cmd>Lspsaga code_action<cr>" },
      { "gn", "<cmd>Lspsaga rename<cr>" },
      { "ge", "<cmd>Lspsaga show_line_diagnostics<cr>" },
      { "[e", "<cmd>Lspsaga diagnostic_jump_next<cr>" },
      { "]e", "<cmd>Lspsaga diagnostic_jump_prev<cr>" },
      -- vim.keymap.set("n", ";sf", "<cmd>Lspsaga open_floaterm<CR>")
      -- vim.keymap.set("n", "<C-d>", "<cmd>Lspsaga term_toggle<CR>")
    },
    config = function()
      require("lspsaga").setup({
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
            vsplit = "v",
          },
        },
      })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
}
