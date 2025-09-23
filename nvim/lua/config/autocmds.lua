local create_cmd = vim.api.nvim_create_autocmd

create_cmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

create_cmd("FileType", {
  pattern = {
    "json",
    "jsonc",
    "yaml",
    "toml",
    "tml",
    "mod",
    "sum",
  },
  callback = function()
    vim.wo.conceallevel = 0
  end,
})
