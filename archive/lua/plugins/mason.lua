return {
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = function()
      local mconfig = require("mason-lspconfig")

      mconfig.setup({
        ensure_installed = {
          "diagnositcs",
          "lua_ls",
          "cssls",
          "tailwindcss",
          "docker_compose_language_server",
          "dockerls",
          "gopls",
          "golangci_lint_ls",
          --"golangci_ci_lint_ls",
          "html",
          "twiggy_language_server",
          "biome",
          "ts_ls",
          "eslint",
          "vtsls",
          "jqls",
          "jsonls",
          "remark_ls",
          "intelephense",
          "bashls",
          "sqlls",
          "terraformls",
          "yamlls",
        },
      })
    end,
  },
}
