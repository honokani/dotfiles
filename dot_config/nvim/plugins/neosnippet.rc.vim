let g:neosnippet#enable_snipmate_compatibility = 1
" Ctrl+Kにターゲットジャンプ割当
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
if has('conceal')
    set conceallevel=2 concealcursor=niv
endif

