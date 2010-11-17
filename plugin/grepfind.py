import os
import re
import shutil
import vim

matches = []

def _find(dirname, fname, p):
    if p.search(fname):
        matches.append('*%s* in %s/%s' % (fname, dirname, fname))

def _grep(dirname, fname, p):
    f = '%s/%s' % (dirname, fname)
    try:
        fileToSearch = open( f, 'r' )
    except IOError:
        return
    data = fileToSearch.read()
    data = data.split('\n')
    for n, line in enumerate(data):
        if p.search(line):
            matches.append('*l-%d %s* in %s/%s' % (n+1, line, dirname, fname))
    fileToSearch.close()

def _findfiles(arg, dirname, fnames):
    if '.svn' in fnames:
        fnames.remove('.svn')
    pattern, action  = arg
    a = action=='find' and _find or _grep
    badfiles = vim.eval("g:NERDTreeIgnore")
    for fname in fnames:
        good = True
        for bad in badfiles:
            if fname.endswith(bad):
                good = False
                break
        if good:
            a(dirname, fname, pattern)

def findfiles(top, pattern, action):
    p = re.compile(pattern)
    os.path.walk(top, _findfiles, (p, action))
    matches.reverse()
    num = len(matches)
    matches.append('')
    matches.append('** %d matches found **' % num)

def rmfile(path):
    if path.endswith('/'):
        return
    filename = path.split('/')[-1]
    if not os.path.exists('/tmp/vimrm/'):
        os.mkdir('/tmp/vimrm/')
    shutil.move(path, '/tmp/vimrm/%s' % filename)

