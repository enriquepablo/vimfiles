""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""
""""""" DO NOT USE """""""""""""
"" Danger of damaging your blogger account
"" Under development
""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""

" Make sure the Vim was compiled with +python before loading the script...
if !has("python")
        finish
endif

" Only load this plugin if it's not already loaded.
if (exists('g:BloggerLoaded'))
    finish
endif
let g:BloggerLoaded = 1

python << EOF
import sys
ourdir = os.path.dirname(vim.eval('expand("<sfile>")'))
sys.path.insert(0, ourdir)
import vim
from blogger import get_client
def _apply(funname):
    client = get_client()
    if client:
        getattr(client, funname)()
EOF

" Vim functions that delegate to python

function! BBlogs()
python << EOF
_apply('choose_blog')
EOF
endfunction

function! BPosts()
python << EOF
_apply('choose_post')
EOF
endfunction

function! BSave()
python << EOF
_apply('save_post')
EOF
endfunction

" Setup Vim-BloggerBeta Custom Commands
:command! Blogs :call BBlogs()
:command! Posts :call BPosts()
:command! Save :call BSave()
