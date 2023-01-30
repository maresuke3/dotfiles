function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction


" autocomplete
inoremap <silent><expr> <C-j> coc#pum#visible() ? coc#pum#next(1) : "\<C-j>"
inoremap <silent><expr> <C-k> coc#pum#visible() ? coc#pum#prev(1) : "\<C-k>"
inoremap <silent><expr> <Enter> coc#pum#visible() ? coc#pum#confirm() : "\<Enter>"
inoremap <silent><expr> <Esc> coc#pum#visible() ? coc#pum#cancel() : "\<Esc>"
inoremap <silent><expr> <C-h> coc#pum#visible() ? coc#pum#cancel() : "\<C-h>"


" Definition jump
nmap <silent> gd <Plug>(coc-definition)


" format runner
nmap <silent> fmt <Plug>(coc-format)

" screen split definition jump
function! ChoseAction(actions) abort
  echo join(map(copy(a:actions), { _, v -> v.text }), ", ") .. ": "
    let result = getcharstr()
    let result = filter(a:actions, { _, v -> v.text =~# printf(".*\(%s\).*", result)})
    return len(result) ? result[0].value : ""
endfunction

function! CocJumpAction() abort
  let actions = [
    \ {"text": "(s)plit", "value": "split"},
    \ {"text": "(v)slit", "value": "vsplit"},
    \ {"text": "(t)ab", "value": "tabedit"},
    \ ]
  return ChoseAction(actions)
endfunction
nnoremap <silent> <C-t> :<C-u>call CocActionAsync('jumpDefinition', CocJumpAction())<CR>



"<Tab>で次、<S+Tab>で前
inoremap <silent><expr> <TAB>
  \ coc#pum#visible() ? coc#pum#next(1):
  \ <SID>check_back_space() ? "\<Tab>" :
  \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<S-TAB>" " "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()


" lsp setting
let g:coc_global_extensions = [
    \ 'coc-go',
    \ 'coc-tsserver',
    \ 'coc-prettier',
    \ 'coc-eslint',
    \ '@yaegassy/coc-tailwindcss3',
    \ 'coc-jedi',
    \ 'coc-json',
    \ 'coc-toml',
    \ 'coc-yaml',
    \ 'coc-sql',
    \ 'coc-vimlsp',
    \ 'coc-docker',
    \ 'coc-markdownlint',
    \ 'coc-spell-checker',
    \ ]
