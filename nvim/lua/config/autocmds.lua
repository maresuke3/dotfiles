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
  
-- local ts_group = vim.api.nvim_create_augroup("TreesitterHighlight", {clear = true})
-- 
-- vim.api.nvim_create_autocmd("FileType", {
--   group = ts_group,
--   pattern = {
--     "go",
--     "javascript", "javascriptreact",
--     "typescript", "typescriptreact",
--     "json", "jsonc",
--     "toml",
--     "yaml",
--     "markdown", "markdown_inline",
--     "lua",
--     "dockerfile"
--   },
--   callback = function ()
--     pcall(vim.treesitter.start)
--   end;
--   end;
-- })

-- ホバー時（カーソルが少し止まった時）にエラーの詳細を自動でフロート表示する
create_cmd("CursorHold", {
  pattern = "*",
  callback = function()
    vim.diagnostic.open_float(nil, {
      focusable = false,
      scope = "cursor",
      close_events = { "CursorMoved", "CursorMovedI", "InsertEnter", "BufLeave" }
    })
  end,
})
