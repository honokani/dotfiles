" encode
set encoding=utf-8
" swap, backup
set noswapfile
set nobackup
set nowritebackup
" when scroll, can see bottom
set scrolloff=5
" power backspace
set backspace=indent,eol,start
" can see invisible chara
set list
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲,space:¯
" line number, line ruler
set number
set ruler
set cursorcolumn
set nocursorline
autocmd InsertEnter,InsertLeave * set cursorline!
" autocmd ColorScheme * highlight MatchPattern gui=bold, underline guibg=NONE guifg=cyan
autocmd ColorScheme * highlight MatchPattern cterm=underline ctermbg=NONE ctermfg=50
"if &term == "xterm-256color"
"endif

" search
set matchpairs& matchpairs+=<:>
set showmatch
set matchtime=3
" easy move
" set virtualedit=all
" upercase,lowercase
set infercase
set switchbuf=useopen
set ignorecase
set smartcase
" history
set history=10000
set hlsearch
set incsearch
set wrapscan
set gdefault
" mouse mode
set mouse=a
" indent
set shiftround

" set softtabstop=4
" set shiftwidth=4
" set expandtab
if has("autocmd")
  filetype plugin on
  filetype indent on
  augroup myFileIndent
    autocmd!
    if expand("%:r") =~ "dot_zshrc"
      setlocal filetype=zsh
    endif
    "sw=softtabstop, sts=shiftwidth, ts=tabstop, et=expandtab
    autocmd FileType zsh         setlocal sw=4 sts=4 ts=4 et
    autocmd FileType vim         setlocal sw=2 sts=2 ts=2 et

    autocmd FileType c           setlocal sw=4 sts=4 ts=4 et
    autocmd FileType scala       setlocal sw=4 sts=4 ts=4 et
    autocmd FileType haskell     setlocal sw=4 sts=4 ts=4 et

    autocmd FileType ruby        setlocal sw=2 sts=2 ts=2 et
    autocmd FileType python      setlocal sw=4 sts=4 ts=4 et

    autocmd FileType html        setlocal sw=4 sts=4 ts=4 et
    autocmd FileType css         setlocal sw=4 sts=4 ts=4 et
    autocmd FileType scss        setlocal sw=4 sts=4 ts=4 et
    autocmd FileType sass        setlocal sw=4 sts=4 ts=4 et
    autocmd FileType json        setlocal sw=4 sts=4 ts=4 et

    autocmd FileType js          setlocal sw=4 sts=4 ts=4 et
    autocmd FileType javascript  setlocal sw=4 sts=4 ts=4 et

    autocmd FileType markdown    setlocal sw=3 sts=3 ts=3 et
    autocmd FileType toml        setlocal sw=4 sts=4 ts=4 et
  augroup END
endif

let g:indent_guides_enable_on_vim_startup = 1
" file open
set hidden
set switchbuf=useopen
" backup file
" set verbosefile=/tmp/vim.log
" set verbose=0
" clipboard
set clipboard+=unnamedplus
" visualize json d-quote
set conceallevel=0
let g:vim_json_syntax_conceal = 0

