"============================================================================
"File:        ghc-mod.vim
"Description: Syntax checking plugin for syntastic.vim
"Maintainer:  Anthony Carapetis <anthony.carapetis at gmail dot com>
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"
"============================================================================

if !exists('g:syntastic_haskell_checker_args')
    let g:syntastic_haskell_checker_args = '--ghcOpt="-fno-code" --hlintOpt="--language=XmlSyntax"'
endif

function! SyntaxCheckers_haskell_GetLocList()
    let ghcmod = 'ghc-mod ' . g:syntastic_haskell_checker_args
    let makeprg = ghcmod . " check ". shellescape(expand('%')) . 
      \ " | sed -e \"s/\\x00/\\n/g\" | sed -e \"s/  /__/g\"; "
    let errorformat = '%-G\\s%#,%f:%l:%c:%trror: %m,'.
                \     '%f:%l:%c:%tarning: %m,'.
                \     '%f:%l:%c: %trror: %m,'.
                \     '%f:%l:%c: %tarning: %m,%f:%l:%c:%m,'.
                \     '%E%f:%l:%c:,%Z%m,'

    let output = split(system("bash -c '".makeprg."'"), '\n')

    let l:errors = []
    for x in output
      let l:line = {'valid': 1, 'bufnr': 1, 'lnum': 1, 'cnum': 1, 'text': x}
      call add(l:errors, l:line)
    endfor

    return l:errors
endfunction

function! SyntaxCheckers_lhaskell_GetLocList()
    return SyntaxCheckers_haskell_GetLocList()
endfunction
