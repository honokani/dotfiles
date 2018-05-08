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
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲
" line number, line ruler
set number
set ruler
set cursorcolumn
set nocursorline
autocmd InsertEnter,InsertLeave * set cursorline!
" autocmd ColorScheme * highlight MatchPattern gui=bold, underline guibg=NONE guifg=cyan
autocmd ColorScheme * highlight MatchPattern cterm=underline ctermbg=NONE ctermfg=50
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
set expandtab
set softtabstop=4
set shiftwidth=4
let g:indent_guides_enable_on_vim_startup = 1
" file open
set hidden
set switchbuf=useopen
" backup file
" set verbosefile=/tmp/vim.log
" set verbose=0
" clipboard
set clipboard+=unnamedplus

