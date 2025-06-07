return {
  "akinsho/toggleterm.nvim",
  lazy = false,
  version = "",
  opts = {
    size = 10,
    open_mapping = {
      [[<c-\>]],
    }
  },
  keys = {
    { [[<c-\>]], ":ToggleTerm<CR>" },
    { [[<c-d>]], ":ToggleTerm direction=float<CR>" },
    { [[<c-n>]], ":ToggleTerm direction=tab<CR>" },
  },
  --cmd = "ToggleTerm",
}
