"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap    ;             :
nnoremap    :             ;
nnoremap    :;            $
nnoremap    q;            q:
nnoremap    q;            q:

nnoremap    j             gj
nnoremap    k             gk
nnoremap    s             <Nop>
nnoremap    S             <Nop>
nnoremap    Q             <Nop>
nnoremap    Y             y$
nnoremap   <S-h>          ^
nnoremap   <S-h>h         0
nnoremap   <S-h><S-h>     0
nnoremap   <S-l>          $
nnoremap   <CR>           A<CR><ESC>
nnoremap   <Esc><Esc>     :noh<CR>

nnoremap    sa            <C-w><S-w>
nnoremap    sd            <C-w>w
nnoremap    ss            5<C-w>h
nnoremap    st            :tabnew<CR>
nnoremap    sh            :split<CR>
nnoremap    sv            :vsplit<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
inoremap    "             ""<LEFT>
inoremap    ""            ""
inoremap    "<SPACE>      "<SPACE>
inoremap    '             ''<LEFT>
inoremap    ''            ''
inoremap    '<SPACE>      '<SPACE>
inoremap    (             ()<LEFT>
inoremap    ()            ()
inoremap    (<SPACE>      (<SPACE><SPACE>)<LEFT><LEFT>
inoremap    [             []<LEFT>
inoremap    []            []
inoremap    [<SPACE>      [<SPACE><SPACE>]<LEFT><LEFT>
inoremap    [<CR>         [<ESC>yypv$r<SPACE>$r,yypr]2<Up>a<SPACE>
inoremap    {             {<SPACE><SPACE>}<LEFT><LEFT>
inoremap    {}            {}
inoremap    {<SPACE>      {<SPACE><SPACE>}<LEFT><LEFT>
inoremap    {<CR>         {<ESC>yypv$r<SPACE>$r,yypr}2<Up>a<SPACE>

inoremap    <             <><LEFT>
inoremap    <<SPACE>      <<SPACE>
inoremap    <>            <>
inoremap    <<<SPACE>     <<<SPACE>
inoremap    <-            <-
inoremap    <-<SPACE>     <-<SPACE>
inoremap    =<<           =<<
inoremap    =<<<SPACE>    =<<<SPACE>

inoremap    jj            <ESC>
inoremap    kk            <ESC>
inoremap    ;;            <ESC>A
inoremap    <C-[>         <ESC>
inoremap    ;wa           <ESC>:wa<Return><RIGHT>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
tnoremap    <silent><ESC> <C-\><C-n>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vmap        (             <S-s>(a<DELETE><ESC>%i<BS><ESC>
vmap        {             <S-s>{a<DELETE><ESC>%i<BS><ESC>
vmap        [             <S-s>[a<DELETE><ESC>%i<BS><ESC>
vmap        "             <S-s>"
vmap        '             <S-s>'
vmap        `             <S-s>`
vnoremap    <             "zdi<<C-R>z><ESC>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" For practice
"nnoremap    l             <Nop>
"nnoremap    h             <Nop>
"nnoremap    ll            <Right>
"nnoremap    hh            <Left>

" combination
nmap        <Space>S      tt<Space>c<C-w>h<S-s>G<Up><Up><CR>
nmap        <Space>f      <Space>hsv<C-w>h<S-s>G<Up><Up><CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

