let g:vimfiler_as_default_explorer=1
let g:vimfiler_ignore_pattern='\(^\.\|\~$\|\.pyc$\|\.[oad]$\)'
let g:neoterm_size = 30

nnoremap [SP]     <Nop>
nmap     <Space>  [SP]
nnoremap <Space>g :VimFiler ~ -split -simple -winwidth=30 -no-quit<CR><C-W>w
nnoremap <Space>h :VimFilerCurrentDir -split -simple -winwidth=30 -no-quit<CR><C-W>w



nnoremap t <Nop>
nnoremap tc :Tnew
nnoremap tt :T cd `dirname %`<CR>
nnoremap tp :T python %<CR>

nnoremap tgb :T echo hi<CR>

