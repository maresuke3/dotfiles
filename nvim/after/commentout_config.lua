local status, comments = pcall(require, 'todo-comments')
if (not status) then
  print('not installed todo-comments')
  return
end

-- ハイライトグループを定義する
vim.cmd('highlight TodoCommentTodo guifg=#ffffff guibg=#FF8800')
vim.cmd('highlight TodoCommentFixme guifg=#ffffff guibg=#FF0000')
vim.cmd('highlight TodoCommentHack guifg=#ffffff guibg=#00FF00')
vim.cmd('highlight TodoCommentXXX guifg=#ffffff guibg=#0000FF')
vim.cmd('highlight TodoCommentPreview guifg=#ffffff guibg=#FF00FF')
vim.cmd('highlight TodoCommentOptimize guifg=#ffffff guibg=#FFFF00')
vim.cmd('highlight TodoCommentChanged guifg=#ffffff guibg=#00FFFF')
vim.cmd('highlight TodoCommentNote guifg=#ffffff guibg=#800080')
vim.cmd('highlight TodoCommentWarning guifg=#ffffff guibg=#FF8C00')

-- TODO-comments.nvimの設定
comments.setup {
  signs = true,
  sign_priority = 8,
  keywords = {
    FIX = {
      icon = " ",
      color = "TodoCommentFixme",
      alt = {
        "FIXME",
        "BUG",
        "FIXIT",
        "ISSUE",
      }
    },
    TODO = { icon = " ", color = "TodoCommentTodo", alt = { "NOTE" } },
    HACK = { icon = " ", color = "TodoCommentHack" },
    XXX = { icon = " ", color = "TodoCommentXXX", alt = { "DEBUG" } },
    PREVIEW = { icon = " ", color = "TodoCommentPreview", alt = { "PRE" } },
    OPTIMIZE = { icon = " ", color = "TodoCommentOptimize", alt = { "opt" } },
    CHANGED = { icon = " ", color = "TodoCommentChanged", alt = { "CHG" } },
    NOTE = { icon = " ", color = "TodoCommentNote", alt = { "INFO" } },
    WARNING = { icon = " ", color = "TodoCommentWarning", alt = { "WARN" } },
  },
  highlight = {
    -- カーソル行のハイライトを無効にする
    on_cursor = false,
  },
}
