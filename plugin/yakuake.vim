
" yakuake integration with gvim
"
" you need to have yakuake installed
"
" The OpenYakuake command will open a yakuake session on your cwd.
" On that session you will have an 'e' alias that, given a file path,
" will open the given file in the gvim instance from which yakuake was called and
" close the yakuake session.
"
" I can't find a way to format it prettier, sorry :(

function! s:OpenYakuake()
    let curdir = getcwd()
    execute "silent !qdbus org.kde.yakuake >/dev/null 2>&1 && { qdbus org.kde.yakuake /yakuake/sessions runCommand 'cd " . curdir . "'; qdbus org.kde.yakuake /yakuake/sessions runCommand 'gvimfun () { gvim --remote-silent " . '"$1"' . " ; } && alias e=". '"qdbus org.kde.yakuake /yakuake/window toggleWindowState && gvimfun"' . "' ; qdbus org.kde.yakuake /yakuake/sessions runCommand 'reset && echo ". '"type e <file> to edit file"' . "'; qdbus org.kde.yakuake /yakuake/window toggleWindowState; }"
endfunction

command! -n=0 -bar Yakuake :call s:OpenYakuake()
