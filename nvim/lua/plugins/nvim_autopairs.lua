return {
  "windwp/nvim-autopairs",
  event = { "BufNewFile", "BufReadPre" },
  config = function()
    require("nvim-autopairs").setup({})
    --require("extensions.nvim-autopairs")
  end,
}
