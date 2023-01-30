print('dein')
local set_var = vim.api.nvim_set_var

-- 自動でdein#recache_runtimepath()する
set_var('dein#auto_recache', 1)

-- neovimのリモートプラグインを遅延読み込み
set_var('dein#lazy_rplugins', 1)
set_var('dein#enable_notification', 1)
set_var('dein#install_max_processes', 16)
set_var('dein#install_message_type', 'none')
set_var('dein#enable_notification',1)

local dein_dir = vim.env.HOME .. '/.config/dein'
local dein_repo_dir = dein_dir .. '/repo/github.com/Shougo/dein.vim'

if not string.match(vim.o.runtimepath, 'dein.vim') then
  if vim.fn.isdirectory(dein_repo_dir) ~= 1 then
    os.execute('git clone https://github.com/Shougo/dein.vim '..dein_repo_dir)
  end
  vim.o.runtimepath = dein_repo_dir .. ',' .. vim.o.runtimepath
end

if vim.call('dein#load_state', dein_dir) == 1 then
  local toml_dir = vim.env.HOME .. '/.config/nvim/dein'
  local main_toml = toml_dir .. '/dein.toml'
  local lazy_toml = toml_dir .. '/dein_lazy.toml'

  -- 削除済みのプラグインのキャッシュが残っている場合に削除する
  vim.call('dein#recache_runtimepath')

  vim.call('dein#begin', dein_dir, {vim.fn.expand('<sfile>'), main_toml, lazy_toml})

  vim.call('dein#load_toml', main_toml, {lazy = 0})
  vim.call('dein#load_toml', lazy_toml, {lazy = 1})

  vim.call('dein#end')
  vim.call('dein#save_state')
end

-- if vim.call('dein#check_install') then
--   vim.call('dein#install')
-- end