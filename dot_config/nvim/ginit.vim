Guifont! Cica:h10
let s:fontsize = 10

function! AdjustFontSize(amount)
  let s:fontsize = s:fontsize+a:amount
  :execute "GuiFont! Cica:h" . s:fontsize
endfunction

noremap  <C-ScrollWheelUp>   :call AdjustFontSize(1)<CR>
noremap  <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
inoremap <C-ScrollWheelUp>   <Esc>:call AdjustFontSize(1)<CR>a
inoremap <C-ScrollWheelDown> <Esc>:call AdjustFontSize(-1)<CR>a
