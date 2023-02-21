print("load auto pairs")
local status, autopairs = pcall(require, "nvim-autopairs")
if (not status) then
  print("not installed autopairs")
  return
end



autopairs.setup({
  disable_filetype = { "TelescopePrompt" , "vim" },
})

