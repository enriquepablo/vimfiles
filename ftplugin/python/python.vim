
" smartindent for python
setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

" ipdb
nmap <silent> <C-I> oimport ipdb;ipdb.set_trace()<Esc>


python << EOF

import os, sys

paths = (
    'parts/omelette',
)
for path in paths:
    path = os.path.join(os.getcwd(), path)
    if os.path.exists(path):
        sys.path.append(path)

EOF

