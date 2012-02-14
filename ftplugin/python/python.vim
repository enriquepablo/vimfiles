" tabs to spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4

" folding
" set foldnestmax=2
" set foldmethod=indent
highlight Folded guibg=SteelBlue guifg=goldenrod1
highlight Folded ctermbg=grey ctermfg=yellow
highlight FoldColumn guibg=grey guifg=yellow

" smartindent for python
setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

" omnicomplete
set omnifunc=pythoncomplete#Complete

" pdb
nmap <silent> <C-I> oimport pdb;pdb.set_trace()<Esc>

" set python paths
python << EOF

import os, sys, vim

for p in sys.path:
    if os.path.isdir(p):
        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))

paths = (
    'parts/omelette',
)
for path in paths:
    path = os.path.join(os.getcwd(), path)
    if os.path.exists(path):
        sys.path.append(path)
    if os.path.isdir(path):
        vim.command(r"set path+=%s" % path)

EOF

" load rope. from ropevim.vim
function! LoadRope()
python << EOF
import ropevim
EOF
endfunction

call LoadRope()
