set enc=utf-8
syntax enable
colorscheme elflord
"colorscheme default

set noswapfile
set nobackup
set nowritebackup

set belloff=all

set list
set ambiwidth=double
"set listchars=tab:≫-,trail:-,extends:≫,precedes:≪,nbsp:%,eol:↓,space:⁻
highlight NonText    ctermbg=NONE ctermfg=59 guibg=NONE guifg=NONE
highlight SpecialKey ctermbg=NONE ctermfg=59 guibg=NONE guifg=NONE


set scrolloff=5
set backspace=indent,eol,start
set softtabstop=4
set shiftwidth=4
set expandtab

set number
set ruler
set cursorcolumn
set cursorline
set relativenumber

set ignorecase
set smartcase

set history=10000
set hlsearch
set incsearch
set wrapscan
set gdefault
set shiftround




nnoremap <SPACE> <NOP>
nnoremap <BS> <NOP>
nnoremap l <NOP>
nnoremap h <NOP>
nnoremap Q <NOP>

function! SetVimrc() abort
    if filereadable( expand('~/.vimrc') )
        :execute ":e ~/.vimrc"
    endif
endfunction

if filereadable( expand('~/.vimrc') )
    nnoremap <SPACE>vt :call SetVimrc()<CR>
    nnoremap <SPACE>vr :source ~/.vimrc<CR>
endif

nnoremap : ;
nnoremap ; :
nnoremap q; q:
nnoremap Y y$
nnoremap <TAB> %

nnoremap j gj
nnoremap k gk

nnoremap <ESC><ESC> :nohlsearch<CR>
nnoremap <SPACE>f :e%:p:h<CR>
nnoremap <SPACE>ls :ls<CR>:buf<SPACE>

inoremap lll <ESC><RIGHT>
inoremap hhh <ESC><LEFT>
inoremap jj <ESC>
inoremap kk <ESC>
inoremap ｊｊ <ESC>
inoremap ｋｋ <ESC>

inoremap :w<CR> <ESC>:w<CR>
inoremap ;w<CR> <ESC>:w<CR>

tnoremap <ESC><ESC> <C-\><C-n>




let g:my_brackets_pair = { "(":")", "[":"]", "{":"}", "<":">", "'":"'", '"':'"', "`":"`" }
let g:my_brackets_reverse = {}
for [open, close] in items(g:my_brackets_pair)
    let g:my_brackets_reverse[close] = open
endfor

function! Make_map_trade_close( c1,c2 ) abort
    let b1 = g:my_brackets_reverse[a:c1]
    let b2 = g:my_brackets_reverse[a:c2]
    return ":\<C-u>call Check_and_trade('".b1."','".b2."')\<CR>"
endfunction

function! Make_map_auto( b2 ) abort
    return ":\<C-u>call Auto_detect_and_trade('".a:b2."')\<CR>"
endfunction

function! Detect_surrounding_bracket(target_bracket) abort
    let line = getline('.')
    let col = col('.')
    
    " カーソルがブラケット上にあるかチェック
    let brackets_to_check = a:target_bracket == '' ? keys(g:my_brackets_pair) : [a:target_bracket]
    for b1 in brackets_to_check
        let b1_right = g:my_brackets_pair[b1]
        if line[col-1] == b1 || line[col-1] == b1_right
            return b1
        endif
    endfor
    
    " 左右両方からスキャンして、両方でオープン状態のブラケットのみ採用
    let left_results = Search_bracket_direction(a:target_bracket, 1)
    let right_results = Search_bracket_direction(a:target_bracket, 0)
    let valid_brackets = []
    for bracket in keys(left_results)
        if has_key(right_results, bracket) && left_results[bracket].opening > 0 && right_results[bracket].opening > 0
            let range_size = abs(right_results[bracket].last_pos - left_results[bracket].last_pos)
            call add(valid_brackets, {'bracket': bracket, 'range': range_size})
        endif
    endfor
    
    " 最も小さい範囲のブラケットを返す
    if len(valid_brackets) > 0
        call sort(valid_brackets, {a, b -> a.range - b.range})
        return valid_brackets[0].bracket
    endif
    
    return ''
endfunction

function! Search_bracket_direction(target_bracket, from_left) abort
    let line = getline('.')
    let col = col('.')
    let line_len = len(line)
    
    let brackets_to_check = a:target_bracket == '' ? keys(g:my_brackets_pair) : [a:target_bracket]
    
    if a:from_left
        let start_pos = 0
        let increment = 1
    else
        let start_pos = line_len - 1
        let increment = -1
    endif
    let end_pos = col - 1
    
    " 各ブラケットの状態
    let bracket_state = {}
    for b1 in brackets_to_check
        let bracket_state[b1] = {'opening': 0, 'last_pos': -1}
    endfor
    
    " 方向に応じたスキャン
    let i = start_pos
    while ! (i==end_pos)
        for b1 in brackets_to_check
            let b1_right = g:my_brackets_pair[b1]
            if b1 == b1_right
                " quote系（open == close）は特別処理
                if line[i] == b1
                    if bracket_state[b1].opening == 0
                        let bracket_state[b1].opening = 1
                        let bracket_state[b1].last_pos = i
                    else
                        let bracket_state[b1].opening = 0
                        let bracket_state[b1].last_pos = i
                    endif
                endif
            else
                let open_char = a:from_left ? b1 : b1_right
                let close_char = a:from_left ? b1_right : b1
                
                if line[i] == open_char
                    let bracket_state[b1].opening += 1
                    let bracket_state[b1].last_pos = i
                elseif line[i] == close_char && bracket_state[b1].opening > 0
                    let bracket_state[b1].opening -= 1
                endif
            endif
        endfor
        let i += increment
    endwhile
    
    return bracket_state
endfunction

function! Auto_detect_and_trade(b2) abort
    let bracket = Detect_surrounding_bracket('')
    if bracket == ''
        echom "command S: Not IN bracket"
        return
    endif
    call Check_and_trade(bracket, a:b2)
endfunction

function! Check_and_trade(b1, b2) abort
    let line = getline('.')
    let col = col('.')
    let b1_right = g:my_brackets_pair[a:b1]
    let b2_right = g:my_brackets_pair[a:b2]

    " IF cursor in RIGHT brackt: jump LEFT
    if !(line[col-1] == a:b1)
        execute 'normal! %'
        let line = getline('.')
        let col = col('.')
    endif    

    if line[col-1] == a:b1 && line[col] == b1_right
        execute 'normal! r' . a:b2 . 'lr' . b2_right
    else
        execute 'normal! vi' . a:b1 . 'xr' . b2_right . "\<LEFT>r" . a:b2 . 'p'
    endif
endfunction

function! Setmap_bracket_trade( tgt ) abort
    " using 2 close brackets
    for c1 in values( g:my_brackets_pair )
        for c2 in values( g:my_brackets_pair )
            if c1==c2
                continue
            endif
            execute "nnoremap ".a:tgt.c1.c2." ".Make_map_trade_close(c1,c2)
        endfor
    endfor
    
    " using just 1 open bracket
    for k in keys( g:my_brackets_pair )
        execute "nnoremap ".a:tgt.k." ".Make_map_auto(k)
    endfor
endfunction


function! Make_v_map_wrap( b ) abort
    return "c".a:b.g:my_brackets_pair[a:b]."<ESC>P"
endfunction

function! Make_i_map_wrap( b ) abort
    return a:b.g:my_brackets_pair[a:b]."<LEFT>"
endfunction

function! Make_i_map_wrap_with_space( b ) abort
    return a:b."<SPACE><SPACE>".g:my_brackets_pair[a:b]."<LEFT><LEFT>"
endfunction

function! Make_i_map_quit( b ) abort
    return a:b."<ESC>"
endfunction

function! Make_i_map_do_nothing( b ) abort
    return "<NOP>"
endfunction

function! Setmap_bracket_kind( ) abort
    for k in keys( g:my_brackets_pair )
        execute "vnoremap ".k." ".Make_v_map_wrap(k)
        execute "inoremap ".k." ".Make_i_map_wrap(k)
        execute "inoremap ".k."jj ".Make_i_map_quit(k)
        execute "inoremap ".k."kk ".Make_i_map_quit(k)
        execute "inoremap ".k."<BS> ".Make_i_map_do_nothing(k)
        execute "inoremap ".k.g:my_brackets_pair[k]." ".k.g:my_brackets_pair[k]
    endfor
endfunction

nnoremap S <NOP>
:call Setmap_bracket_trade( "S" )
:call Setmap_bracket_kind()




let g:my_expand_val_hori = 16
let g:my_expand_val_vert = 6

function! Expand_cur_window( ) abort
    if tabpagewinnr(tabpagenr(), '$')==1
        " " just a window
    else
        let l:win_id_ls = g:Squash_window_dicts( winlayout() )
        let l:n_win_idx = tabpagewinnr( tabpagenr() ) - 1
        let l:way_to_win_cur = g:Find_path_of_cur_window( winlayout(), l:n_win_idx )
        let l:_ = g:Move_surrounding_separator( l:way_to_win_cur, l:win_id_ls, l:n_win_idx)
    endif
endfunction

function! Squash_window_dicts( ds ) abort
    let l:ls_r=[]
    if a:ds[0]=='col' || a:ds[0]=='row'
        for d in a:ds[1]
            for e in g:Squash_window_dicts( d )
                let l:ls_r = add( l:ls_r, e )
            endfor
        endfor
        return ls_r
    else
        return [a:ds[1]]
    endif
endfunction

function! Find_path_of_cur_window( ds, n_tgt ) abort
    return Find_path_core( a:ds, a:n_tgt )[1]
endfunction

function! Find_path_core( ds, n_tgt ) abort
    if a:ds[0]=='col' || a:ds[0]=='row'
        let l:cnt_to = 0
        let l:cnt_lo = 0
        for e in a:ds[1]
            let l:stt = g:Find_path_core(e, a:n_tgt-l:cnt_to)

            if l:stt[0]==0
                let l:cnt_to = l:cnt_to+l:stt[2]
            else
                if l:cnt_lo==0
                    let l:pos_tmb = [a:ds[0],"t",l:cnt_to]
                elseif l:cnt_lo==len(a:ds[1])-1
                    let l:pos_tmb = [a:ds[0],"b",l:cnt_to]
                else
                    let l:pos_tmb = [a:ds[0],"m",l:cnt_to]
                endif
                let l:add_rc = add(l:stt[1],l:pos_tmb)
                return [1,l:add_rc,0]
            endif
            let l:cnt_lo = l:cnt_lo+1
        endfor
        return [0,[],l:cnt_to]
    else
        if a:n_tgt==0
            return [1,[],1]
        else
            return [0,[],1]
        endif
    endif
endfunction

function! Move_surrounding_separator( ways, id_ls, n_win_idx ) abort
    let n_nest = len(a:ways)
    let l:_ = g:Move_win_separator_L( l:n_nest, a:ways, a:id_ls, a:n_win_idx)
    let l:_ = g:Move_win_separator_T( l:n_nest, a:ways, a:id_ls, a:n_win_idx)
    execute ":execute win_gotoid(".a:id_ls[a:n_win_idx].")"
    let l:_ = g:Move_win_separator_R( l:n_nest, a:ways, a:id_ls, a:n_win_idx)
    let l:_ = g:Move_win_separator_B( l:n_nest, a:ways, a:id_ls, a:n_win_idx)
endfunction

function! Move_win_separator_L( n, ws, id_ls, id_idx ) abort
    let l:w = a:ws[0]
    if l:w[0]=='row'
        if l:w[1]=='t'
            if a:n < 3
                return 0
            else
                let l:n_back=1+a:ws[1][2]
            endif
        else
            let l:n_back=1
        endif
    elseif l:w[0]=='col'
        if a:n < 2
            return 0
        else
            let l:n_back=1+l:w[2]
        endif
    endif
    execute ":execute win_gotoid(".a:id_ls[a:id_idx-l:n_back].")"
    execute ":execute win_move_separator(winnr(),-".g:my_expand_val_hori.")"
endfunction

function! Move_win_separator_T( n, ws, id_ls, id_idx ) abort
    let l:w = a:ws[0]
    if l:w[0]=='row'
        if a:n < 2
            return 0
        else
            let l:n_back=1+l:w[2]
        endif
    elseif l:w[0]=='col'
        if l:w[1]=='t'
            if a:n < 3
                return 0
            else
                let l:n_back=1+a:ws[1][2]
            endif
        else
            let l:n_back=1
        endif
    endif
    execute ":execute win_gotoid(".a:id_ls[a:id_idx-l:n_back].")"
    execute ":resize -".g:my_expand_val_vert.""
endfunction

function! Move_win_separator_R( n, ws, id_ls, id_idx ) abort
    let l:w = a:ws[0]
    if l:w[0]=='row'
        if l:w[1]=='b'
            if a:n < 3
                return 0
            else
                " " todo
                return 0
            endif
        endif
    elseif l:w[0]=='col'
        if a:n < 2
            return 0
        endif
    endif
    execute ":execute win_move_separator(winnr(),".g:my_expand_val_hori.")"
endfunction

function! Move_win_separator_B( n, ws, id_ls, id_idx ) abort
    let l:w = a:ws[0]
    if l:w[0]=='row'
        if a:n < 2
            return 0
        endif
    elseif l:w[0]=='col'
        if l:w[1]=='b'
            if a:n < 3
                return 0
            else
                " " todo
                return 0
            endif
        endif
    endif
    execute ":resize +".g:my_expand_val_vert.""
endfunction

nnoremap s <NOP>
nnoremap sh :split<CR>
nnoremap sv :vsplit<CR>
nnoremap sd <C-w>w
nnoremap sa <C-w><S-w>
nnoremap ss 5<C-w>h
nnoremap se :execute Expand_cur_window()<CR>
nnoremap sx <C-w>=




augroup netrw_mapping
    autocmd!
    autocmd filetype netrw call NetrwMapping()
augroup END

function! NetrwMapping()
    noremap <buffer> sh :split<CR>
    noremap <buffer> sv :vsplit<CR>
    nmap <buffer> h -
    nmap <buffer> l <CR>
endfunction

highlight ColorColumn ctermbg=236 ctermfg=240 guibg=NONE guifg=NONE
augroup changeBG
    autocmd!
    autocmd WinEnter * setlocal wincolor=Normal
    autocmd WinLeave * setlocal wincolor=ColorColumn
augroup END

