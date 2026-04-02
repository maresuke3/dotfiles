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

vim.opt.autoread = true
-- create_cmd({
--   "BufEnter",
--   "CursorHold",
--   "FocusGained",
-- }, {
--   --pattern = "*",
--   command = "if !vim.b.is_gemini_buffer | checktime | endif",
--   desc = "自動的に外部ファイル変更を読み込む",
-- })
