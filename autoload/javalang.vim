let s:save_cpo= &cpo
set cpo&vim

let s:V= vital#of('javalang')
let s:L= s:V.import('Data.List')
unlet s:V

let s:obj= {
\   'constants': {},
\   'regexes':   {},
\}

" make some constants
let s:obj.constants.primitive_types=   ['boolean', 'byte', 'char', 'int', 'short', 'long', 'float', 'double']
let s:obj.constants.modifiers=         ['public', 'private', 'protected', 'static', 'final', 'synchronized', 'volatile', 'transient', 'native', 'strictfp', 'abstract']
let s:obj.constants.type_declarations= ['class', 'interface', 'enum']
let s:obj.constants.type_modifiers=    ['public', 'protected', 'private', 'abstract', 'static', 'final', 'strictfp']

" make completely keyword list
let s:obj.constants.keywords=  []
let s:obj.constants.keywords+= s:obj.constants.primitive_types
let s:obj.constants.keywords+= s:obj.constants.modifiers
let s:obj.constants.keywords+= s:obj.constants.type_declarations
let s:obj.constants.keywords+= ['super', 'this', 'void'] + ['assert', 'break', 'case', 'catch', 'const', 'continue', 'default', 'do', 'else', 'extends', 'finally', 'for', 'goto', 'if', 'implements', 'import', 'instanceof', 'interface', 'new', 'package', 'return', 'switch', 'throw', 'throws', 'try', 'while', 'true', 'false', 'null']

" platform dependant keywords
if has("win32") || has("win64") || has("win16") || has("dos32") || has("dos16")
    let s:obj.constants.path_separator= ';'
    let s:obj.constants.file_separator= '\'
else
    let s:obj.constants.path_separator= ':'
    let s:obj.constants.file_separator= '/'
endif

" XXX: make original parser is maybe better
" make some regexes using constants or not
let s:obj.regexes.keyword=    '\<\%(' . join(s:obj.constants.keywords, '\|') . '\)\>'
let s:obj.regexes.identifier= '[a-zA-Z_$][a-zA-Z0-9_$]*'
let s:obj.regexes.type_modifier= '\<\%(' . join(s:obj.constants.type_modifiers, '\|') . '\)\>'
" TODO: effecive naming. '  aaa . aa '
let s:obj.regexes.qualid= s:obj.regexes.identifier . '\%(\s*\.\s*' . s:obj.regexes.identifier . '\)*'
let s:obj.regexes.type= s:obj.regexes.qualid . '\%(\s*\[\s*\]\)*'
let s:obj.regexes.reference_type= s:obj.regexes.type
let s:obj.regexes.array_type= '^\s*\(' . s:obj.regexes.qualid . '\)\(\%(\s*\[\s*\]\)\+\)\s*$'
" for generics type argument
let s:inner_type_argument= '\%(?\s\+\%(extends\|super\)\s\+\)\=' . s:obj.regexes.type
let s:obj.regexes.type_argument= '<' . s:inner_type_argument . '\%(\s*,\s*' . s:inner_type_argument . '\)*>'
unlet s:inner_type_argument
" TODO: re-organize later
let s:single_type_argument= s:obj.regexes.identifier . '\s*' . s:obj.regexes.type_argument
let s:obj.regexes.type_with_argument= s:single_type_argument . '\%(\s*' . s:single_type_argument . '\)*'

" public apis
function! s:obj.is_keyword(word)
  return s:L.has(self.keywords, a:word)
endfunction

function! s:obj.contains_keyword(text)
  return a:text =~# self.regexes.keyword
endfunction

function! s:obj.is_identifier(word)
    return a:word =~# self.regexes.identifier
endfunction

function! javalang#get()
    return deepcopy(s:obj)
endfunction

let &cpo= s:save_cpo
unlet s:save_cpo
