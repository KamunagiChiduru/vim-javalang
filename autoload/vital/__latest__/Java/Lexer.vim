let s:save_cpo= &cpo
set cpo&vim

function! s:_vital_loaded(V)
    let s:Lexer= a:V.import('Text.Lexer')
endfunction

function! s:_vital_depends()
    return ['Text.Lexer']
endfunction

function! s:new()
    let tokens= []

    " jls-3.9 Keywords
    let tokens+= [
    \   ['ABSTRACT', 'abstract'],
    \   ['ASSERT', 'assert'],
    \   ['BOOLEAN', 'boolean'],
    \   ['BREAK', 'break'],
    \   ['BYTE', 'byte'],
    \   ['CASE', 'case'],
    \   ['CATCH', 'catch'],
    \   ['CHAR', 'char'],
    \   ['CLASS', 'class'],
    \   ['CONST', 'const'],
    \   ['CONTINUE', 'continue'],
    \   ['DEFAULT', 'default'],
    \   ['DO', 'do'],
    \   ['DOUBLE', 'double'],
    \   ['ELSE', 'else'],
    \   ['ENUM', 'enum'],
    \   ['EXTENDS', 'extends'],
    \   ['FINAL', 'final'],
    \   ['FINALLY', 'finally'],
    \   ['FLOAT', 'float'],
    \   ['FOR', 'for'],
    \   ['IF', 'if'],
    \   ['GOTO', 'goto'],
    \   ['IMPLEMENTS', 'implements'],
    \   ['IMPORT', 'import'],
    \   ['INSTANCEOF', 'instanceof'],
    \   ['INT', 'int'],
    \   ['INTERFACE', 'interface'],
    \   ['LONG', 'long'],
    \   ['NATIVE', 'native'],
    \   ['NEW', 'new'],
    \   ['PACKAGE', 'package'],
    \   ['PRIVATE', 'private'],
    \   ['PROTECTED', 'protected'],
    \   ['PUBLIC', 'public'],
    \   ['RETURN', 'return'],
    \   ['SHORT', 'short'],
    \   ['STATIC', 'static'],
    \   ['STRICTFP', 'strictfp'],
    \   ['SUPER', 'super'],
    \   ['SWITCH', 'switch'],
    \   ['SYNCHRONIZED', 'synchronized'],
    \   ['THIS', 'this'],
    \   ['THROW', 'throw'],
    \   ['THROWS', 'throws'],
    \   ['TRANSIENT', 'transient'],
    \   ['TRY', 'try'],
    \   ['VOID', 'void'],
    \   ['VOLATILE', 'volatile'],
    \   ['WHILE', 'while'],
    \]

    " jls-3.11 Separators
    let tokens+= [
    \   ['LPAREN', '('],
    \   ['RPAREN', ')'],
    \   ['LBRACE', '{'],
    \   ['RBRACE', '}'],
    \   ['LBRACK', '\['],
    \   ['RBRACK', '\]'],
    \   ['SEMI', ';'],
    \   ['COMMA', ','],
    \   ['DOT', '\.'],
    \]

    " jls-3.12 Operators
    \   ['ASSIGN', '='],
    \   ['GT', '>'],
    \   ['LT', '<'],
    \   ['BANG', '!'],
    \   ['TILDE', '\~'],
    \   ['QUESTION', '?'],
    \   ['COLON', ':'],
    \   ['EQUAL', '=='],
    \   ['LE', '<='],
    \   ['GE', '>='],
    \   ['NOTEQUAL', '!='],
    \   ['AND', '&&'],
    \   ['OR', '||'],
    \   ['INC', '++'],
    \   ['DEC', '--'],
    \   ['ADD', '+'],
    \   ['SUB', '-'],
    \   ['MUL', '\*'],
    \   ['DIV', '/'],
    \   ['BITAND', '&'],
    \   ['BITOR', '|'],
    \   ['CARET', '\^'],
    \   ['MOD', '%'],
    \   ['ARROW', '->'],
    \   ['COLONCOLON', '::'],
    \   ['ADD_ASSIGN', '+='],
    \   ['SUB_ASSIGN', '-='],
    \   ['MUL_ASSIGN', '\*='],
    \   ['DIV_ASSIGN', '/='],
    \   ['AND_ASSIGN', '&='],
    \   ['OR_ASSIGN', '|='],
    \   ['XOR_ASSIGN', '\^='],
    \   ['MOD_ASSIGN', '%='],
    \   ['LSHIFT_ASSIGN', '<<='],
    \   ['RSHIFT_ASSIGN', '>>='],
    \   ['URSHIFT_ASSIGN', '>>>='],
    \]

    " Additional symbols not defined in the lexical specification
    let tokens+= [
    \   ['AT', '@'],
    \   ['ELLIPSIS', '\.\.\.'],
    \]

    " Whitespace and comments
    let tokens+= [
    \   ['WS', '[ \t\r\n\x000c]\+'],
    \   ['COMMENT', '/\*\_.\{-}\*/'],
    \   ['LINE_COMMENT', '//[^\r\n]*'],
    \]

    " TODO
    let java_letter_or_digit= '[a-zA-Z0-9$_]'
    " TODO
    let java_letter= '[a-zA-Z$_]'

    let hex_digit= '[0-9a-fA-F]'
    let hex_digit_or_underscore= '\%(' . hex_digit . '\|_\)'
    let hex_digits_and_underscores= '\%(' . hex_digit_or_underscore . '\+\)'
    let hex_digits= '\%(' . hex_digit . '\%(' . hex_digits_and_underscores . '\?' . hex_digit . '\)\?\)'
    let hex_numeral= '\%(0[xX]' . hex_digits . '\)'

    let underscores= '\%(_\+\)'
    let octal_digit= '[0-7]'
    let octal_digit_or_underscore= '\%(' . octal_digit . '\|_\)'
    let octal_digits_and_underscores= '\%(' . octal_digit_or_underscore . '\+\)'
    let octal_digits= '\%(' . octal_digit . '\%(' . octal_digits_and_underscores . '\?' . octal_digit . '\)\?\)'
    let octal_numeral= '\%(0' . underscores . '\?' . octal_digits . '\)'

    let non_zero_digit= '[1-9]'
    let digit= '\%(0\|' . non_zero_digit . '\)'
    let digit_or_underscore= '\%(' . digit . '\|_\)'
    let digits_and_underscores= '\%(' . digit_or_underscore . '\+\)'
    let digits= '\%(' . digit . '\%(' . digits_and_underscores . '\?' . digit . '\)\?\)'
    let decimal_numeral= '\%(0\|' . non_zero_digit . '\%(' . digits . '\?\|' . underscores . digits . '\)\)'

    let binary_digit= '[01]'
    let binary_digit_or_underscore= '\%(' . binary_digit . '\|_\)'
    let binary_digits_and_underscores= '\%(' . binary_digit_or_underscore . '\+\)'
    let binary_digits= '\%(' . binary_digit . '\%(' . binary_digits_and_underscores . '\?' . binary_digit . '\)\?\)'
    let binary_numeral= '\%(0[bB]' . binary_digits . '\)'

    let unicode_escape= '\%(\\u' . hex_digit . hex_digit . hex_digit . hex_digit . '\)'
    let zero_to_three= '[0-3]'
    let octal_escape= '\%(\\\%(' . octal_digit . '\|' . octal_digit . octal_digit . '\|' . zero_to_three . octal_digit . octal_digit . '\)\)'
    let single_character= '[^''\\]'
    let escape_sequence= '\%(' . '\\[btnfr"''\\]' . '\|' . octal_escape . '\|' . unicode_escape . '\)'
    let string_character= '\%([^"\\]\|' . escape_sequence . '\)'
    let string_characters= '\%(\%(' . string_character . '\)\+\)'
    let string_literal= '\%("\%(' . string_characters . '\)?"\)'
    let character_literal= '\%(''\%(' . single_character . '\|' . escape_sequence . '\)''\)'
    let boolean_literal= '\%(true\|false\)'
    let binary_exponent_indicator= '[pP]'
    let exponent_indicator= '[eE]'
    let sign= '[+-]'
    let signed_integer= '\%(' . sign . '\?' . digits . '\)'
    let exponent_part= '\%(' . exponent_indicator . signed_integer . '\)'
    let binary_exponent= '\%(' . binary_exponent_indicator . signed_integer . '\)'
    let hex_significand= '\%(' . hex_numeral . '\.\?\|' . '0[xX]' . hex_digits . '\?\.' . hex_digits . '\)'
    let float_type_suffix= '[fFdD]'
    let hexadecimal_floating_point_literal= '\%(' . hex_significand . binary_exponent . float_type_suffix . '\?\)'
    let decimal_floating_point_literal= '\%(' . join([
    \   digits . '\.' . digits . '\?' . exponent_part . '\?' . float_type_suffix . '\?',
    \   '\.' . digits . exponent_part . '\?' . float_type_suffix . '\?',
    \   digits . exponent_part . float_type_suffix . '\?',
    \   digits . float_type_suffix,
    \], '\|') . '\)'
    let floating_point_literal= '\%(' . decimal_floating_point_literal . '\|' . hexadecimal_floating_point_literal . '\)'
    let integer_type_suffix= '[lL]'
    let decimal_integer_literal= '\%(' . decimal_numeral . integer_type_suffix . '\?\)'
    let hex_integer_literal= '\%(' . hex_numeral . integer_type_suffix . '\?\)'
    let octal_integer_literal= '\%(' . octal_numeral . integer_type_suffix . '\?\)'
    let binary_integer_literal= '\%(' . binary_numeral . integer_type_suffix . '\?\)'
    let integer_literal= '\%(' . decimal_integer_literal . '\|' . hex_integer_literal . '\|' . octal_integer_literal . '\|' . binary_integer_literal . '\)'

    let tokens+= [
    \   ['JavaLetterOrDigit', java_letter_or_digit],
    \   ['JavaLetter', java_letter],
    \   ['Identifier', '\%(' . java_letter . '\)\%(' . java_letter_or_digit . '\)*'],
    \   ['NullLiteral', 'null'],
    \   ['UnicodeEscape', unicode_escape],
    \   ['ZeroToThree', zero_to_three],
    \   ['OctalEscape', octal_escape],
    \   ['EscapeSequence', escape_sequence],
    \   ['StringLiteral', string_literal],
    \   ['StringCharacters', string_characters],
    \   ['StringCharacter', string_character],
    \   ['SingleCharacter', single_character],
    \   ['CharacterLiteral', character_literal],
    \   ['BooleanLiteral', boolean_literal],
    \   ['BinaryExponentIndicator', binary_exponent_indicator],
    \   ['BinaryExponent', binary_exponent],
    \   ['HexSignificand', hex_significand],
    \   ['HexadecimalFloatingPointLiteral', hexadecimal_floating_point_literal],
    \   ['FloatTypeSuffix', float_type_suffix],
    \   ['Sign', sign],
    \   ['SignedInteger', signed_integer],
    \   ['ExponentIndicator', exponent_indicator],
    \   ['ExponentPart', exponent_part],
    \   ['DecimalFloatingPointLiteral', decimal_floating_point_literal],
    \   ['FloatingPointLiteral', floating_point_literal],
    \   ['HexNumeral', hex_numeral],
    \   ['HexDigits', hex_digits],
    \   ['HexDigit', hex_digit],
    \   ['HexDigitsAndUnderscores', hex_digits_and_underscores],
    \   ['HexDigitOrUnderscore', hex_digit_or_underscore],
    \   ['OctalNumeral', octal_numeral],
    \   ['OctalDigits', octal_digits],
    \   ['OctalDigit', octal_digit],
    \   ['OctalDigitsAndUnderscores', octal_digits_and_underscores],
    \   ['OctalDigitOrUnderscore', octal_digit_or_underscore],
    \   ['IntegerLiteral', integer_literal],
    \   ['DecimalIntegerLiteral', decimal_integer_literal],
    \   ['HexIntegerLiteral', hex_integer_literal],
    \   ['OctalIntegerLiteral', octal_integer_literal],
    \   ['BinaryIntegerLiteral', binary_integer_literal],
    \   ['IntegerTypeSuffix', integer_type_suffix],
    \   ['DecimalNumeral', decimal_numeral],
    \   ['Digits', digits],
    \   ['Digit', digit],
    \   ['NonZeroDigit', non_zero_digit],
    \   ['DigitsAndUnderscores', digits_and_underscores],
    \   ['DigitOrUnderscore', digit_or_underscore],
    \   ['Underscores', underscores],
    \   ['BinaryNumeral', binary_numeral],
    \   ['BinaryDigits', binary_digits],
    \   ['BinaryDigit', binary_digit],
    \   ['BinaryDigitsAndUnderscores', binary_digits_and_underscores],
    \   ['BinaryDigitOrUnderscore', binary_digit_or_underscore],
    \]

    return s:Lexer.lexer(tokens)
endfunction

let &cpo= s:save_cpo
unlet s:save_cpo
