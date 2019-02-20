let g:vimfiler_as_default_explorer=1
let g:vimfiler_ignore_pattern='\(^\.\|\~$\|\.pyc$\|\.[oad]$\)'
let g:neoterm_size = 30

nnoremap  <Space>h  :VimFilerCurrentDir -split -simple -winwidth=30 -no-quit<CR><C-W>w
nnoremap  <Space>H  :VimFiler ~         -split -simple -winwidth=30 -no-quit<CR><C-W>w

" nnoremap t  <Nop>
" nnoremap tt  :T cd `dirname %`<CR>

