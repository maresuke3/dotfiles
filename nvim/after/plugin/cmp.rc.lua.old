-- Lspkindのrequire
local status, lspkind = pcall(require,'lspkind')
if (not status) then
  print("not install lspkind")
end
--補完関係の設定
local staus2, cmp = pcall(require, "cmp")
if (not staus2) then
  print("not install cmp")
end
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp" },--ソース類を設定
    { name = 'vsnip' }, -- For vsnip users.
    { name = "buffer" },
    { name = "path" },
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(), --Ctrl+pで補完欄を一つ上に移動
    ["<C-n>"] = cmp.mapping.select_next_item(), --Ctrl+nで補完欄を一つ下に移動
    ["<Tab>"] = cmp.mapping.select_next_item(), --Tabで補完欄を一つずつ先に移動
    ['<C-l>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),--Ctrl+yで補完を選択確定
  }),
  experimental = {
    ghost_text = false,
  },
  -- Lspkind(アイコン)を設定
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
    })
  }
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' } --ソース類を設定
  }
})
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "path" }, --ソース類を設定
  },
})

vim.cmd([[
let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascript = ['javascriptreact']
let g:vsnip_filetypes.typescript = ['typescriptreact']
]])

vim.cmd([[
set completeopt=menuone,noinsert,noinsert
highlight! default link CmpItemKind CmpItemMenuDefault
]])
