
function! g:GoToEditWindow()
python << EOF
import vim
def to_edit_window(n=0):
    if n >= 10:
        return
    vim.command('wincmd W')
    if not vim.current.buffer.name or \
           (not vim.current.buffer.name.endswith('output') and \
            not vim.current.buffer.name.endswith('-MiniBufExplorer-') and \
            not vim.current.buffer.name.endswith('TreeExplorer')):
        return
    #listed = vim.eval('buflisted("%s")' % vim.current.buffer.name)
    #if listed:
    #    return
    n += 1
    to_edit_window(n)
to_edit_window()
EOF
endfunction
