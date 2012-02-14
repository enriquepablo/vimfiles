set encoding=utf-8
syn on
filetype on
filetype plugin on
filetype plugin indent on
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smartcase
set number
set noequalalways
set smartindent
set backspace=indent,start
set browsedir=current
set foldmethod=manual

" make :s substitute all matches in a line
" set gdefault

" GUI
set guifont=Inconsolata\ 11
set guioptions-=T
set guioptions-=m
set guitablabel=%M\ %t
if has("gui_running")
    " GUI is running or is about to start.
    " Maximize gvim window.
    set lines=40 columns=200
endif

"" Statusbar and Linenumbers
set cmdheight=1
set laststatus=2
set statusline=[%l,%c\ %P%M]\ %f\ %r%h%w

helptags ~/.vim/doc

" to have edited buffers that aren't visible in a window somewhere
set hidden

" map change window size
noremap <silent> <S-Right> <C-W>>
noremap <silent> <S-Left> <C-W><
noremap <silent> <S-Up> <C-W>+
noremap <silent> <S-Down> <C-W>-

" map bn & bp
noremap <M-Right> :bn<CR>
noremap <M-Left> :bp<CR>

" replace semicolon for substitution
:noremap ; :s///g<Left><Left><Left>

" some filetypes
au BufRead,BufNewFile *.cpy,*.vpy   set ft=python
au BufRead,BufNewFile *.pt,*.cpt    set ft=xml
au BufRead,BufNewFile *.zcml        set ft=xml
au BufRead,BufNewFile *.wiki        set ft=creole
au BufRead,BufNewFile *.rst         set ft=rest

" type :W if you need to write as su
command W w !sudo tee % >/dev/null

" F keys mappings
nnoremap          <F6>  :FindFiles<Space>
nnoremap          <F7>  :GrepFiles<Space>
nnoremap <silent> <F8>  :NERDTreeToggle<CR>
nnoremap <silent> <F9>  :Yakuake<CR>
nnoremap <silent> <F10> :Blog<CR>

" NERDTree
let g:NERDTreeIgnore=['\.swp$','\.pyc$','\.pyo$']

" omnicomplete
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags

" OmniCopletion
"
" SuperTab
let g:SuperTabDefaultCompletionType = "context"
"let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
"let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
"let g:SuperTabContextDiscoverDiscovery =
"        \ ["&completefunc:<c-x><c-u>", "&omnifunc:<c-x><c-o>"]
"
