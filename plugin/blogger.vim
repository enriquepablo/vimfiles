
" Blogger
function! g:Blogger()
    cd ~/.vim/blog
    set ft=blogger
    Blogs
endfunction

command! Blog :call g:Blogger()
