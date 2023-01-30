" =================================================================== "
"          neovim must be setting for each language provider          "
" =================================================================== "
let g:python_host_prog=$PYENV_ROOT.'/versions/neovim2/bin/python'
let g:python3_host_prog=$PYENV_ROOT.'/versions/neovim3/bin/python'



if &compatible
  set nocompatible
endif


" =================================================================== "
"                       required dein setting:                        "
" =================================================================== "
let s:dein_dir = expand('$HOME/.config/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" install dein repository when nothing dein project for own pc
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

    " == any directory and anyfile's symbliclink settings == "
    let s:toml_dir = $HOME . '/.config/nvim/dein'
    let s:main_toml = s:toml_dir . '/dein.toml'
    let s:delay_toml = s:toml_dir . '/dein_lazy.toml'

    " == load dein setting files whitch contain the plugin list == "
    call dein#load_toml(s:main_toml, {'lazy': 0})
    call dein#load_toml(s:delay_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

" == automatically install any plug-ins that need to be installed == "
if dein#check_install()
 call dein#install()
endif

" == syntax setting == "
filetype plugin indent on
syntax enable

" ===================================================================="
"                           Checking keymapp                          "
" ===================================================================="
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap ss :<C-u>sp<CR><C-w>j
nnoremap sv :<C-u>vs<CR><C-w>l



" ===================================================================="
"                    more detail shell style setting                  "
" ===================================================================="
" line number
set number
set smartindent
set autoindent
set tabstop=2
set shiftwidth=2

" display executed command
set showcmd

" display title
set title

" カーソル
set ruler
set splitright
set clipboard=unnamed

set nobackup
set noswapfile
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%

" エンコーディング
set encoding=utf-8
scriptencoding utf-8

" init.vimを保存したら自動反映
autocmd BufWritePost  ~/.config/nvim/init.vim  so ~/.config/nvim/init.vim

" any more setting
" 検索結果のハイライト
set hlsearch
" コマンドライン補完の拡張
set wildmenu

" ヤンクするとクリップボードに保存される
set clipboard+=unnamed

" 補完のtabキー有効化
set nocompatible

" ===================================================== "
"                      test                             "
" ===================================================== "
function! ProfileCursorMove() abort
  let profile_file = expand('./log/vim-profile.log')
  if filereadable(profile_file)
    call delete(profile_file)
  endif

  normal! gg
  normal! zR

  execute 'profile start ' . profile_file
  profile func *
  profile file *

  augroup ProfileCursorMove
    autocmd!
    autocmd CursorHold <buffer> profile pause | q
  augroup END

  for i in range(100)
    call feedkeys('j')
  endfor
endfunction
