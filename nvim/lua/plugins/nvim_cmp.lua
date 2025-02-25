return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp_luasnip",
      "hrsh7th/cmp-calc",
      "hfsh7th/cmp-emoji",
      "L3MON4D3/LuaSnip",
    },
    enable = true,
    opts = function(_, opts)
      table.insert(opts.sources, {
        name = {
          "emoji",
          "copilot",
        },
      })
    end,
  },
}
