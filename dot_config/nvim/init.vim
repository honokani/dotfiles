if &compatible
    set nocompatible
endif

if has('win32') || has ('win64')
    set shellslash
    let g:vimproc#download_windows_dll = 1
    let g:python_host_prog  = expand( "$USERPROFILE/Miniconda3/envs/neovim2/python.exe" )
    let g:python3_host_prog = expand( "$USERPROFILE/Miniconda3/envs/neovim3/python.exe" )
else
    set sh=zsh
    let g:python_host_prog  = expand( "$HOME/.pyenv/versions/neovim2/bin/python" )
    let g:python3_host_prog = expand( "$HOME/.pyenv/versions/neovim3/bin/python" )
endif

" reset auto
augroup MyAuto
    autocmd!
augroup END

" select cache path
if exists("g:nyaovim_version")
    let s:dein_cache_path = expand('~/.cache/nyaovim/dein')
elseif has('nvim')
    let s:dein_cache_path = expand('~/.cache/nvim/dein')
else
    let s:dein_cache_path = expand('~/.cache/vim/dein')
endif

" set cache dir
let s:dein_dir = s:dein_cache_path . '/repos/github.com/Shougo/dein.vim'
" if not exist, clone dein.vim
if !isdirectory(s:dein_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
endif
execute 'set runtimepath^=' . s:dein_dir

" load plungin
if dein#load_state(s:dein_cache_path)
    call dein#begin(s:dein_cache_path)

    call dein#load_toml('~/.config/nvim/dein.toml'     , {'lazy' : 0})
    call dein#load_toml('~/.config/nvim/dein_lazy.toml', {'lazy' : 1})

    if exists('g:nyaovim_version')
        call dein#add('rhysd/nyaovim-popup-tooltip')
        call dein#add('rhysd/nyaovim-markdown-preview')
        call dein#add('rhysd/nyaovim-mini-browser')
    endif

    call dein#end()
    call dein#save_state()
endif

" then, install else plugins if not exist
if has('vim_starting') && dein#check_install()
    call dein#install()
endif

filetype plugin indent on
syntax on

if !has('gui_running')
    augroup clearWindow
        autocmd!
        autocmd VimEnter,ColorScheme * highlight Normal ctermbg=none
        autocmd VimEnter,ColorScheme * highlight LineNr ctermbg=none
        autocmd VimEnter,ColorScheme * highlight SignColumn ctermbg=none
        autocmd VimEnter,ColorScheme * highlight VertSplit ctermbg=none
        autocmd VimEnter,ColorScheme * highlight NonText ctermbg=none
    augroup END
endif

runtime! options.rc.vim


runtime! keymaps.rc.vim

