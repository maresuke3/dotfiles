local status, mason = pcall(require, 'mason')
if (not status) then return end

local status2, lspconfig = pcall(require, 'mason-lspconfig')
if (not status2) then return end

mason.setup({})

lspconfig.setup({
  ensure_installed = {
    "lua-language-server",
    "typescript-language-server",
    "eslint-lsp",
    "prettier",
    "gopls",
    "poimports",
    "jedi-language-server",
    "sqls",
    "sql-formatter",
    "css-lsp",
    "tailwindcss-language-server"
  }
})
