return {
  "nvim-treesitter/nvim-treesitter",
  lazy = true,
  event = "LspAttach",
  config = function()
    require("nvim-treesitter.configs").setup{
      ensure_installed = {
        "cmake",
        "html",
        "css",
        "go",
        "gitignore",
        "markdown",
        "markdown_inline",
        "php",
        "sql",
        "typescript",
        "tsx",
        "json",
        "lua",
        "yaml",
      },
      auto_install = true,
      ignore_install = { "javascript" },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      }
    }
  end,
}
