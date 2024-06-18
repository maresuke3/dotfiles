local status, ccc = pcall(require, 'ccc')
if (not status) then
  print("ccc is not installed")
  return
end

ccc.setup({
  highlight = {
    auto_enable = true,
    max_byte = 100 * 1024,
    lsp = true,
  },
})

