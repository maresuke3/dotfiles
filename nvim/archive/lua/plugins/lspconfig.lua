return {
  {
    "williamboman/mason-lspconfig.nvim",
    --lazy = true,
    --opts = function(_, opts)
    --  vim.list_extend(opts.ensure_installed, {
    --    "lua-language-server",
    --    "stylua",
    --    "spellcheck",
    --    "shfmt",
    --    "gopls",
    --    "golangci_ci_lint_ls",
    --    "tailwindcss-language-server",
    --    "biome",
    --    "prettier",
    --    "typesctipt-language-server",
    --    "css-lsp",
    --    "eslint",
    --  })
    --end,
    opts = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "diagnosticls",
          "lua_ls",
          "cssls",
          "tailwindcss",
          "docker_compose_language_server",
          "dockerls",
          "gopls",
          "golangci_ci_lint_ls",
          "html",
          "twiggy_language_server",
          "biome",
          "ts_ls",
          "eslint",
          "vtsls",
          "jqls",
          "jsonls",
          --"ast_grep",
          "remark_ls",
          "intelephense",
          "bashls",
          "sqlls",
          "sqls",
          "terraformls",
          "yamlls",
        },
      })
    end,
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
  },
}
