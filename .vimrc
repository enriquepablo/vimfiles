set encoding=utf-8
set guifont=Inconsolata\ 11
syn on
filetype on
filetype plugin on
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smartcase
set number
set noequalalways
set smartindent
set backspace=indent,start
set browsedir=current

" make :s substitute all matches in a line
set gdefault

" GUI
set guioptions-=T
set guioptions-=m
set guitablabel=%M\ %t

"" Statusbar and Linenumbers
set cmdheight=2
set laststatus=2
set statusline=[%l,%c\ %P%M]\ %f\ %r%h%w

helptags ~/.vim/doc

" to have edited buffers that aren't visible in a window somewhere
set hidden

" map change window size
:noremap <silent> <M-Right> <C-W>>
:noremap <silent> <M-Left> <C-W><
:noremap <silent> <M-Up> <C-W>+
:noremap <silent> <M-Down> <C-W>-

" replace semicolon for substitution
:noremap ; :s///g<Left><Left><Left>

" With this snippet you will be able to go to your import
" statements and hit ‘gf’ on one of them and it’ll jump you to that file.
" from http://blog.sontek.net/2008/05/11/python-with-a-modular-ide-vim/

python << EOF
import os
import sys
import vim
for p in sys.path:
    if os.path.isdir(p):
        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
# for the omelette zc.buildout recipe
if os.path.isdir('parts/omelette'):
    vim.command(r"set path+=%s" % 'parts/omelette')
EOF

" some filetypes
:au BufRead,BufNewFile *.cpy,*.vpy   set ft=python
:au BufRead,BufNewFile *.pt,*.cpt    set ft=xml
:au BufRead,BufNewFile *.zcml        set ft=xml
:au BufRead,BufNewFile *.wiki        set ft=creole

" folding
:set foldnestmax=2
:set foldmethod=indent
:highlight Folded guibg=SteelBlue guifg=goldenrod1
:highlight Folded ctermbg=grey ctermfg=yellow
:highlight FoldColumn guibg=grey guifg=yellow

" type :W if you need to write as su
command W w !sudo tee % >/dev/null

" F keys mappings
nnoremap <silent> <F8> :NERDTreeToggle<CR>

" NERDTree
let g:NERDTreeIgnore=['\.swp$','\.pyc$','\.pyo$']

