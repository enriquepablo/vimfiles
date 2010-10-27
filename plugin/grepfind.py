import os
import re
import shutil


def _find(files, dirname, fname, p):
    if p.search(fname):
        files.append('*%s* in %s%s' % (fname, dirname, fname))

def _grep(files, dirname, fname, p):
    f = '%s/%s' % (dirname, fname)
    try:
        fileToSearch = open( f, 'r' )
    except IOError:
        return
    data = fileToSearch.read()
    data = data.split('\n')
    for n, line in enumerate(data):
        if p.search(line):
            files.append('*l-%d %s* in %s%s' % (n+1, line, dirname, fname))
    fileToSearch.close()

def _findfiles(arg, dirname, fnames):
    if '.svn' in dirname:
        return
    files   = arg[0]
    pattern = arg[1]
    action  = arg[2]
    a = action=='find' and _find or _grep
    for fname in fnames:
        if fname.endswith('.pyc') or \
            fname.endswith('~') or \
            fname.endswith('.pyo') or \
            fname == 'tags':
            continue
        a(files, dirname, fname, pattern)

def findfiles(top, pattern, action):
    global matches
    p = re.compile(pattern)
    os.path.walk(top, _findfiles, (matches, p, action))
    matches.reverse()

def rmfile(path):
    if path.endswith('/'):
        return
    filename = path.split('/')[-1]
    if not os.path.exists('/tmp/vimrm/'):
        os.mkdir('/tmp/vimrm/')
    shutil.move(path, '/tmp/vimrm/%s' % filename)

matches = []
