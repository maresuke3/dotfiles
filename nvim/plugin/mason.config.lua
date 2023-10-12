local status, mason = pcall(require, 'mason')
if (not status) then return end

local status2, lspconfig = pcall(require, 'mason-lspconfig')
if (not status2) then return end

mason.setup({})

lspconfig.setup({
  ensure_installed = {
    "tsserver",
    "gopls",
    "pyright",
    "eslint",
    "diagnosticls",
    -- "poimports",
    -- "jedi-language-server",
    -- "sqls",
    -- "sql-formatter",
    -- "css-lsp",
    -- "tailwindcss-language-server"
  }
})

require('lspconfig').diagnosticls.setup({})
