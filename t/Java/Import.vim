let s:suite= themis#suite('Java.Import')

function! s:paste(filename)
    new
    setfiletype java
    call setline(1, readfile(a:filename))
endfunction

function! s:suite.before_each()
    let s:I= vital#of('vital').import('Java.Import')
endfunction

function! s:suite.after_each()
    close!
    unlet s:I
endfunction

function! s:suite.__adds_statements__()
    let adds_statements= themis#suite('adds statements')

    function! adds_statements.by_string()
        call s:paste('t/fixtures/JsonMessageDecoder.java')

        call s:I.add('java.util.HashMap')

        call g:assert.equals(s:I.imported_classes(), [
        \   'java.io.ByteArrayInputStream',
        \   'java.io.IOException',
        \   'java.util.HashMap',
        \   'java.util.Map',
        \   'jp.michikusa.chitose.unitejavaimport.server.request.CommonRequest',
        \   'net.arnx.jsonic.JSON',
        \   'net.arnx.jsonic.JSONException',
        \   'org.apache.mina.core.buffer.IoBuffer',
        \   'org.apache.mina.core.session.IoSession',
        \   'org.apache.mina.filter.codec.CumulativeProtocolDecoder',
        \   'org.apache.mina.filter.codec.ProtocolDecoderOutput',
        \])
    endfunction

    function! adds_statements.by_strings()
        call s:paste('t/fixtures/JsonMessageDecoder.java')

        call s:I.add('java.util.LinkedHashMap', 'java.util.LinkedList')

        call g:assert.equals(s:I.imported_classes(), [
        \   'java.io.ByteArrayInputStream',
        \   'java.io.IOException',
        \   'java.util.LinkedHashMap',
        \   'java.util.LinkedList',
        \   'java.util.Map',
        \   'jp.michikusa.chitose.unitejavaimport.server.request.CommonRequest',
        \   'net.arnx.jsonic.JSON',
        \   'net.arnx.jsonic.JSONException',
        \   'org.apache.mina.core.buffer.IoBuffer',
        \   'org.apache.mina.core.session.IoSession',
        \   'org.apache.mina.filter.codec.CumulativeProtocolDecoder',
        \   'org.apache.mina.filter.codec.ProtocolDecoderOutput',
        \])
    endfunction

    function! adds_statements.at_first_by_string()
        call s:paste('t/fixtures/NoImports.java')

        call s:I.add('java.util.Map')

        call g:assert.equals(s:I.imported_classes(), ['java.util.Map'])
        call g:assert.equals(getline(1, '$'), [
        \   'package hoge;',
        \   '',
        \   'import java.util.Map;',
        \   '',
        \   'class NoImports',
        \   '{',
        \   '}',
        \])
    endfunction

    function! adds_statements.at_first_by_strings()
        call s:paste('t/fixtures/NoImports.java')

        call s:I.add('java.util.Map', 'java.util.List')

        call g:assert.equals(s:I.imported_classes(), ['java.util.List', 'java.util.Map'])
        call g:assert.equals(getline(1, '$'), [
        \   'package hoge;',
        \   '',
        \   'import java.util.List;',
        \   'import java.util.Map;',
        \   '',
        \   'class NoImports',
        \   '{',
        \   '}',
        \])
    endfunction

    function! adds_statements.at_first_for_static()
        call s:paste('t/fixtures/NoImports.java')

        call s:I.add({
        \   'class': 'java.util.Arrays',
        \   'method': 'asList',
        \})

        call g:assert.equals(s:I.imported_fields_and_methods(), ['java.util.Arrays.asList'])
        call g:assert.equals(getline(1, '$'), [
        \   'package hoge;',
        \   '',
        \   'import static java.util.Arrays.asList;',
        \   '',
        \   'class NoImports',
        \   '{',
        \   '}',
        \])
    endfunction
endfunction

function! s:suite.__removes_statements__()
    let removes_statements= themis#suite('removes statements')

    function! removes_statements.a_statement()
        call s:paste('t/fixtures/JsonMessageDecoder.java')

        call s:I.remove('java.util.Map')

        call g:assert.equals(s:I.imported_classes(), [
        \   'java.io.ByteArrayInputStream',
        \   'java.io.IOException',
        \   'jp.michikusa.chitose.unitejavaimport.server.request.CommonRequest',
        \   'net.arnx.jsonic.JSON',
        \   'net.arnx.jsonic.JSONException',
        \   'org.apache.mina.core.buffer.IoBuffer',
        \   'org.apache.mina.core.session.IoSession',
        \   'org.apache.mina.filter.codec.CumulativeProtocolDecoder',
        \   'org.apache.mina.filter.codec.ProtocolDecoderOutput',
        \])
    endfunction

    function! removes_statements.statements()
        call s:paste('t/fixtures/JsonMessageDecoder.java')

        call s:I.remove('java.io.ByteArrayInputStream', 'net.arnx.jsonic.JSON')

        call g:assert.equals(s:I.imported_classes(), [
        \   'java.io.IOException',
        \   'java.util.Map',
        \   'jp.michikusa.chitose.unitejavaimport.server.request.CommonRequest',
        \   'net.arnx.jsonic.JSONException',
        \   'org.apache.mina.core.buffer.IoBuffer',
        \   'org.apache.mina.core.session.IoSession',
        \   'org.apache.mina.filter.codec.CumulativeProtocolDecoder',
        \   'org.apache.mina.filter.codec.ProtocolDecoderOutput',
        \])
    endfunction
endfunction

function! s:suite.__sorts_statements__()
    let sorts_statements= themis#suite('sorts statements')

    function! sorts_statements.without_blank_lines()
        call s:paste('t/fixtures/NoImports.java')

        call s:I.add(
        \   {'class': 'java.util.Map'},
        \   {'class': 'java.util.Arrays', 'method': 'asList'},
        \   {'class': 'java.lang.Boolean', 'field': 'TRUE'},
        \)

        call g:assert.equals(getline(1, '$'), [
        \   'package hoge;',
        \   '',
        \   'import java.util.Map;',
        \   '',
        \   'import static java.lang.Boolean.TRUE;',
        \   'import static java.util.Arrays.asList;',
        \   '',
        \   'class NoImports',
        \   '{',
        \   '}',
        \])
    endfunction
endfunction

function! s:suite.__gets_already_imported_elements__()
    let gets_already_imported_elements= themis#suite('gets already imported elements')

    function! gets_already_imported_elements.for_classes()
        call s:paste('t/fixtures/JsonMessageDecoder.java')

        call g:assert.equals(s:I.imported_classes(), [
        \   'java.io.ByteArrayInputStream',
        \   'java.io.IOException',
        \   'java.util.Map',
        \   'jp.michikusa.chitose.unitejavaimport.server.request.CommonRequest',
        \   'net.arnx.jsonic.JSON',
        \   'net.arnx.jsonic.JSONException',
        \   'org.apache.mina.core.buffer.IoBuffer',
        \   'org.apache.mina.core.session.IoSession',
        \   'org.apache.mina.filter.codec.CumulativeProtocolDecoder',
        \   'org.apache.mina.filter.codec.ProtocolDecoderOutput',
        \])
    endfunction

    function! gets_already_imported_elements.for_fields_and_methods()
        call s:paste('t/fixtures/JsonMessageDecoder.java')

        call g:assert.equals(s:I.imported_fields_and_methods(), [
        \   'com.google.common.base.Preconditions.checkArgument',
        \])
    endfunction
endfunction

function! s:suite.__tells_statements_region__()
    let tells_statements_region= themis#suite('tells statements region')

    function! tells_statements_region.statements_have_only_classes()
        call s:paste('t/fixtures/JsonMessageDecoder.java')

        call g:assert.equals(s:I.region(), [3, 17])
    endfunction
endfunction
