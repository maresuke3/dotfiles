local status, lsp = pcall(require, 'lspconfig')
if (not status) then return end

local proto = require('vim.lsp.protocol')

local on_attach = function(client, bufnr)
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ bufnr = bufnr })]]
    vim.api.nvim_command [[augroup END]]
  end
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true, silent = true})
end

lsp.tsserver.setup {
  on_attach = on_attach,
  --filetypes = {
  --  "typescript",
  --  "typescriptreact",
  --  "typescript.tsx",
  --  "javascript",
  --  "javascriptreact",
  --  "javascript.jsx"
  --},
  cmd = {
    "typescript-language-server",
    "--stdio"
  },
  root_dir = lsp.util.root_pattern(".node_modules", "package.json", "yarn.lock", ".git")
}

lsp.gopls.setup {
  on_attach = on_attach,
  cmd = {
    "gopls",
    "serve"
  },
  root_dir = lsp.util.root_pattern("go.mod"),
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
}

lsp.lua_ls.setup {
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = {'vim'}
      },

      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      }
    }
  }
}
