nnoremap    ;           :
nnoremap    :           ;
nnoremap    j           gj
nnoremap    k           gk
nnoremap    s           <Nop>
nnoremap    S           <Nop>
nnoremap    Q           <Nop>
nnoremap    Y           y$
nnoremap   <S-h>        ^
nnoremap   <S-h>h       0
nnoremap   <S-h><S-h>   0
nnoremap   <S-l>        $
nnoremap   <CR>         A<CR><ESC>

nnoremap    sa          <C-w><S-w>
nnoremap    sd          <C-w>w
nnoremap    sh          <C-w>h
nnoremap    st          :tabnew<CR>
nnoremap    ss          5<C-w>h
nnoremap    sv          :vsplit<CR>
nnoremap    q;          q:
nnoremap    q;          q:

inoremap    ,           ,
inoremap    (           ()<ESC>
inoremap    "           ""<ESC>
inoremap    '           ''<ESC>
inoremap    [           []<ESC>
inoremap    <           <><ESC>
inoremap    {           {<CR><ESC><Up>yyp$r}<Left>v^r<Space>J<Up>$
inoremap    jj          <ESC>
inoremap    kk          <ESC>
inoremap    ;;          <ESC>A
inoremap    <C-[>       <ESC>

" For practice
nnoremap    l           <Nop>
nnoremap    h           <Nop>
nnoremap    ll          <Right>
nnoremap    hh          <Left>

" combination
nmap <Space>S tt<Space>c<C-w>h<S-s>G<Up><Up><CR>
nmap <Space>f <Space>hsv<C-w>h<S-s>G<Up><Up><CR>

