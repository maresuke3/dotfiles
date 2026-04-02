return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    -- config
    config = function ()
      require("luasnip.loaders.from_lua").load({
        paths = {"~/dotfiles/nvim/luasnippets"}
      })
      require("luasnip.loaders.from_vscode").load()
    end,
  }
}
