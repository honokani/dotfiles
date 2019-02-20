function! ToggleLineNum() abort
    if &relativenumber == 1
        setlocal norelativenumber
    else
        setlocal relativenumber
    endif
endfunction

function! MyTestFunc() abort
    setlocal relativenumber
endfunction

