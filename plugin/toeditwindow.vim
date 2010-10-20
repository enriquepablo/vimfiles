
function! g:GoToEditWindow()
    for n in range (1, 10)
        wincmd W
        if &buftype != 'nofile'
            return
        endif
    endfor
endfunction

