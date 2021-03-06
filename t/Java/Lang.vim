let s:suite= themis#suite('Java.Lang')

function! s:suite.before_each()
    let s:L= vital#of('vital').import('Java.Lang')
endfunction

function! s:suite.after_each()
    unlet s:L
endfunction

function! s:suite.__exports__()
    let exports_suite= themis#suite('exports')

    function! exports_suite.separator()
        call g:assert.is_string(s:L.separator)
    endfunction

    function! exports_suite.path_separator()
        call g:assert.is_string(s:L.path_separator)
    endfunction

    function! exports_suite.keyword()
        call g:assert.is_list(s:L.keyword)
    endfunction

    function! exports_suite.integral_type()
        call g:assert.is_list(s:L.integral_type)
    endfunction

    function! exports_suite.floating_point_type()
        call g:assert.is_list(s:L.floating_point_type)
    endfunction

    function! exports_suite.numeric_type()
        call g:assert.is_list(s:L.numeric_type)
    endfunction

    function! exports_suite.primitive_type()
        call g:assert.is_list(s:L.primitive_type)
    endfunction
endfunction
