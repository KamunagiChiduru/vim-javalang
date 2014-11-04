let s:suite= themis#suite('Java.Lang')
let s:assert= themis#helper('assert')

function! s:suite.before_each()
    let s:L= vital#of('vital').import('Java.Lang')
endfunction

function! s:suite.after_each()
    unlet s:L
endfunction
