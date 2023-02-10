local on_attach = function(client, bufnr)
  local set = vim.keymap.set
  set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  set("n", "<C-m>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  set("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
  set("n", "rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
  set("n", "ma", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
  set("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
  set("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
  set("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
end

-- local status, mason = pcall(require, 'mason')
-- if (not status) then return end
-- local status2, mason_lspconfig = pcall(require, 'mason-lspconfig')
-- if (not status2) then return end
-- local status3, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
-- if (not status3) then return end

-- local capabilities = cmp_nvim_lsp.default_capabilities()

-- mason.setup()
-- mason_lspconfig.setup()
-- mason_lspconfig.setup_handlers {
--   function (server_name)
--     require("lspconfig")[server_name].setup {
--       on_attach = on_attach,
--       capabilities = capabilities,
--     }
--   end
-- }
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers {
  function (server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup {
      on_attach = on_attach, --keyバインドなどの設定を登録
      capabilities = capabilities, --cmpを連携
    }
  end,
}