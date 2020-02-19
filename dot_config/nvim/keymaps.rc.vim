if filereadable( expand('~/.config/nvim/keymaps.functions.vim') )
    source ~/.config/nvim/keymaps.functions.vim
    cnoremap      ;             :call JumpAtEnd()<CR>
endif

nnoremap          [SP]          <Nop>
nmap              <Space>       [SP]


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap          ;             :
nnoremap          :             ;
nnoremap          q;            q:

nnoremap          j             gj
nnoremap          k             gk
nnoremap          s             <NOP>
nnoremap          x             "_x
nnoremap          S             <NOP>
nnoremap          Q             <NOP>
nnoremap          Y             y$
nnoremap          <S-h>h        ^
nnoremap          <S-h><S-h>    0
nnoremap          <S-l>         $
nnoremap          <CR>          A<CR><ESC>
nnoremap          <ESC><ESC>    :noh<CR>
nnoremap <silent> [SP]z         :bprevious<CR>
nnoremap <silent> [SP]b         :bnext<CR>

nnoremap          sa            <C-w><S-w>
nnoremap          sd            <C-w>w
nnoremap          ss            5<C-w>h
nnoremap          sh            :split<CR>
nnoremap          sv            :vsplit<CR>
nnoremap          st            :tabnew<CR>
nnoremap          tl            gt

nnoremap <silent> [SP]n         :call ToggleLineNum()<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
inoremap          "             ""<Left>
inoremap          ""            ""
inoremap          "<Space>      "<Space>
inoremap          '             ''<Left>
inoremap          ''            ''
inoremap          '<Space>      '<Space>
inoremap          (             ()<Left>
inoremap          ()            ()
inoremap          (<SPACE>      (<Space><Space>)<Left><Left>
inoremap          [             []<Left>
inoremap          []            []
inoremap          [<Space>      [<Space><Space>]<Left><Left>
inoremap          [<CR>         [<ESC>yypv$r<Space>$r,yypr]2<Up>a<Space>
inoremap          {             {<Space><Space>}<Left><Left>
inoremap          {}            {}
inoremap          {<Space>      {<Space><Space>}<Left><Left>
inoremap          {<CR>         {<ESC>yypv$r<Space>$r,yypr}2<Up>a<Space>

inoremap          <             <><Left>
inoremap          <<Space>      <<Space>
inoremap          <>            <>
inoremap          <<<Space>     <<<Space>
inoremap          <-            <-
inoremap          <-<Space>     <-<Space>
inoremap          =<<           =<<
inoremap          =<<<Space>    =<<<Space>

inoremap          jj            <ESC>
inoremap          kk            <ESC>
inoremap          ;;            <ESC>A
inoremap          <C-[>         <ESC>
inoremap          ;wa           <ESC>:wa<CR><RIGHT>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
tnoremap <silent> <ESC>         <C-\><C-n>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vmap              (             <S-s>(a<Delete><ESC>%i<BS><ESC>
vmap              {             <S-s>{a<Delete><ESC>%i<BS><ESC>
vmap              [             <S-s>[a<Delete><ESC>%i<BS><ESC>
vmap              "             <S-s>"
vmap              '             <S-s>'
vmap              `             <S-s>`
vnoremap          <             "zdi<<C-R>z><ESC>
vmap              <Tab>         %


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" combination
"     with vimfiler
nnoremap          <Tab>         %
nmap              [SP]T         tt<Space>c<C-w>h<S-s>G<Up><Up><CR>
"nmap              [SP]r         <Space>h<C-w>h<S-s>G<Up><Up><CR>:bd<Space>1<CR>
"nmap              [SP]R         <Space>H<C-w>h<S-s>G<Up><Up><CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" For practice
"nnoremap    l             <Nop>
"nnoremap    h             <Nop>
"nnoremap    ll            <Right>
"nnoremap    hh            <Left>
"
