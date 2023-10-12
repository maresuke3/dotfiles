local status, mason = pcall(require, 'mason')
if (not status) then
  print('not install mason')
  return
end

local status2, mason_lsp = pcall(require, 'mason-lspconfig')
if (not status2) then
  print('not install mason-lspconfig')
  return
end

local status3, lsp = pcall(require, 'lspconfig')
if (not status3) then
  print('not install nvim-lspconfig')
  return
end

mason.setup ({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

mason_lsp.setup {
  ensure_installed = {
    "gopls",
    "tsserver",
  },
  automatic_installation = false,
  handlers = nil
}

mason_lsp.setup_handlers ({
  function(server_name)
    local opts = {}
    opts.on_attach = function(client, bufnr)
      local bufopts = { silent = true, buffer = bufnr }
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
      vim.keymap.set('n', 'gtD', vim.lsp.buf.type_definition, bufopts)
      vim.keymap.set('n', 'gR', vim.lsp.buf.references, bufopts)
      vim.keymap.set('n', '<space>p', vim.lsp.buf.format, bufopts)
    end
    lsp[server_name].setup(opts)
  end,
})
